import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/search_provider.dart';
import '../widgets/search_result_card.dart';

/// 搜索页面
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    // 延迟加载历史记录
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(searchProvider.notifier).loadHistory();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _performSearch() {
    final keyword = _controller.text.trim();
    if (keyword.isNotEmpty) {
      _focusNode.unfocus();
      ref.read(searchProvider.notifier).search(keyword);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchProvider);
    final provider = ref.read(searchProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          focusNode: _focusNode,
          autofocus: true,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: '搜索书名或作者',
            border: InputBorder.none,
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                      setState(() {});
                    },
                  )
                : null,
          ),
          onChanged: (_) => setState(() {}),
          onSubmitted: (_) => _performSearch(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _performSearch,
          ),
        ],
      ),
      body: _buildBody(context, state, provider),
    );
  }

  Widget _buildBody(BuildContext context, SearchState state, SearchProvider provider) {
    if (state.isLoading) {
      return _buildLoading(state);
    }

    if (state.error != null) {
      return _buildError(state);
    }

    if (!state.hasSearched) {
      return _buildHistory(context, state, provider);
    }

    if (state.results.isEmpty) {
      return _buildEmpty();
    }

    return _buildResults(state);
  }

  Widget _buildLoading(SearchState state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            '正在搜索... (${state.completedSources}/${state.totalSources})',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildError(SearchState state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              state.error!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistory(BuildContext context, SearchState state, SearchProvider provider) {
    if (state.history.isEmpty) {
      return Center(
        child: Text(
          '输入关键词开始搜索',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '搜索历史',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            TextButton(
              onPressed: provider.clearHistory,
              child: const Text('清空'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: state.history.map((keyword) {
            return InputChip(
              label: Text(keyword),
              onPressed: () {
                _controller.text = keyword;
                _performSearch();
              },
              onDeleted: () => provider.removeHistory(keyword),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            '未找到相关书籍',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResults(SearchState state) {
    return ListView.separated(
      itemCount: state.results.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final book = state.results[index];
        return SearchResultCard(
          book: book,
          onTap: () {
            context.push('/book-detail', extra: book);
          },
        );
      },
    );
  }
}
