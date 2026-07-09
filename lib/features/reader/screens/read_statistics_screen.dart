import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/dao/read_record_dao.dart';
import '../providers/read_record_provider.dart';

/// 阅读统计页面
class ReadStatisticsScreen extends ConsumerWidget {
  const ReadStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(readStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('阅读统计'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(readStatsProvider.notifier).loadStats(),
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // 总览卡片
                _OverviewCards(stats: state),
                const SizedBox(height: 24),
                // 近 7 天阅读时间柱状图
                _DailyChart(recentStats: state.recentStats),
                const SizedBox(height: 24),
                // 今日阅读
                _TodayCard(todayReadTime: state.todayReadTime),
                const SizedBox(height: 24),
                // 连续阅读
                _StreakCard(streakDays: state.streakDays),
                const SizedBox(height: 24),
                // 刷新
                Center(
                  child: TextButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('刷新统计数据'),
                    onPressed: () =>
                        ref.read(readStatsProvider.notifier).loadStats(),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
    );
  }
}

/// 总览卡片
class _OverviewCards extends StatelessWidget {
  final ReadStatsState stats;

  const _OverviewCards({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '总览',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.timer_outlined,
                label: '总阅读时长',
                value: _formatDuration(stats.totalReadTime),
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.menu_book,
                label: '读过本书',
                value: '${stats.readBookCount}',
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// 近 7 天阅读时间
class _DailyChart extends StatelessWidget {
  final List<DateReadStats> recentStats;

  const _DailyChart({required this.recentStats});

  @override
  Widget build(BuildContext context) {
    final maxTime = recentStats.fold<int>(
        0, (max, s) => s.readTime > max ? s.readTime : max);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '近 7 天阅读',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: recentStats.map((stat) {
              final ratio = maxTime > 0 ? stat.readTime / maxTime : 0.0;
              final barHeight = (ratio * 80).clamp(4.0, 80.0);
              final dateParts = stat.date.split('-');
              final label = '${dateParts[1]}/${dateParts[2]}';

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        _formatDurationShort(stat.readTime),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontSize: 9,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 24,
                        height: barHeight,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withValues(
                            alpha: 0.3 + ratio * 0.7,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        label,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontSize: 9,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

/// 今日阅读卡片
class _TodayCard extends StatelessWidget {
  final int todayReadTime;

  const _TodayCard({required this.todayReadTime});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '今日阅读',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.today,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatDuration(todayReadTime),
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      '今日有效阅读时长',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// 连续阅读天数
class _StreakCard extends StatelessWidget {
  final int streakDays;

  const _StreakCard({required this.streakDays});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '连续阅读',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.local_fire_department,
                  color: streakDays > 0 ? Colors.orange : Colors.grey,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$streakDays 天',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: streakDays > 0 ? Colors.orange : null,
                          ),
                    ),
                    Text(
                      streakDays > 0 ? '连续阅读天数' : '还没有连续阅读记录',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// 单个统计卡片
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 格式化毫秒为 "X 小时 Y 分钟"
String _formatDuration(int ms) {
  final totalMinutes = (ms / 60000).round();
  final hours = totalMinutes ~/ 60;
  final minutes = totalMinutes % 60;
  if (hours > 0) {
    return '$hours 小时 $minutes 分钟';
  }
  return '$minutes 分钟';
}

/// 格式化短时长 "Xm"
String _formatDurationShort(int ms) {
  final minutes = (ms / 60000).round();
  if (minutes >= 60) {
    return '${minutes ~/ 60}h';
  }
  return '${minutes}m';
}
