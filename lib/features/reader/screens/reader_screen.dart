import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/models/book.dart';
import '../../../domain/models/book_ext.dart';
import '../../../domain/models/bookmark.dart' as bookmark_model;
import '../../tts/providers/tts_provider.dart';
import '../../tts/screens/tts_control_sheet.dart';
import '../config/reader_config_provider.dart';
import '../config/reader_settings_sheet.dart';
import '../providers/bookmark_provider.dart';
import '../providers/read_record_provider.dart';
import '../providers/reader_provider.dart';
import '../providers/replace_rule_provider.dart';
import '../services/replace_rule_service.dart';
import '../../../core/utils/chinese_convert.dart';
import '../dictionary/dict_sheet.dart';
import '../widgets/page_views/page_view_selector.dart';
import '../widgets/paginated_reader_view.dart';

/// 阅读器页面
class ReaderScreen extends ConsumerStatefulWidget {
  final Book book;

  const ReaderScreen({super.key, required this.book});

  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen> {
  bool _isMenuVisible = false;
  bool _isSimplified = true;

  /// 获取经过简繁转换的文本
  String _convertText(String text) {
    if (_isSimplified) {
      // 转为简体
      if (ChineseConvert.isTraditional(text)) {
        return ChineseConvert.t2s(text);
      }
      return text;
    } else {
      // 转为繁体
      if (ChineseConvert.isSimplified(text)) {
        return ChineseConvert.s2t(text);
      }
      return text;
    }
  }

  /// 显示查词弹窗
  void _showDictLookup(BuildContext context) {
    final wordCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('查词'),
        content: TextField(
          controller: wordCtrl,
          decoration: const InputDecoration(
            hintText: '输入要查询的单词',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              final word = wordCtrl.text.trim();
              if (word.isNotEmpty) {
                Navigator.pop(ctx);
                DictSheet.open(context, word);
              }
            },
            child: const Text('查询'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _enterFullScreen();
    // 加载本书的书签
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(bookmarkProvider.notifier)
          .loadByBook(widget.book.name, widget.book.author);
    });
    // 开始阅读会话计时
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(readStatsProvider.notifier)
          .startReadingSession(widget.book.name, widget.book.author);
    });
  }

  @override
  void dispose() {
    // 结束阅读会话，记录阅读时长（fire-and-forget，捕获异常防止 Zone 级崩溃）
    unawaited(
      ref
          .read(readStatsProvider.notifier)
          .endReadingSession()
          .catchError((_) {}),
    );
    _exitFullScreen();
    super.dispose();
  }

  void _enterFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  void _exitFullScreen() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
  }

  void _toggleMenu() {
    setState(() {
      _isMenuVisible = !_isMenuVisible;
    });
  }

  /// 切换当前章节书签
  void _toggleBookmark(ReaderState state) {
    final bmProvider = ref.read(bookmarkProvider.notifier);
    if (bmProvider.hasBookmarkAt(state.currentIndex)) {
      final existing = bmProvider.getBookmarkAt(state.currentIndex);
      if (existing?.time != null) {
        bmProvider.removeBookmark(existing!.time!);
      }
    } else {
      final chapter = state.currentChapter;
      if (chapter != null) {
        bmProvider.addBookmark(
          bookmark_model.Bookmark(
            bookName: widget.book.name,
            bookAuthor: widget.book.author,
            chapterIndex: state.currentIndex,
            chapterPos: 0,
            chapterName: chapter.title,
            bookText: '',
            content: '',
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(readerProvider(widget.book));
    final provider = ref.read(readerProvider(widget.book).notifier);
    final config = ref.watch(readerConfigProvider);
    final bmState = ref.watch(bookmarkProvider);
    final replaceState = ref.watch(replaceRuleProvider);
    final hasBm = bmState.bookmarks.any(
      (b) => b.chapterIndex == state.currentIndex,
    );

    return Scaffold(
      backgroundColor: config.theme.bgColor,
      body: Stack(
        children: [
          // 内容区域
          _buildContent(state, provider, config, replaceState),

          // 菜单层
          if (_isMenuVisible) ...[
            _buildAppBar(context, state, provider, config, hasBm),
            _buildBottomBar(context, state, provider),
          ],

          // 点击区域（中央切换菜单）
          _buildTapOverlay(state, provider),
        ],
      ),
    );
  }

  Widget _buildContent(
    ReaderState state,
    ReaderProvider provider,
    ReaderConfigState config,
    ReplaceRuleState replaceState,
  ) {
    final service = ReplaceRuleService();

    if (state.isLoadingChapters) {
      return Center(
        child: CircularProgressIndicator(
          color: config.theme.textColor.withValues(alpha: 0.5),
        ),
      );
    }

    if (state.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            state.error!,
            style: TextStyle(
              color: config.theme.textColor.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (state.chapters.isEmpty) {
      return Center(
        child: Text(
          '暂无章节',
          style: TextStyle(
            color: config.theme.textColor.withValues(alpha: 0.7),
          ),
        ),
      );
    }

    final pageWidgets = state.chapters.asMap().entries.map((entry) {
      final index = entry.key;
      final content = state.contents[index];
      if (content == null) {
        return Center(
          child: CircularProgressIndicator(
            color: config.theme.textColor.withValues(alpha: 0.5),
          ),
        );
      }

      // 本地 TXT 书籍使用分页排版引擎（每个章节独立的 PaginatedReaderView）
      if (state.book.isLocalBook) {
        return PaginatedReaderView(
          key: ValueKey('chapter_$index'),
          book: state.book,
          chapterIndex: index,
        );
      }

      return SingleChildScrollView(
        padding: config.margin,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _convertText(state.chapters[index].title),
              style: TextStyle(
                color: config.theme.textColor,
                fontSize: config.fontSize + 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            SelectableText(
              replaceState.replaceEnabled
                  ? service.applyRules(
                      content: _convertText(content),
                      rules: replaceState.enabledRules,
                      chapterTitle: _convertText(state.chapters[index].title),
                    )
                  : _convertText(content),
              style: TextStyle(
                color: config.theme.textColor,
                fontSize: config.fontSize,
                height: config.lineHeight,
              ),
            ),
            const SizedBox(height: 40),
            if (!state.hasNext)
              Center(
                child: Text(
                  '已到达最后一章',
                  style: TextStyle(
                    color: config.theme.textColor.withValues(alpha: 0.4),
                  ),
                ),
              ),
          ],
        ),
      );
    }).toList();

    return PageViewSelector(
      currentIndex: state.currentIndex,
      onPageChanged: (index) {
        if (index != state.currentIndex) {
          provider.loadChapter(index);
        }
      },
      mode: config.pageAnimation,
      children: pageWidgets,
    );
  }

  Widget _buildTapOverlay(ReaderState state, ReaderProvider provider) {
    return Positioned.fill(
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                if (_isMenuVisible) {
                  _toggleMenu();
                } else {
                  provider.goToPrevious();
                }
              },
              behavior: HitTestBehavior.translucent,
              child: Container(color: Colors.transparent),
            ),
          ),
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: _toggleMenu,
              behavior: HitTestBehavior.translucent,
              child: Container(color: Colors.transparent),
            ),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                if (_isMenuVisible) {
                  _toggleMenu();
                } else {
                  provider.goToNext();
                }
              },
              behavior: HitTestBehavior.translucent,
              child: Container(color: Colors.transparent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(
    BuildContext context,
    ReaderState state,
    ReaderProvider provider,
    ReaderConfigState config,
    bool hasBookmark,
  ) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: AppBar(
          backgroundColor: config.theme.bgColor.withValues(alpha: 0.95),
          foregroundColor: config.theme.textColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              provider.saveProgress();
              Navigator.pop(context);
            },
          ),
          title: Text(state.book.name, style: const TextStyle(fontSize: 16)),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(hasBookmark ? Icons.bookmark : Icons.bookmark_border),
              tooltip: hasBookmark ? '删除书签' : '添加书签',
              onPressed: () => _toggleBookmark(state),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(
    BuildContext context,
    ReaderState state,
    ReaderProvider provider,
  ) {
    final config = ref.watch(readerConfigProvider);
    final bmState = ref.watch(bookmarkProvider);

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Container(
          color: config.theme.bgColor.withValues(alpha: 0.95),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 章节标题和进度
              Text(
                '${state.currentChapter?.title ?? ''}  (${state.currentIndex + 1}/${state.chapters.length})',
                style: TextStyle(
                  color: config.theme.textColor.withValues(alpha: 0.7),
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              // 操作按钮
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _BottomBarButton(
                    icon: Icons.arrow_back_ios,
                    label: '上一章',
                    onPressed: state.hasPrevious ? provider.goToPrevious : null,
                  ),
                  _BottomBarButton(
                    icon: Icons.format_list_bulleted,
                    label: '目录',
                    onPressed: () =>
                        _showChapterList(context, state, provider, config),
                  ),
                  _BottomBarButton(
                    icon: Icons.bookmark_outline,
                    label: '书签',
                    onPressed: () => _showBookmarkList(
                      context,
                      bmState,
                      ref.read(bookmarkProvider.notifier),
                    ),
                  ),
                  _BottomBarButton(
                    icon: Icons.text_fields,
                    label: '简繁',
                    onPressed: () {
                      setState(() {
                        _isSimplified = !_isSimplified;
                      });
                    },
                  ),
                  _BottomBarButton(
                    icon: Icons.volume_up_outlined,
                    label: '朗读',
                    onPressed: () =>
                        _showTtsControl(context, ref, state, provider),
                  ),
                  _BottomBarButton(
                    icon: Icons.menu_book,
                    label: '查词',
                    onPressed: () => _showDictLookup(context),
                  ),
                  _BottomBarButton(
                    icon: Icons.settings,
                    label: '设置',
                    onPressed: () => _showSettings(context),
                  ),
                  _BottomBarButton(
                    icon: Icons.arrow_forward_ios,
                    label: '下一章',
                    onPressed: state.hasNext ? provider.goToNext : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 显示章节列表弹窗
void _showChapterList(
  BuildContext context,
  ReaderState state,
  ReaderProvider provider,
  ReaderConfigState config,
) {
  showModalBottomSheet(
    context: context,
    backgroundColor: config.theme.bgColor.withValues(alpha: 0.98),
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '目录 (${state.chapters.length} 章)',
              style: TextStyle(color: config.theme.textColor, fontSize: 16),
            ),
          ),
          Divider(
            color: config.theme.textColor.withValues(alpha: 0.2),
            height: 1,
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: state.chapters.length,
              itemBuilder: (context, index) {
                final chapter = state.chapters[index];
                final isCurrent = index == state.currentIndex;
                return ListTile(
                  dense: true,
                  selected: isCurrent,
                  selectedTileColor: config.theme.textColor.withValues(
                    alpha: 0.1,
                  ),
                  title: Text(
                    chapter.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isCurrent
                          ? config.theme.textColor
                          : config.theme.textColor.withValues(alpha: 0.7),
                      fontWeight: isCurrent
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  trailing: isCurrent
                      ? Icon(
                          Icons.chevron_right,
                          color: config.theme.textColor.withValues(alpha: 0.5),
                          size: 18,
                        )
                      : null,
                  onTap: () {
                    Navigator.pop(context);
                    provider.loadChapter(index);
                  },
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}

/// 显示书签列表弹窗
void _showBookmarkList(
  BuildContext context,
  BookmarkState bmState,
  BookmarkProvider bmProvider,
) {
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xF00D0D0D),
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '书签 (${bmState.bookmarks.length})',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          const Divider(color: Colors.white24, height: 1),
          if (bmState.bookmarks.isEmpty)
            const Expanded(
              child: Center(
                child: Text('暂无书签', style: TextStyle(color: Colors.white54)),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: bmState.bookmarks.length,
                itemBuilder: (context, index) {
                  final bm = bmState.bookmarks[index];
                  return ListTile(
                    dense: true,
                    title: Text(
                      bm.chapterName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    subtitle: bm.bookText.isNotEmpty
                        ? Text(
                            bm.bookText,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white38,
                              fontSize: 12,
                            ),
                          )
                        : null,
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.white38,
                        size: 18,
                      ),
                      onPressed: () {
                        if (bm.time != null) {
                          bmProvider.removeBookmark(bm.time!);
                        }
                      },
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: 跳转到书签所在章节
                    },
                  );
                },
              ),
            ),
        ],
      ),
    ),
  );
}

/// 显示 TTS 朗读控制面板
void _showTtsControl(
  BuildContext context,
  WidgetRef ref,
  ReaderState state,
  ReaderProvider provider,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      // 注入当前章节内容作为朗读队列
      final ttsNotifier = ref.read(ttsProvider.notifier);
      final currentContent = state.currentContent;
      if (currentContent != null) {
        final paragraphs = currentContent
            .split('\n')
            .where((p) => p.trim().isNotEmpty)
            .toList();
        ttsNotifier.setParagraphQueue(paragraphs);

        // 设置章节切换回调
        ttsNotifier.setNextChapterCallback(() async {
          if (state.hasNext) {
            await provider.goToNext();
            // 等待内容加载完成
            await Future.delayed(const Duration(milliseconds: 300));
            return state.currentContent
                    ?.split('\n')
                    .where((p) => p.trim().isNotEmpty)
                    .toList() ??
                [];
          }
          return [];
        });
        ttsNotifier.setPrevChapterCallback(() async {
          if (state.hasPrevious) {
            await provider.goToPrevious();
            await Future.delayed(const Duration(milliseconds: 300));
            return state.currentContent
                    ?.split('\n')
                    .where((p) => p.trim().isNotEmpty)
                    .toList() ??
                [];
          }
          return [];
        });
      }

      return SizedBox(height: 400, child: const TtsControlSheet());
    },
  );
}

/// 显示阅读设置弹窗
void _showSettings(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xF00D0D0D),
    builder: (context) => SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: const ReaderSettingsSheet(),
    ),
  );
}

class _BottomBarButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  const _BottomBarButton({
    required this.icon,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: onPressed != null ? Colors.white70 : Colors.white30,
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: onPressed != null ? Colors.white70 : Colors.white30,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
