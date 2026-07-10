import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/read_record_provider.dart';
import '../providers/replace_rule_provider.dart';
import '../screens/read_statistics_screen.dart';
import '../screens/replace_rule_screen.dart';
import 'reader_config_provider.dart';

/// 阅读设置底部弹窗
class ReaderSettingsSheet extends ConsumerWidget {
  const ReaderSettingsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(readerConfigProvider);
    final notifier = ref.read(readerConfigProvider.notifier);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            // 拖拽指示条
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            // 标题
            const Text(
              '阅读设置',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(color: Colors.white24, height: 1),
            const SizedBox(height: 16),
            // 配置项列表
            Expanded(
              child: ListView(
                children: [
                  // 字体大小
                  _ConfigSlider(
                    icon: Icons.text_fields,
                    label: '字体大小',
                    value: config.fontSize,
                    min: 12,
                    max: 40,
                    displayValue: '${config.fontSize.round()}',
                    onChanged: notifier.setFontSize,
                  ),
                  const SizedBox(height: 8),
                  // 行距
                  _ConfigSlider(
                    icon: Icons.format_line_spacing,
                    label: '行距',
                    value: config.lineHeight,
                    min: 1.0,
                    max: 3.0,
                    displayValue: config.lineHeight.toStringAsFixed(1),
                    divisions: 20,
                    onChanged: notifier.setLineHeight,
                  ),
                  const SizedBox(height: 8),
                  // 上下边距
                  _ConfigSlider(
                    icon: Icons.vertical_align_top,
                    label: '上边距',
                    value: config.margin.top,
                    min: 8,
                    max: 48,
                    displayValue: '${config.margin.top.round()}px',
                    onChanged: notifier.setMarginTop,
                  ),
                  const SizedBox(height: 8),
                  _ConfigSlider(
                    icon: Icons.vertical_align_bottom,
                    label: '下边距',
                    value: config.margin.bottom,
                    min: 8,
                    max: 48,
                    displayValue: '${config.margin.bottom.round()}px',
                    onChanged: notifier.setMarginBottom,
                  ),
                  const SizedBox(height: 8),
                  _ConfigSlider(
                    icon: Icons.horizontal_rule,
                    label: '左右边距',
                    value: config.margin.left,
                    min: 8,
                    max: 48,
                    displayValue: '${config.margin.left.round()}px',
                    onChanged: (v) {
                      notifier.setMarginLeft(v);
                      notifier.setMarginRight(v);
                    },
                  ),
                  const SizedBox(height: 16),
                  // 背景/主题选择
                  const _SectionTitle('主题'),
                  const SizedBox(height: 8),
                  _ThemePicker(config: config, onSelect: notifier.setTheme),
                  const SizedBox(height: 16),
                  // 翻页模式
                  const _SectionTitle('翻页模式'),
                  const SizedBox(height: 8),
                  _PageAnimSelector(
                    current: config.pageAnimation,
                    onSelect: notifier.setPageAnimation,
                  ),
                  const SizedBox(height: 16),
                  // 亮度
                  const _SectionTitle('亮度'),
                  const SizedBox(height: 8),
                  _BrightnessSlider(
                    brightness: config.brightness,
                    followSystem: config.followSystemBrightness,
                    onChanged: notifier.setBrightness,
                    onFollowSystemChanged: notifier.setFollowSystemBrightness,
                  ),
                  const SizedBox(height: 16),
                  // 替换净化
                  const _SectionTitle('内容过滤'),
                  const SizedBox(height: 8),
                  _ReplaceRuleEntry(),
                  const SizedBox(height: 16),
                  // 阅读统计
                  const _SectionTitle('阅读统计'),
                  const SizedBox(height: 8),
                  _ReadStatsEntry(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 配置滑块组件
class _ConfigSlider extends StatelessWidget {
  final IconData icon;
  final String label;
  final double value;
  final double min;
  final double max;
  final String displayValue;
  final int? divisions;
  final ValueChanged<double> onChanged;

  const _ConfigSlider({
    required this.icon,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.displayValue,
    this.divisions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 18),
        const SizedBox(width: 8),
        SizedBox(
          width: 56,
          child: Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ),
        Expanded(
          child: SliderTheme(
            data: SliderThemeData(
              activeTrackColor: Colors.white70,
              inactiveTrackColor: Colors.white24,
              thumbColor: Colors.white,
              overlayColor: Colors.white.withValues(alpha: 0.12),
              trackHeight: 2,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
        ),
        SizedBox(
          width: 40,
          child: Text(
            displayValue,
            style: const TextStyle(color: Colors.white54, fontSize: 12),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

/// 替换净化入口
class _ReplaceRuleEntry extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(replaceRuleProvider);
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ReplaceRuleScreen()),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          children: [
            Icon(
              state.replaceEnabled
                  ? Icons.auto_fix_high
                  : Icons.auto_fix_high_outlined,
              color: Colors.white70,
              size: 20,
            ),
            const SizedBox(width: 12),
            const Text('替换净化', style: TextStyle(color: Colors.white70)),
            const Spacer(),
            Text(
              state.replaceEnabled ? '${state.enabledRules.length} 条规则' : '已禁用',
              style: const TextStyle(color: Colors.white38, fontSize: 12),
            ),
            const Icon(Icons.chevron_right, color: Colors.white38, size: 18),
          ],
        ),
      ),
    );
  }
}

/// 阅读统计入口
class _ReadStatsEntry extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(readStatsProvider);
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ReadStatisticsScreen()),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          children: [
            Icon(Icons.bar_chart, color: Colors.white70, size: 20),
            const SizedBox(width: 12),
            const Text('阅读统计', style: TextStyle(color: Colors.white70)),
            const Spacer(),
            Text(
              _formatDurationShort(state.totalReadTime),
              style: const TextStyle(color: Colors.white38, fontSize: 12),
            ),
            const Icon(Icons.chevron_right, color: Colors.white38, size: 18),
          ],
        ),
      ),
    );
  }

  String _formatDurationShort(int ms) {
    final minutes = (ms / 60000).round();
    if (minutes >= 60) {
      return '${minutes ~/ 60}h ${minutes % 60}m';
    }
    return '${minutes}m';
  }
}

/// 小节标题
class _SectionTitle extends StatelessWidget {
  final String label;
  const _SectionTitle(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: Colors.white54,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

/// 主题选择器
class _ThemePicker extends StatelessWidget {
  final ReaderConfigState config;
  final ValueChanged<ReaderTheme> onSelect;

  const _ThemePicker({required this.config, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: ReaderTheme.all.map((theme) {
        final isSelected = config.theme == theme;
        return GestureDetector(
          onTap: () => onSelect(theme),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: theme.bgColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? Colors.white : Colors.white24,
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.3),
                            blurRadius: 4,
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Icon(
                    isSelected ? Icons.check : Icons.text_fields,
                    color: isSelected
                        ? Colors.white
                        : theme.textColor.withValues(alpha: 0.3),
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                theme.name,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white54,
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

/// 翻页模式选择器
class _PageAnimSelector extends StatelessWidget {
  final PageAnimationMode current;
  final ValueChanged<PageAnimationMode> onSelect;

  const _PageAnimSelector({required this.current, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: PageAnimationMode.values.map((mode) {
        final isSelected = current == mode;
        return ActionChip(
          label: Text(mode.label),
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontSize: 12,
          ),
          backgroundColor: isSelected
              ? Colors.white.withValues(alpha: 0.2)
              : Colors.white.withValues(alpha: 0.08),
          side: BorderSide(color: isSelected ? Colors.white54 : Colors.white12),
          onPressed: () => onSelect(mode),
          padding: const EdgeInsets.symmetric(horizontal: 4),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        );
      }).toList(),
    );
  }
}

/// 亮度调节
class _BrightnessSlider extends StatelessWidget {
  final double brightness;
  final bool followSystem;
  final ValueChanged<double> onChanged;
  final ValueChanged<bool> onFollowSystemChanged;

  const _BrightnessSlider({
    required this.brightness,
    required this.followSystem,
    required this.onChanged,
    required this.onFollowSystemChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              brightness < 0.3 ? Icons.brightness_2 : Icons.brightness_6,
              color: Colors.white70,
              size: 18,
            ),
            const SizedBox(width: 8),
            const SizedBox(
              width: 56,
              child: Text(
                '亮度',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ),
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: Colors.white70,
                  inactiveTrackColor: Colors.white24,
                  thumbColor: Colors.white,
                  overlayColor: Colors.white.withValues(alpha: 0.12),
                  trackHeight: 2,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 6,
                  ),
                ),
                child: Slider(
                  value: brightness,
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                  onChanged: followSystem ? null : onChanged,
                ),
              ),
            ),
            SizedBox(
              width: 36,
              child: Text(
                '${(brightness * 100).round()}%',
                style: const TextStyle(color: Colors.white54, fontSize: 12),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        Row(
          children: [
            const SizedBox(width: 82),
            InkWell(
              onTap: () => onFollowSystemChanged(!followSystem),
              child: Row(
                children: [
                  Icon(
                    followSystem
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    color: Colors.white54,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    '跟随系统',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
