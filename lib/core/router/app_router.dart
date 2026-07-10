import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/bookshelf/import/import_screen.dart';
import '../../features/bookshelf/screens/bookshelf_screen.dart';
import '../../domain/models/book.dart';
import '../../domain/models/book_ext.dart';
import '../../domain/models/search_book.dart';
import '../../features/book_detail/screens/book_detail_screen.dart';
import '../../features/discover/screens/discover_screen.dart';
import '../../features/reader/epub/epub_reader_screen.dart';
import '../../features/reader/pdf/pdf_reader_screen.dart';
import '../../features/reader/screens/reader_screen.dart';
import '../../features/settings/logs/logs_screen.dart';
import '../../features/rss/screens/rss_source_list_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/search/screens/search_screen.dart';
import '../../features/source_manager/screens/qr_scan_screen.dart';
import '../../features/source_manager/screens/source_edit_screen.dart';
import '../../features/source_manager/screens/source_list_screen.dart';
import '../../domain/models/book_source.dart';

/// 应用路由定义
///
/// 对标原：MainRoute.kt
/// 底部 5 个 Tab：书架、发现、RSS、AI、我的
class AppRouter {
  final GoRouter router;

  AppRouter()
    : router = GoRouter(
        initialLocation: '/bookshelf',
        routes: [
          GoRoute(
            path: '/search',
            pageBuilder: (context, state) =>
                const MaterialPage(child: SearchScreen()),
          ),
          GoRoute(
            path: '/book-detail',
            pageBuilder: (context, state) {
              final searchBook = state.extra as SearchBook;
              return MaterialPage(
                child: BookDetailScreen(searchBook: searchBook),
              );
            },
          ),
          GoRoute(
            path: '/reader',
            pageBuilder: (context, state) {
              final book = state.extra as Book;
              return MaterialPage(child: ReaderScreen(book: book));
            },
          ),
          GoRoute(
            path: '/epub-reader',
            pageBuilder: (context, state) {
              final book = state.extra as Book;
              return MaterialPage(child: EpubReaderScreen(book: book));
            },
          ),
          GoRoute(
            path: '/pdf-reader',
            pageBuilder: (context, state) {
              final book = state.extra as Book;
              return MaterialPage(child: PdfReaderScreen(book: book));
            },
          ),
          GoRoute(
            path: '/import-books',
            pageBuilder: (context, state) =>
                MaterialPage(child: const ImportScreen()),
          ),
          GoRoute(
            path: '/sources',
            pageBuilder: (context, state) =>
                const MaterialPage(child: SourceListScreen()),
          ),
          GoRoute(
            path: '/source-edit',
            pageBuilder: (context, state) {
              final source = state.extra as BookSource?;
              return MaterialPage(child: SourceEditScreen(source: source));
            },
          ),
          GoRoute(
            path: '/qr-scan',
            pageBuilder: (context, state) =>
                const MaterialPage(child: QrScanScreen()),
          ),
          GoRoute(
            path: '/logs',
            pageBuilder: (context, state) =>
                const MaterialPage(child: LogsScreen()),
          ),
          ShellRoute(
            builder: (context, state, child) =>
                ScaffoldWithNavBar(child: child),
            routes: [
              GoRoute(
                path: '/bookshelf',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: BookshelfScreen()),
              ),
              GoRoute(
                path: '/discover',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: DiscoverScreen()),
              ),
              GoRoute(
                path: '/rss',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: RssSourceListScreen()),
              ),
              GoRoute(
                path: '/ai',
                pageBuilder: (context, state) => NoTransitionPage(
                  child: _PlaceholderPage(
                    label: 'AI',
                    icon: Icons.auto_awesome,
                  ),
                ),
              ),
              GoRoute(
                path: '/profile',
                pageBuilder: (context, state) =>
                    NoTransitionPage(child: ProfileScreen()),
              ),
            ],
          ),
        ],
      );
}

/// 底部导航栏骨架
class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;

  const ScaffoldWithNavBar({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/bookshelf')) return 0;
    if (location.startsWith('/discover')) return 1;
    if (location.startsWith('/rss')) return 2;
    if (location.startsWith('/ai')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go('/bookshelf');
            case 1:
              context.go('/discover');
            case 2:
              context.go('/rss');
            case 3:
              context.go('/ai');
            case 4:
              context.go('/profile');
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.library_books_outlined),
            selectedIcon: Icon(Icons.library_books),
            label: '书架',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: '发现',
          ),
          NavigationDestination(
            icon: Icon(Icons.rss_feed_outlined),
            selectedIcon: Icon(Icons.rss_feed),
            label: 'RSS',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            selectedIcon: Icon(Icons.auto_awesome),
            label: 'AI',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outlined),
            selectedIcon: Icon(Icons.person),
            label: '我的',
          ),
        ],
      ),
    );
  }
}

/// 占位页面（后续阶段替换为真实页面）
class _PlaceholderPage extends StatelessWidget {
  final String label;
  final IconData icon;

  const _PlaceholderPage({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(label)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: theme.colorScheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              label,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '正在开发中…',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
