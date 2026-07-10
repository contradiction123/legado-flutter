import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private let fileShareChannelName = "com.legado.legado_flutter/file_share"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let result = super.application(application, didFinishLaunchingWithOptions: launchOptions)

    if let controller = window?.rootViewController as? FlutterViewController {
      configureFileShareChannel(messenger: controller.binaryMessenger)
    }

    return result
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "FileShareChannel")
    configureFileShareChannel(messenger: registrar.messenger())
  }

  private func configureFileShareChannel(messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(name: fileShareChannelName, binaryMessenger: messenger)
    channel.setMethodCallHandler { [weak self] call, result in
      guard call.method == "shareFile" else {
        result(FlutterMethodNotImplemented)
        return
      }

      guard
        let arguments = call.arguments as? [String: Any],
        let path = arguments["path"] as? String,
        !path.isEmpty
      else {
        result(FlutterError(code: "invalid_path", message: "Path is empty", details: nil))
        return
      }

      let title = arguments["title"] as? String ?? "share"
      self?.shareFile(path: path, title: title, result: result)
    }
  }

  private func shareFile(path: String, title: String, result: @escaping FlutterResult) {
    let fileUrl = URL(fileURLWithPath: path)

    DispatchQueue.main.async {
      guard let presenter = Self.topViewController() else {
        result(FlutterError(code: "no_presenter", message: "No view controller to present share sheet", details: nil))
        return
      }

      let activityController = UIActivityViewController(
        activityItems: [fileUrl],
        applicationActivities: nil
      )
      activityController.popoverPresentationController?.sourceView = presenter.view
      activityController.popoverPresentationController?.sourceRect = CGRect(
        x: presenter.view.bounds.midX,
        y: presenter.view.bounds.midY,
        width: 1,
        height: 1
      )
      presenter.present(activityController, animated: true) {
        result(nil)
      }
    }
  }

  private static func topViewController(
    base: UIViewController? = {
      let connectedScenes = UIApplication.shared.connectedScenes
        .compactMap { $0 as? UIWindowScene }
      let keyWindow = connectedScenes
        .flatMap { $0.windows }
        .first(where: \.isKeyWindow)
      return keyWindow?.rootViewController
    }()
  ) -> UIViewController? {
    if let navigationController = base as? UINavigationController {
      return topViewController(base: navigationController.visibleViewController)
    }
    if let tabBarController = base as? UITabBarController,
       let selected = tabBarController.selectedViewController {
      return topViewController(base: selected)
    }
    if let presented = base?.presentedViewController {
      return topViewController(base: presented)
    }
    return base
  }
}
