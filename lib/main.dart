import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/di/injection_container.dart' as di;
import 'core/logging/app_logger.dart';
import 'core/logging/log_tag.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.initDependencyInjection();
  AppLogger.instance.info(LogTag.appLifecycle, 'Application started');

  runApp(const ProviderScope(child: LegadoApp()));
}

class LegadoApp extends ConsumerWidget {
  const LegadoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = AppRouter();

    return MaterialApp.router(
      title: 'Legado',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: appRouter.router,
    );
  }
}
