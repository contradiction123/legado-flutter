# Phase 4：完整功能拓展 - 优化执行方案

> **基于当前代码分析 + 用户决策后的优化版本**
> **参考原项目**：`/Users/ocean/Desktop/code/_git/legado-with-MD3/`

---

## 当前项目状态（Flutter 端已就绪的依赖）

| 模块 | 状态 | 关键文件 |
|------|------|---------|
| 项目基础设施 | ✅ | Riverpod + GoRouter + drift + get_it |
| 数据层 | ✅ | Book, BookChapter, BookSource 等完整 DAO/Repo/Model |
| 网络引擎 | ✅ | dio + cookie + SSL + WebBook 书源引擎 |
| JS 引擎 | ✅ | flutter_js + 扩展 + 共享作用域 |
| 书架 UI | ✅ | 书架屏幕 + 分组 + 卡片展示 |
| 阅读器（TXT/网络） | ✅ | 翻页动画 + 阅读配置 + 书签 + 替换规则 |
| 发现/搜索/书源管理 | ✅ | 完整实现 |

---

## 决策记录

| 问题 | 决策 |
|------|------|
| 分页引擎 | 🔧 **先补齐分页引擎**，再进入 Phase 4 |
| EPUB 渲染方案 | 🌐 **webview_flutter** 内嵌 WebView |
| MOBI / UMD | ❌ **暂不实现**，全项目完成后调研 |
| 本地书籍入口 | 📁 **书架上增加导入入口** |
| 交付策略 | 🎯 **按优先级分三批交付** |

---

## 新增依赖（pubspec.yaml）

```yaml
dependencies:
  # ---- Phase 4 新增 ----
  # 分页引擎（Step 0）
  # 无新增依赖，使用现有 Flutter 排版能力

  # EPUB 解析 + 渲染（Step 1）
  archive: ^4.0.3                    # ✅ 已存在（解压 EPUB）
  xml: ^6.5.0                        # 🔄 新增（解析 OPF/NCX）
  webview_flutter: ^4.10.0           # 🆕 新增（EPUB HTML 渲染）

  # PDF 阅读（Step 2）
  pdfx: ^2.6.0                       # 🆕 新增（PDF 渲染）

  # TTS 朗读（Step 3）
  flutter_tts: ^4.2.1                # 🆕 新增（系统 TTS）

  # 有声书（Step 4）
  just_audio: ^0.9.42                # 🆕 新增（音频播放）

  # 漫画（Step 5）
  cached_network_image: ^3.4.1       # ✅ 已存在
  photo_view: ^0.15.0                # 🆕 新增（图片缩放）

  # 本地导入（Step 6）
  file_picker: ^8.1.6                # 🆕 新增（文件选择）
  chardet: ^0.2.1                    # 🆕 新增（编码检测）
  path: ^1.9.1                       # ✅ 已存在
```

---

## 执行计划（三批交付）

---

# 🔥 第一批：核心基础（优先级 P0）

---

## 步骤 4.0：分页排版引擎（前置依赖）

> **预计工时**：4-5 天
> **目标**：将当前的滚动长文本阅读改为真正的分页排版

### 做什么

原版 Legado 的阅读体验核心是**分页**——每个章节内容根据**字体大小、行高、边距**等配置，逐行测量、逐页分割，形成 `TextPage` 列表。当前 Flutter 实现只是一个滚动的 `SelectableText`。

需要将原版的分页引擎移植到 Flutter。

### 参考的原项目代码

| 文件 | 功能 |
|------|------|
| `page/provider/TextChapterLayout.kt` | **章节排版引擎核心** — 调用 TextMeasure 逐行测量，生成 TextPage 列表 |
| `page/provider/TextPageFactory.kt` | 按章节构建 TextPage 工厂类 |
| `page/provider/TextMeasure.kt` | **文字测量** — 使用 Paint 测量每行文本宽度高度 |
| `page/provider/CharStyle.kt` | 字符样式定义（粗体/斜体/颜色/下划线等） |
| `page/provider/ZhLayout.kt` | 中文排版特殊处理（首行缩进、段间距等） |
| `page/entities/TextPage.kt` | 分页结果 - 包含行列表、位置信息 |
| `page/entities/TextLine.kt` | 单行文本 - 包含字符列表、行高 |
| `page/entities/TextParagraph.kt` | 段落 - 包含行列表、段间距 |
| `page/entities/TextPos.kt` | 文本位置（用于跳转到指定位置） |
| `page/entities/column/TextColumn.kt` | 纯文本列（普通章节） |
| `page/entities/column/TextHtmlColumn.kt` | **HTML 列（EPUB 章节用）** |
| `page/entities/column/ImageColumn.kt` | 图片列 |
| `page/delegate/PageDelegate.kt` | 翻页代理基类 |
| `page/delegate/SimulationPageDelegate.kt` | 仿真翻页 |
| `page/delegate/SlidePageDelegate.kt` | 滑动翻页 |
| `page/delegate/ScrollPageDelegate.kt` | 滚动翻页 |
| `page/delegate/FadePageDelegate.kt` | 淡入淡出翻页 |

### Flutter 实现方案

由于 Flutter 没有 Android `Paint` 那样的低级文本测量 API，需要用不同思路实现：

**分层架构**：

```
lib/features/reader/layout/
├── text_measurer.dart          — 文本测量器（用 TextPainter 替代 Paint）
├── text_page_builder.dart      — 文本 → TextPage 列表的构建器
├── text_page_layout.dart       — 分页排版引擎核心（对标 TextChapterLayout）
├── text_line.dart              — 单行数据模型（对标 TextLine）
├── text_page.dart              — 分页数据模型（对标 TextPage）
├── text_paragraph.dart         — 段落数据模型（对标 TextParagraph）
├── page_content.dart           — 页面内容基类（对标 Column 系列）
│   ├── text_column.dart        — 纯文本页
│   ├── html_column.dart        — HTML 页（EPUB 用）
│   └── image_column.dart       — 图片页
├── page_delegate.dart          — 翻页代理接口
│   ├── simulation_page.dart    — 仿真翻页（改造现有）
│   ├── slide_page.dart         — 滑动翻页（改造现有）
│   └── scroll_page.dart        — 滚动翻页（改造现有）
└── providers/
    └── page_layout_provider.dart — 排版状态管理（监听字体/行高变化自动重排）
```

### 关键技术难点

| 难点 | 原版方案 | Flutter 方案 | 风险 |
|------|---------|-------------|------|
| 文本宽度测量 | `Paint.measureText()` | `TextPainter` — 先构建再测量 | 🟡 中，Flutter 测量需先有 `TextSpan` |
| 逐行分割 | 循环测量直到填满页高 | 同样用 TextPainter 逐行累加 | 🟡 中，注意性能优化 |
| 行高计算 | `Paint.getFontMetrics()` | `TextPainter.preferredLineHeight` | 🟢 低 |
| 中文排版 | `ZhLayout` 处理缩进/禁则 | 用 Unicode 规则 + 自定义处理 | 🟡 中，中文禁则处理需额外逻辑 |
| 性能 | Paint 测量快 | TextPainter 批量测量可接受 | 🟡 中，大章节需异步计算 |

### 完成后效果

- 每个章节根据当前阅读配置（字号/行高/边距/宽高）被精确分割为 N 页
- 翻页时自动切换 `PageView` + 分页数据
- 阅读进度精确到**页级**（`durChapterPos` — 原版字段已存在）
- 为 EPUB/PDF/漫画的页面渲染提供统一接口

### 验证标准

- [ ] 一个 5000 字章节在默认配置下能正确分成~10 页
- [ ] 改变字号后自动重排，页数变化正确
- [ ] 快速翻页（连点 20 次）无卡顿
- [ ] 可以从第 3 页继续阅读（`pagePos` 持久化）

---

## 步骤 4.1：本地书籍导入 + 入口 UI

> **预计工时**：2-3 天
> **代码目录**：`lib/features/bookshelf/import/` + `lib/engine/local_book/`

### 4.1.1 引擎层 — 本地书籍解析基础

**做什么**：创建 `LocalBook` 引擎（对标原版 `LocalBook.kt`）

创建文件：
```
lib/engine/local_book/
├── local_book.dart             — 本地书籍入口（对标 LocalBook.kt）
├── base_parser.dart            — 解析器基类接口（对标 BaseLocalBookParse）
├── text_parser.dart            — TXT 解析（含编码检测 + 目录规则，对标 TextFile.kt）
├── encoding_detector.dart      — 编码检测器（chardet 封装）
└── txt_toc_rule.dart           — TXT 目录规则解析（对标 TxtTocRule）
```

**编码检测**（对标原版 `EncodingDetect`）：
- Dart 使用 `chardet` 包检测 UTF-8/GBK/BIG5
- 短文件检测不准时提供手动选择编码的 UI 回退

**书籍格式自动识别**（对标原版 `BookHelp.isEpub/isPdf/isMobi/isUmd`）：
```dart
enum BookFormat { txt, epub, pdf, mobi, umd, unknown }

BookFormat detectFormat(String fileName) {
  final ext = fileName.split('.').last.toLowerCase();
  switch (ext) {
    case 'txt': return BookFormat.txt;
    case 'epub': return BookFormat.epub;
    case 'pdf': return BookFormat.pdf;
    case 'mobi': case 'azw3': case 'azw': return BookFormat.mobi;
    case 'umd': return BookFormat.umd;
    default: return BookFormat.unknown;
  }
}
```

### 4.1.2 UI 层 — 书架导入入口

**做什么**：在书架页面增加"导入"功能

创建文件：
```
lib/features/bookshelf/import/
├── import_button.dart          — 书架上的导入按钮组件
├── import_screen.dart          — 导入页面（文件选择 + 进度）
├── providers/
│   └── import_provider.dart    — 导入状态管理
└── widgets/
    ├── file_browser.dart       — 文件浏览器（打开 file_picker）
    ├── format_chip.dart        — 格式标签组件
    └── import_progress.dart    — 导入进度指示器
```

**修改现有文件**：
- `lib/features/bookshelf/widgets/bookshelf_appbar.dart` — 增加导入按钮
- `lib/features/bookshelf/screens/bookshelf_screen.dart` — 集成导入入口
- `lib/core/router/app_router.dart` — 注册导入页面路由

**导入流程**：
1. 用户点击书架上的"导入"按钮
2. 弹出 `file_picker`，支持单文件/多文件
3. 自动识别格式 + 编码检测
4. 解析章节列表
5. 创建 `Book` 对象（`type = text | local`）写入数据库
6. 刷新书架列表

### 参考的原项目代码

| 文件 | 功能 |
|------|------|
| `model/localBook/LocalBook.kt` | **本地书籍入口** — 导入/目录/正文/删除 |
| `model/localBook/BaseLocalBookParse.kt` | 解析器接口 |
| `model/localBook/TextFile.kt` | TXT 解析器 |
| `ui/book/import/` | 导入 UI |
| `help/book/BookHelp.kt` | 书籍工具（格式识别、封面缓存等） |

### 关键依赖风险

| 原项目 | Flutter 替代 | 风险 |
|--------|-------------|------|
| juniversalchardet（编码检测） | chardet (Dart) | 🟡 中，短文件准确率不同 |
| Android FileProvider | file_picker | 🟢 低 |
| `DocumentFile` | path_provider | 🟢 低 |

---

# 🔥 第二批：多格式阅读器（优先级 P1）

---

## 步骤 4.2：EPUB 阅读器（WebView 方案）

> **预计工时**：5-7 天
> **代码目录**：`lib/engine/local_book/epub/` + `lib/features/reader/epub/`

### 4.2.1 解析层

**做什么**：使用 `archive` + `xml` 包解析 EPUB 文件

创建文件：
```
lib/engine/local_book/epub/
├── epub_parser.dart            — EPUB 解析器（解压 + 读 OPF + 读 NCX）
├── epub_book.dart              — EPUB 模型（书名/作者/封面/章节列表/资源）
├── epub_chapter.dart           — EPUB 章节模型（原始 HTML + CSS + 资源引用）
└── epub_resource.dart          — EPUB 资源（图片/CSS/字体...）
```

**解析流程**：
1. `archive` 解压 EPUB（ZIP）
2. 读取 `META-INF/container.xml` 找到 OPF 路径
3. 解析 OPF（`package.opf`）获取元数据 + manifest + spine
4. 解析 NCX（`toc.ncx`）获取目录结构
5. 按 spine 顺序加载章节 HTML

### 4.2.2 渲染层 — WebView 方案

**用户决策**：采用 `webview_flutter` 内嵌 WebView 渲染 EPUB HTML

**做什么**：为每个 EPUB 章节创建一个 WebView，渲染章节 HTML + CSS

创建文件：
```
lib/features/reader/epub/
├── epub_renderer.dart          — EPUB 渲染器（HTML → WebView）
├── epub_page_view.dart         — EPUB 翻页视图（每个章节一个 WebView）
├── providers/
│   └── epub_provider.dart      — EPUB 阅读状态管理
└── widgets/
    ├── css_injector.dart       — CSS 注入（覆写阅读配置的字体/字号/间距）
    └── webview_page.dart       — 单个 WebView 页面组件
```

**渲染方案**：
```
┌─────────────────────────────────────────┐
│          PageView（横向翻页）              │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ │
│  │ WebView  │ │ WebView  │ │ WebView  │ │
│  │ Chapter1 │→│ Chapter2 │→│ Chapter3 │ │
│  │ HTML+CSS │ │ HTML+CSS │ │ HTML+CSS │ │
│  └──────────┘ └──────────┘ └──────────┘ │
└─────────────────────────────────────────┘
```

**CSS 覆写**（注入到 WebView 的 `<style>`）：
```javascript
// 在 WebView 加载完成后注入
function injectReaderStyles(fontSize, lineHeight, fontFamily, bgColor, textColor) {
    const style = document.createElement('style');
    style.textContent = `
        html, body {
            font-size: ${fontSize}px !important;
            line-height: ${lineHeight} !important;
            font-family: ${fontFamily} !important;
            background-color: ${bgColor} !important;
            color: ${textColor} !important;
            padding: 16px !important;
            margin: 0 !important;
        }
        img { max-width: 100% !important; height: auto !important; }
        p { margin: 0.5em 0 !important; }
    `;
    document.head.appendChild(style);
}
```

### 参考的原项目代码

| 文件 | 功能 |
|------|------|
| `model/localBook/EpubFile.kt` | EPUB 解析（解压 + OPF + NCX） |
| `modules/book/`（me.ag2s） | EPUB 解析库（OPF 解析、TOC 引用） |
| `page/entities/column/TextHtmlColumn.kt` | HTML 列排版 |

### 关键风险

| 风险 | 等级 | 说明 |
|------|------|------|
| 跨章节连续性 | 🟡 中 | PageView 跨章节切换需传递阅读位置 |
| 大文件内存 | 🟡 中 | 含大量图片的 EPUB 可能占用较多内存 |
| CSS 覆写兼容性 | 🟢 低 | WebView 方案 CSS 支持度远高于 flutter_html |
| JavaScript 交互 | 🟡 中 | 需要 Flutter ↔ WebView 双向通信（滚动位置/字体大小） |

---

## 步骤 4.3：PDF 阅读器

> **预计工时**：2-3 天
> **代码目录**：`lib/engine/local_book/pdf/` + `lib/features/reader/pdf/`

### 做什么

集成 `pdfx` 包实现 PDF 分页显示和基本操作。

创建文件：
```
lib/engine/local_book/pdf/
└── pdf_parser.dart             — PDF 解析器（对标 PdfFile.kt）

lib/features/reader/pdf/
├── pdf_reader_screen.dart      — PDF 阅读页面
├── providers/
│   └── pdf_reader_provider.dart— PDF 阅读状态管理
└── widgets/
    ├── pdf_page_view.dart      — PDF 分页视图
    ├── pdf_zoom_controls.dart  — 缩放控制
    └── pdf_page_number.dart    — 页码指示器
```

### 参考的原项目代码

| 文件 | 功能 |
|------|------|
| `model/localBook/PdfFile.kt` | PDF 解析（依赖 Android PdfRenderer） |

### 关键依赖风险

| 原项目 | Flutter 替代 | 风险 |
|--------|-------------|------|
| Android PdfRenderer | pdfx (Android: PdfRenderer, iOS: PDFKit) | 🟡 中，双端兼容 |

---

# 🔥 第三批：听书 + 漫画 + 阅读增强（优先级 P2）

---

## 步骤 4.4：TTS 朗读

> **预计工时**：4-5 天
> **代码目录**：`lib/features/tts/`

### 做什么

集成 `flutter_tts` 实现文字转语音朗读，包括控制面板和 HTTP TTS 支持。

创建文件：
```
lib/features/tts/
├── engine/
│   └── read_aloud.dart         — 朗读引擎（对标 BaseReadAloudService.kt）
├── screens/
│   └── tts_control_sheet.dart  — 朗读控制面板（对标 ReadAloudSheet.kt）
├── widgets/
│   └── tts_config_widget.dart  — 朗读配置（语速/音调/音量）
├── providers/
│   └── tts_provider.dart       — 朗读状态管理
└── models/
    └── http_tts_config.dart    — HTTP TTS 配置模型（对标 HttpTTS.kt）
```

**功能列表**：
- 系统 TTS 朗读（Android: TextToSpeech, iOS: AVSpeechSynthesizer）
- 朗读控制：播放 / 暂停 / 停止 / 跳转到指定位置
- 语速和音调调节
- HTTP TTS 支持（调用在线 TTS API返回的音频文件）
- 章节切换时自动继续朗读
- 朗读进度记录

**架构**：
```
┌──────────────┐     ┌────────────────┐     ┌──────────────┐
│  TTS Provider │────▶│  ReadAloud     │────▶│  flutter_tts │
│ (UI 状态)     │     │  引擎           │     │  (系统 TTS)  │
└──────────────┘     │  (队列管理)     │     └──────────────┘
                     └────────────────┘
                           │
                    ┌──────┴──────┐
                    ▼             ▼
              ┌──────────┐ ┌──────────┐
              │ just_audio│ │  HTTP    │
              │ (缓存)    │ │ (在线API)│
              └──────────┘ └──────────┘
```

### 参考的原项目代码

| 文件 | 功能 |
|------|------|
| `service/TTSReadAloudService.kt` | 系统 TTS 朗读服务 |
| `service/HttpReadAloudService.kt` | HTTP TTS 在线朗读服务 |
| `service/BaseReadAloudService.kt` | 朗读服务基类（状态管理 + 队列 + 回调） |
| `ui/book/read/sheet/ReadAloudSheet.kt` | 朗读控制面板 |
| `ui/book/read/sheet/ReadAloudConfigSheet.kt` | 朗读配置面板 |
| `data/entities/HttpTTS.kt` | HTTP TTS 配置实体 |

### 关键依赖风险

| 原项目 | Flutter 替代 | 风险 |
|--------|-------------|------|
| Android TTS | flutter_tts | 🟡 中，iOS 功能受限 |
| Android 前台 Service（保活后台朗读） | flutter_background_service | 🔴 **高**，iOS 后台限制严格 |
| HTTP TTS API | dio + just_audio | 🟡 中，网络音频播放 |


## 步骤 4.5：有声书播放

> **预计工时**：3-4 天
> **代码目录**：`lib/features/audio_player/`

### 做什么

集成 `just_audio` 实现音频文件播放（本地/网络）、播放列表管理和后台播放。

创建文件：
```
lib/features/audio_player/
├── screens/
│   └── audio_player_screen.dart— 有声书播放界面（对标 AudioPlayActivity.kt）
├── widgets/
│   ├── player_controls.dart    — 播放控制（播放/暂停/快进/快退/进度条）
│   ├── playlist_widget.dart    — 播放列表/章节选择
│   └── audio_timer.dart        — 定时关闭
├── providers/
│   └── audio_player_provider.dart— 音频播放状态管理
└── engine/
    └── audio_player_engine.dart— 音频播放引擎（just_audio 封装）
```

**功能列表**：
- 本地和网络音频文件播放
- 播放列表管理（章节列表自动连播）
- 播放模式：顺序 / 单曲循环 / 列表循环 / 随机
- 后台播放（锁屏控制）
- 播放进度记忆和恢复
- 定时关闭

### 参考的原项目代码

| 文件 | 功能 |
|------|------|
| `service/AudioPlayService.kt` | 音频播放服务 |
| `ui/book/audio/AudioPlayActivity.kt` | 音频播放界面 |
| `ui/book/audio/AudioPlayViewModel.kt` | 音频播放 ViewModel |

### 关键依赖风险

| 原项目 | Flutter 替代 | 风险 |
|--------|-------------|------|
| ExoPlayer / Media3 | just_audio | 🟡 中，功能对等 |
| Android MediaSession | just_audio 内置 | 🟡 中，双端支持 |


## 步骤 4.6：漫画阅读

> **预计工时**：3-4 天
> **代码目录**：`lib/features/reader/manga/`

### 做什么

实现漫画/图片流的阅读模式，支持缩放、平移和滚动画廊。

创建文件：
```
lib/features/reader/manga/
├── manga_reader_screen.dart    — 漫画阅读页面（对标 ReadMangaActivity.kt）
├── providers/
│   └── manga_provider.dart     — 漫画状态管理
├── widgets/
│   ├── manga_viewer.dart       — 漫画查看器（InteractiveViewer + 缩放）
│   ├── manga_gallery.dart      — 滚动画廊模式
│   ├── manga_progress_bar.dart — 漫画进度条
│   └── manga_settings.dart     — 漫画设置（滚动方向/双页/滤镜）
└── models/
    ├── manga_page.dart         — 漫画页面模型（对标 MangaPage.kt）
    └── manga_chapter.dart      — 漫画章节模型（对标 MangaChapter.kt）
```

**功能列表**：
- 单页 / 双页模式
- 缩放和平移（`InteractiveViewer` + `PhotoView`）
- 滚动画廊模式（上下滚动浏览）
- 图片预加载（`cached_network_image`）
- 阅读方向：从左到右 / 从右到左

### 参考的原项目代码

| 文件 | 功能 |
|------|------|
| `ui/book/manga/ReadMangaActivity.kt` | 漫画阅读 Activity |
| `ui/book/manga/ReadMangaViewModel.kt` | 漫画 ViewModel |
| `ui/book/manga/recyclerview/MangaLayoutManager.kt` | 漫画自定义布局管理器 |
| `ui/book/manga/recyclerview/MangaAdapter.kt` | 漫画适配器 |
| `ui/book/manga/entities/` | 漫画数据模型 |

### 关键依赖风险

| 原项目 | Flutter 替代 | 风险 |
|--------|-------------|------|
| 自定义 RecyclerView LayoutManager | InteractiveViewer + PhotoView | 🟢 低 |
| 图片预加载 | cached_network_image | 🟢 低 |
| 双页模式 | 自定义布局 | 🟢 低 |


## 步骤 4.7：现有阅读器改造 — 整合多格式

> **预计工时**：2-3 天

### 做什么

将现有的 `ReaderScreen` 改造成多格式感知的阅读器，根据书籍类型自动选择渲染引擎。

**修改现有文件**：

```
lib/features/reader/
├── screens/reader_screen.dart  — 🔄 改造为多格式路由入口
├── providers/reader_provider.dart — 🔄 扩展支持本地书籍
└── widgets/
    └── reader_factory.dart     — 🆕 根据格式选择渲染器
```

**渲染选择逻辑**：
```dart
Widget buildReader(BuildContext context, Book book) {
  if (book.isLocal) {
    final format = detectFormat(book.originName);
    switch (format) {
      case BookFormat.epub:  return EpubReaderScreen(book: book);
      case BookFormat.pdf:   return PdfReaderScreen(book: book);
      case BookFormat.txt:   return TextReaderScreen(book: book);  // 现有
      default:               return UnsupportedFormatScreen();
    }
  } else {
    return TextReaderScreen(book: book);  // 网络书籍 → 现有 TXT 阅读器
  }
}
```

---

## 总工期预估

| 批次 | 模块 | 预计工时 | 优先级 |
|------|------|---------|--------|
| **第一批** | 分页排版引擎 | 4-5 天 | P0 |
| | 本地书籍导入 + 入口 UI | 2-3 天 | P0 |
| **第二批** | EPUB 阅读器 | 5-7 天 | P1 |
| | PDF 阅读器 | 2-3 天 | P1 |
| **第三批** | TTS 朗读 | 4-5 天 | P2 |
| | 有声书播放 | 3-4 天 | P2 |
| | 漫画阅读 | 3-4 天 | P2 |
| | 阅读器整合改造 | 2-3 天 | P2 |
| **合计** | **8 个模块** | **~30 天** | — |

---

## pubspec.yaml 完整变更

```yaml
# 第一阶段新增（分页引擎 + 本地导入）
# 无新增大依赖（path 已存在）

# 第二阶段新增（EPUB + PDF）
  xml: ^6.5.0
  webview_flutter: ^4.10.0
  pdfx: ^2.6.0

# 第三阶段新增（TTS + 有声书 + 漫画 + 导入）
  flutter_tts: ^4.2.1
  just_audio: ^9.0.1
  photo_view: ^0.15.0
  file_picker: ^8.1.6
  chardet: ^2.0.2
```

---

## 附录：已移除/延后功能说明

| 原计划功能 | 状态 | 原因 |
|-----------|------|------|
| MOBI 阅读器 | ❌ 延后 | Dart 生态缺 MOBI 库；格式用户群小 |
| UMD 阅读器 | ❌ 延后 | 格式极老、中文网文专用；P3 优先级 |
| iOS 后台 TTS | ⚠️ 兼容处理 | 系统限制，仅实现基础后台播放 |
| 复杂 CSS EPUB | ✅ WebView 方案解决 | 决策改为 WebView，CSS 支持度最高 |
