import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/di/injection_container.dart' as di;
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化依赖注入
  await di.initDependencyInjection();

  // 启动应用
  runApp(
    const ProviderScope(
      child: LegadoApp(),
    ),
  );
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
