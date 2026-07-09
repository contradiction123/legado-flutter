# Legado Flutter 完全重写技术方案

> 基于原项目 [legado-with-MD3](https://github.com/gedoor/legado) 使用 Flutter 全量重写，一套代码同时支持 iOS 和 Android。

---

## 一、项目概况

### 1.1 原项目画像

| 维度 | 说明 |
|------|------|
| 性质 | Android 开源网络小说阅读器 |
| 语言 | Kotlin 90% + Java 10% |
| UI | Jetpack Compose（迁移中）+ 传统 View 混合 |
| 架构 | 分层架构（Clean Architecture 风格）+ MVVM |
| 数据库 | Room（30+ 实体，94 版本） |
| HTTP | OkHttp 5.4 + Cronet 双引擎 |
| JS 引擎 | Mozilla Rhino 1.8.1（书源脚本执行） |
| DI | Koin 4.2 |
| 图片 | Coil 2.7（Compose）+ Glide 5.0 |
| Web 服务 | Ktor 内嵌 HTTP 服务器 |

### 1.2 核心功能模块

| 模块 | 说明 |
|------|------|
| 书架管理 | 书籍分组、封面展示、布局切换 |
| 书源系统 | 书源管理、分组、导入导出、调试 |
| 规则引擎 | XPath / JSONPath / JSoup / Regex 四种规则 |
| JS 脚本引擎 | 用户可在书源中嵌入 JavaScript 脚本 |
| 搜索 | 多书源并发搜索、去重、排序 |
| 阅读器 | TXT/EPUB/PDF/MOBI/UMD 五类格式 |
| 翻页模式 | 仿真翻页、滑动、滚动、覆盖、无动画 |
| 朗读 TTS | 系统 TTS + 在线 HTTP TTS |
| 有声书 | ExoPlayer 播放 |
| 替换净化 | 正文内容替换与过滤规则 |
| RSS 订阅 | RSS 源管理、文章阅读 |
| AI 对话 | OpenAI / Anthropic 协议，内置聊天 |
| 备份同步 | WebDAV 备份与恢复 |
| Web 管理 | 内置 Ktor HTTP 服务器，浏览器管理 |

---

## 二、核心技术选型

### 2.1 Flutter 端技术栈

| 类别 | 原项目 | Flutter 替代 | 说明 |
|------|--------|-------------|------|
| **UI 框架** | Jetpack Compose | Flutter Widgets + Material 3 | 声明式 UI，天然跨平台 |
| **语言** | Kotlin | Dart 3.x | |
| **状态管理** | ViewModel + StateFlow | **Riverpod 2.x** | 类型安全、测试友好、无 BuildContext 依赖 |
| **导航** | Navigation Compose | **GoRouter** | 声明式路由，支持 Deep Link |
| **网络** | OkHttp + Cronet | **dio + cronet_http** | dio 标准 HTTP + Android 端 Cronet 加速 |
| **数据库** | Room | **drift**（原 moor） | 类型安全 SQLite，支持迁移 |
| **序列化** | Kotlin Serialization / Gson | **freezed + json_serializable** | 不可变数据类 + JSON |
| **DI** | Koin | **get_it + riverpod** | 服务定位器 + 自动状态管理 |
| **HTML 解析** | jsoup | **html**（Dart 官方包） | DOM 遍历、CSS 选择器、数据提取 |
| **XPath** | JsoupXpath | **xml**（Dart 官方包） + 自定义 XPath 引擎 | Dart `xml` 包支持 XPath |
| **JSONPath** | Jayway JsonPath | **json_path**（Dart Package） | 社区已有完善的 JSONPath 实现 |
| **正则** | Java Regex | Dart 内置 `RegExp` | 功能完备，无需额外依赖 |
| **JS 引擎** | Mozilla Rhino | **flutter_js**（QuickJS 封装） | 支持 ES2020，跨平台 FFI |
| **图片加载** | Coil / Glide | **cached_network_image** | 支持缓存、占位图 |
| **SVG** | AndroidSVG | **flutter_svg** | SVG 渲染 |
| **Markdown** | Markwon | **flutter_markdown** | Markdown 渲染 |
| **TTS** | Android TTS | **flutter_tts** | 双端 TTS |
| **音频** | ExoPlayer / Media3 | **just_audio** | 双端音频播放 |
| **WebView** | Android WebView | **webview_flutter** | 跨平台 WebView |
| **二维码扫描** | ZXing | **mobile_scanner** | 相机扫码 |
| **颜色选择器** | ColorPicker-Compose | **flutter_colorpicker** | 颜色选择 |
| **简繁转换** | Quick-Chinese-Transfer | Dart 原生实现 | 可自行实现映射表 |
| **加密** | Hutool Crypto | Dart `crypto` 包 + 自定义 | AES / MD5 / Base64 等 |
| **偏好存储** | DataStore | **shared_preferences** | 键值存储 |
| **本地认证** | Android Biometric | **local_auth** | 指纹/面容 |
| **Web 服务器** | Ktor | **shelf** + **shelf_router** | Dart HTTP 服务器 |

### 2.2 架构模式

采用 **Clean Architecture + Feature-based 组织**，分层如下：

```
┌─────────────────────────────────────────────┐
│             Presentation Layer               │
│    Pages / Widgets / Providers (Riverpod)     │
├─────────────────────────────────────────────┤
│              Domain Layer                    │
│  UseCases / Domain Models / Repository Interfaces  │
├─────────────────────────────────────────────┤
│               Data Layer                     │
│  Repository Impl / DataSources / DTOs        │
├──────────────────┬──────────────────────────┤
│  Local (drift)   │  Remote (dio)            │
└──────────────────┴──────────────────────────┘
```

---

## 三、项目目录结构

```
legado_flutter/
├── android/                          # Android 原生层
├── ios/                              # iOS 原生层
├── assets/
│   ├── fonts/                        # 自定义字体
│   ├── images/                       # 内置图片
│   └── sources/                      # 内置书源文件
├── lib/
│   ├── main.dart                     # 入口
│   ├── app.dart                      # App 根组件
│   │
│   ├── core/
│   │   ├── constants/                # 常量
│   │   │   ├── app_constants.dart
│   │   │   └── book_type.dart
│   │   ├── theme/                    # 主题系统
│   │   │   ├── app_theme.dart        # Material 3 主题
│   │   │   ├── dynamic_color.dart    # 动态取色 (Monet)
│   │   │   └── app_style.dart        # 通用样式
│   │   ├── network/                  # 网络层
│   │   │   ├── dio_client.dart       # dio 封装
│   │   │   ├── http_helper.dart      # 对标原 HttpHelper
│   │   │   ├── cookie_manager.dart   # Cookie 管理
│   │   │   ├── cookie_store.dart     # Cookie 持久化
│   │   │   └── ssl_helper.dart       # SSL 配置
│   │   ├── database/                 # 数据库
│   │   │   ├── app_database.dart     # drift 数据库定义
│   │   │   ├── daos/                 # DAO 层（对标原 34 个 DAO）
│   │   │   │   ├── book_dao.dart
│   │   │   │   ├── book_source_dao.dart
│   │   │   │   ├── bookmark_dao.dart
│   │   │   │   ├── replace_rule_dao.dart
│   │   │   │   └── ... (按模块分)
│   │   │   └── migrations/           # 数据库迁移
│   │   ├── di/                       # 依赖注入
│   │   │   └── injection_container.dart
│   │   ├── platform/                 # 平台通道
│   │   │   ├── tts_service.dart      # TTS 平台通道
│   │   │   └── crypto_service.dart   # 加密平台通道（可选）
│   │   └── utils/                    # 工具类
│   │       ├── gson_utils.dart       # 对标原 GSON 工具
│   │       ├── network_utils.dart    # 网络判断
│   │       ├── string_utils.dart     # 字符串工具
│   │       ├── crypto_utils.dart     # 加密工具
│   │       └── chinese_convert.dart  # 简繁转换
│   │
│   ├── data/
│   │   ├── models/                   # 数据模型 (对标原 entities)
│   │   │   ├── book.dart
│   │   │   ├── book_chapter.dart
│   │   │   ├── book_source.dart
│   │   │   ├── bookmark.dart
│   │   │   ├── replace_rule.dart
│   │   │   ├── rss_source.dart
│   │   │   ├── rss_article.dart
│   │   │   ├── search_book.dart
│   │   │   ├── search_keyword.dart
│   │   │   ├── read_record.dart
│   │   │   ├── cookie.dart
│   │   │   ├── cache.dart
│   │   │   ├── http_tts.dart
│   │   │   ├── server.dart
│   │   │   ├── book_group.dart
│   │   │   ├── txt_toc_rule.dart
│   │   │   ├── dict_rule.dart
│   │   │   ├── highlight_rule.dart
│   │   │   └── ... (完整映射原 30+ 实体)
│   │   ├── models/rule/              # 规则模型
│   │   │   ├── book_info_rule.dart
│   │   │   ├── content_rule.dart
│   │   │   ├── toc_rule.dart
│   │   │   ├── search_rule.dart
│   │   │   ├── explore_rule.dart
│   │   │   └── review_rule.dart
│   │   ├── models/ai/                # AI 模型
│   │   │   ├── ai_chat_conversation.dart
│   │   │   ├── ai_chat_message.dart
│   │   │   ├── ai_profile.dart
│   │   │   └── ai_memory.dart
│   │   ├── repositories/             # 数据仓库实现
│   │   │   ├── book_repository_impl.dart
│   │   │   ├── book_source_repository_impl.dart
│   │   │   ├── search_repository_impl.dart
│   │   │   └── ...
│   │   └── datasources/              # 数据源
│   │       ├── local/
│   │       │   └── book_local_datasource.dart
│   │       └── remote/
│   │           └── book_remote_datasource.dart
│   │
│   ├── domain/
│   │   ├── models/                   # 领域模型
│   │   ├── repositories/             # 仓库接口 (抽象)
│   │   │   ├── book_repository.dart
│   │   │   ├── book_source_repository.dart
│   │   │   └── ...
│   │   └── usecases/                 # 业务用例
│   │       ├── search_books_usecase.dart
│   │       ├── get_book_content_usecase.dart
│   │       └── ...
│   │
│   ├── features/                     # 功能模块 (按 Feature 划分)
│   │   ├── bookshelf/                # 书架
│   │   │   ├── providers/
│   │   │   ├── screens/
│   │   │   └── widgets/
│   │   ├── reader/                   # 阅读器（核心）
│   │   │   ├── providers/
│   │   │   ├── screens/
│   │   │   ├── widgets/
│   │   │   ├── renderer/             # 排版渲染
│   │   │   │   ├── txt_renderer.dart
│   │   │   │   ├── epub_renderer.dart
│   │   │   │   └── page_animator.dart  # 翻页动画
│   │   │   └── config/               # 阅读配置
│   │   ├── search/                   # 搜索
│   │   ├── explore/                  # 发现
│   │   ├── source_manager/           # 书源管理
│   │   │   └── debugger/             # 书源调试器
│   │   ├── book_detail/              # 书籍详情
│   │   ├── replace_rule/             # 替换净化
│   │   ├── rss/                      # RSS 订阅
│   │   ├── ai_chat/                  # AI 对话
│   │   ├── tts/                      # 朗读控制
│   │   ├── settings/                 # 设置
│   │   └── web_server/               # Web 管理
│   │
│   ├── engine/                       # 核心引擎 (对标原 model/)
│   │   ├── web_book/                 # 网络书籍引擎
│   │   │   ├── web_book.dart         # 对标原 WebBook
│   │   │   ├── book_info.dart        # 书籍信息获取
│   │   │   ├── book_list.dart        # 搜索/发现列表
│   │   │   ├── book_chapter_list.dart # 目录获取
│   │   │   └── book_content.dart     # 正文获取
│   │   ├── analyze_rule/             # 规则分析引擎
│   │   │   ├── analyze_rule.dart     # 规则入口（对标原 AnalyzeRule）
│   │   │   ├── analyze_by_jsoup.dart # HTML 规则
│   │   │   ├── analyze_by_xpath.dart # XPath 规则
│   │   │   ├── analyze_by_jsonpath.dart # JSONPath 规则
│   │   │   ├── analyze_by_regex.dart # 正则规则
│   │   │   ├── analyze_url.dart      # URL 分析
│   │   │   ├── rule_data.dart        # 规则数据
│   │   │   └── js_engine.dart        # JS 引擎封装
│   │   ├── js_engine/                # JS 脚本引擎
│   │   │   ├── js_engine_wrapper.dart # QuickJS 封装
│   │   │   ├── js_extensions.dart    # JS 扩展函数
│   │   │   └── compiled_script.dart  # 编译脚本缓存
│   │   ├── local_book/               # 本地书籍解析
│   │   │   ├── txt_parser.dart
│   │   │   ├── epub_parser.dart
│   │   │   ├── pdf_parser.dart
│   │   │   ├── mobi_parser.dart
│   │   │   └── umd_parser.dart
│   │   ├── read_aloud.dart           # 朗读引擎
│   │   ├── read_book.dart            # 阅读状态管理
│   │   ├── cache_manager.dart        # 缓存管理
│   │   └── content_processor.dart    # 正文处理器
│   │
│   └── shared/                       # 共享组件
│       ├── widgets/
│       │   ├── loading_widget.dart
│       │   ├── error_widget.dart
│       │   ├── empty_widget.dart
│       │   └── ...
│       └── extensions/
│           ├── string_ext.dart
│           └── context_ext.dart
│
├── test/
│   ├── engine/
│   │   └── analyze_rule/
│   │       ├── analyze_by_jsoup_test.dart
│   │       ├── analyze_by_xpath_test.dart
│   │       └── ...
│   ├── data/
│   │   └── repositories/
│   └── features/
│
├── pubspec.yaml
├── analysis_options.yaml
└── README.md
```

---

## 四、数据模型迁移方案

### 4.1 核心实体映射（原 → Flutter）

以下列表展示关键实体的迁移，所有字段保持与原版完全一致以确保书源兼容性：

#### Book（书籍）
```dart
// 使用 freezed 生成不可变数据类
@freezed
class Book with _$Book {
  const factory Book({
    @Default('') String bookUrl,         // PK
    @Default('') String tocUrl,
    @Default(BookType.localTag) String origin,
    @Default('') String originName,
    @Default('') String name,
    @Default('') String author,
    String? kind,
    String? customTag,
    String? coverUrl,
    String? customCoverUrl,
    String? intro,
    String? customIntro,
    String? remark,
    String? charset,
    @Default(0) int type,
    @Default(0) int group,
    String? latestChapterTitle,
    @Default(0) int latestChapterTime,
    @Default(0) int lastCheckTime,
    @Default(0) int lastCheckCount,
    @Default(0) int totalChapterNum,
    String? durChapterTitle,
    @Default(0) int durChapterIndex,
    @Default(0) int durChapterPos,
    @Default(0) int durChapterPosPercent,
    @Default(0) int durChapterTime,
    @Default(0) int wordCount,
    @Default(0) int durChapterWordCount,
    String? readConfig,                  // JSON 字符串存储
  }) = _Book;

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);
}
```

#### BookSource（书源 — 核心实体）
```dart
@freezed
class BookSource with _$BookSource {
  const factory BookSource({
    required String bookSourceUrl,         // PK
    required String bookSourceName,
    String? bookSourceGroup,
    @Default(0) int bookSourceType,
    String? bookUrlPattern,
    @Default(0) int customOrder,
    @Default(true) bool enabled,
    @Default(true) bool enabledExplore,
    String? jsLib,
    @Default(true) bool? enabledCookieJar,
    String? concurrentRate,
    String? header,
    String? loginUrl,
    String? loginUi,
    String? loginCheckJs,
    String? coverDecodeJs,
    String? bookSourceComment,
    String? variableComment,
    @Default(0) int lastUpdateTime,
    @Default(180000) int respondTime,
    @Default(0) int weight,
    String? exploreUrl,
    String? exploreScreen,
    ExploreRule? ruleExplore,
    String? searchUrl,
    SearchRule? ruleSearch,
    BookInfoRule? ruleBookInfo,
    TocRule? ruleToc,
    ContentRule? ruleContent,
    ReviewRule? ruleReview,
    @Default(false) bool eventListener,
    @Default(false) bool customButton,
    String? homepageModules,
  }) = _BookSource;

  factory BookSource.fromJson(Map<String, dynamic> json) => _$BookSourceFromJson(json);
}
```

#### 其他实体（共 30+ 个）

全部实体将按原版字段一对一映射，包括：
- `BookChapter` / `Bookmark` / `BookGroup`
- `ReplaceRule` / `HighlightRule` / `HighlightTagRule`
- `SearchBook` / `SearchKeyword` / `SearchContentHistory`
- `ReadRecord` / `BookProgress` / `BookContentProcess`
- `RssSource` / `RssArticle` / `RssStar` / `RssReadRecord`
- `HttpTTS`
- `Cookie` / `Cache`
- `Server`
- `TxtTocRule` / `DictRule` / `TagGroupRule`
- `RuleSub`
- `AiChatConversation` / `AiChatMessage` / `AiProfile` / `AiMemory` / `AiArtifact` / `AiPromptPreset`
- `HomepageModule` / `HomepageCustomSet`
- `KeyboardAssist`
- `TranslationCache`
- `BaseSource`（接口）
- `BaseBook`（接口）
- `BaseRssArticle`（接口）

### 4.2 drift 数据库定义

```dart
// lib/core/database/app_database.dart
import 'package:drift/drift.dart';

// -- Book 表
class Books extends Table {
  TextColumn get bookUrl => text()();
  TextColumn get tocUrl => text()();
  TextColumn get origin => text()();
  TextColumn get originName => text()();
  TextColumn get name => text()();
  TextColumn get author => text()();
  // ... 所有字段

  @override
  Set<Column> get primaryKey => {bookUrl};
}

// -- BookSource 表
class BookSources extends Table {
  TextColumn get bookSourceUrl => text()();
  TextColumn get bookSourceName => text()();
  // ... 所有字段

  @override
  Set<Column> get primaryKey => {bookSourceUrl};
}

// -- 其他 30+ 表定义...

@DriftDatabase(tables: [
  Books,
  BookSources,
  BookChapters,
  Bookmarks,
  BookGroups,
  // ... 全部表
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;  // 初始版本

  // 迁移策略
  @override
  MigrationStrategy get migration => ...;
}
```

---

## 五、核心引擎移植方案

### 5.1 JS 脚本引擎（最关键）

| 维度 | 原版 Rhino | Flutter 方案（QuickJS） |
|------|-----------|----------------------|
| 引擎 | Mozilla Rhino 1.8.1 | QuickJS（通过 `flutter_js` FFI 封装） |
| ES 支持 | ES5 + 部分 ES6 | ES2020（更现代） |
| 性能 | 中等 | 更优 |
| 平台 | Android only | Android + iOS |

**实现方案**：

```dart
// lib/engine/js_engine/js_engine_wrapper.dart
class JsEngine {
  final JsEngine _engine = JsEngine(); // flutter_js 引擎实例

  /// 执行 JS 表达式
  dynamic evalJS(String script, dynamic result) {
    final jsResult = _engine.evaluate(script);
    if (jsResult.isError) throw Exception(jsResult.errorMessage);
    return jsResult.stringResult; // 返回字符串结果
  }

  /// 编译并缓存脚本（对标原 CompiledScript）
  CompiledScript compile(String script) { ... }
}

/// 编译脚本缓存（对标原 scriptCache）
class ScriptCache {
  final Map<String, CompiledScript> _cache = {};

  CompiledScript? get(String key) => _cache[key];
  void put(String key, CompiledScript script) => _cache[key] = script;
}
```

**JS 扩展函数移植**（对标原 `JsExtensions`）：
原项目在 JS 环境中注入了大量扩展函数，如 `java` 对象、`base64` 编解码、网络请求等。这些需要全部在 Dart 侧重新实现为同名扩展。

```dart
// lib/engine/js_engine/js_extensions.dart
class JsExtensions {
  /// 在 JS 上下文中注册扩展 API
  static void registerExtensions(JsEngine engine) {
    // 注册 java.xxx 方法
    engine.set('java', {
      'get': (url) => HttpHelper.get(url),
      'post': (url, body) => HttpHelper.post(url, body),
      // ...
    });
    // 注册 base64 编解码
    engine.set('base64', {
      'encode': (str) => base64Encode(utf8.encode(str)),
      'decode': (str) => utf8.decode(base64Decode(str)),
    });
    // 注册其他工具函数...
  }
}
```

### 5.2 规则分析引擎（对标原 AnalyzeRule）

原 `AnalyzeRule` 支持四种规则解析，是书源系统的核心。移植方案：

```
AnalyzeRule
├── analyzeByJSoup    → analyze_by_jsoup.dart  (Dart html 包)
├── analyzeByXPath    → analyze_by_xpath.dart  (Dart xml 包 + XPath)
├── analyzeByJSonPath → analyze_by_jsonpath.dart (json_path 包)
├── analyzeByRegex    → analyze_by_regex.dart  (Dart RegExp)
└── evalJS            → js_engine.dart         (QuickJS)
```

**Dart HTML 解析示例**（对标 JSoup）：

```dart
// lib/engine/analyze_rule/analyze_by_jsoup.dart
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class AnalyzeByJSoup {
  /// 根据 CSS 选择器解析 HTML
  String? parseHtml(String html, String cssSelector) {
    final document = parser.parse(html);
    final elements = document.querySelectorAll(cssSelector);
    return elements.isNotEmpty ? elements.first.text : null;
  }
}
```

### 5.3 网络书籍引擎（对标原 WebBook）

```dart
// lib/engine/web_book/web_book.dart
class WebBook {
  /// 搜索
  Future<List<SearchBook>> searchBooks(
    BookSource source, String keyword, {int? page}
  ) async {
    // 1. 拼装搜索 URL（通过 AnalyzeUrl）
    // 2. 发送 HTTP 请求（dio）
    // 3. 解析搜索结果（AnalyzeRule）
    // 4. 返回 SearchBook 列表
  }

  /// 获取书籍信息
  Future<Book> getBookInfo(BookSource source, Book book) async { ... }

  /// 获取目录
  Future<List<BookChapter>> getChapterList(BookSource source, Book book) async { ... }

  /// 获取正文
  Future<String> getBookContent(BookSource source, BookChapter chapter) async { ... }

  /// 发现
  Future<List<SearchBook>> explore(BookSource source, String url) async { ... }
}
```

### 5.4 本地书籍解析

| 格式 | 原方案 | Flutter 方案 |
|------|--------|-------------|
| TXT | Kotlin IO | `dart:io` 按编码读取 |
| EPUB | `modules:book` 模块 | `epubx` 包 + 自定义 zip 解析 |
| PDF | Android PDF API | `flutter_pdfview` 或 `pdfx` |
| MOBI | `modules:book` 模块 | `mobi` 包或自定义解析 |
| UMD | `modules:book` 模块 | 自定义二进制解析（Dart 实现） |

### 5.5 阅读器渲染

```dart
// lib/features/reader/renderer/txt_renderer.dart
class TxtRenderer {
  /// 将文本按页面分割
  List<String> paginate(String text, {
    required double fontSize,
    required double lineHeight,
    required double pageWidth,
    required double pageHeight,
  }) { ... }

  /// 将纯文本转换为带样式的 Widget
  Widget renderText(String text, BookReadConfig config) { ... }
}

// lib/features/reader/renderer/page_animator.dart
/// 仿真翻页动画（使用 CustomPainter）
class PageFlipAnimator extends CustomPainter { ... }

/// 覆盖翻页动画
class CoverPageAnimator extends CustomPainter { ... }
```

---

## 六、UI 方案设计

### 6.1 整体风格

- **跨平台统一风格**：一套 Material 3 主题，iOS 和 Android 保持一致
- **支持动态取色**：Android Monet 风格取色方案，使用 `material_color_utilities` 包
- **深色模式**：跟随系统或手动切换
- **阅读器专属主题**：可独立配置的背景色、字体、行距等

### 6.2 底部导航结构

```
底部 Tab（共 5 个）：
├── 📚 书架 (Bookshelf)
├── 🔍 发现 (Explore)  
├── 📡 RSS
├── 🤖 AI（可选）
└── 👤 我的 (Profile/Settings)
```

### 6.3 关键页面清单

| 页面 | 说明 |
|------|------|
| 书架页 | 网格/列表视图，分组筛选 |
| 发现页 | 书源发现列表，分类浏览 |
| 书籍详情页 | 封面、简介、目录、开始阅读 |
| 阅读器页 | 正文显示、翻页、菜单、配置 |
| 搜索页 | 多源并发搜索，结果聚合 |
| 书源管理页 | 书源列表、分组、导入导出 |
| 书源编辑页 | 规则编辑、语法高亮、调试 |
| 书源调试器 | 实时测试书源规则效果 |
| 设置页 | 全部配置项、分组导航 |
| RSS 页 | 订阅源列表、文章阅读 |
| AI 对话页 | 聊天界面、流式输出 |
| 替换净化页 | 替换规则管理 |
| Web 管理页 | 内置服务器控制 |

### 6.4 状态管理方案（Riverpod）

```dart
// 示例：书架状态管理
final bookshelfProvider = AsyncNotifierProvider<BookshelfNotifier, List<Book>>(
  BookshelfNotifier.new,
);

class BookshelfNotifier extends AsyncNotifier<List<Book>> {
  @override
  Future<List<Book>> build() async {
    final repo = ref.read(bookRepositoryProvider);
    return repo.getAllBooks();
  }

  Future<void> addBook(Book book) async { ... }
  Future<void> removeBook(String bookUrl) async { ... }
  Future<void> updateBook(Book book) async { ... }
}

// 示例：阅读器状态
final readerProvider = StateNotifierProvider<ReaderNotifier, ReaderState>(
  (ref) => ReaderNotifier(ref),
);

class ReaderState {
  final Book book;
  final int currentChapterIndex;
  final int currentPosition;
  final String currentContent;
  final ReadConfig config;
}
```

---

## 七、书源兼容性方案

### 7.1 书源格式兼容

这是重中之重。原版书源以 JSON 格式存储，包含完整的规则定义。Flutter 版必须：

1. **导入导出格式完全兼容** — 支持导入原版 `.json` 书源文件
2. **规则语法完全兼容** — 四种规则引擎与 Rhino 行为一致
3. **JS 语法尽量兼容** — 通过 QuickJS 支持 ES2020，覆盖大部分 Rhino 场景

### 7.2 已知差异与解决方案

| 差异项 | Rhino | QuickJS | 解决方案 |
|--------|-------|---------|----------|
| `Java.type()` | 支持 | 不支持 | 提供同名 polyfill |
| `java.get()` | 有 | 无 | 在 JS 上下文中注册同名函数 |
| `JSON.parse()` | 有 | 有 | 兼容 ✅ |
| `String/Array` 方法 | ES5 | ES2020 | 更现代，兼容 ✅ |

### 7.3 书源导入流程

```
用户选择 .json 书源文件
  → 读取文件内容
  → JSON 反序列化为 BookSource 模型
  → 验证规则字段完整性
  → 写入数据库 (drift)
  → 刷新 UI
```

---

## 八、数据库兼容性说明

### 8.1 与原版数据库的关系

Flutter 版**不直接使用原版 Room 数据库文件**，原因：
- Room 和 drift 使用的 SQLite 版本和 schema 不一致
- 跨平台需要统一的数据库文件格式

### 8.2 数据迁移策略

```
原版 Android App                         Flutter 版 App
┌────────────────┐                      ┌────────────────┐
│ Room SQLite DB  │  → 导出为 JSON →  →  │ drift SQLite DB│
│ (legado.db)     │  书源/备份/恢复      │ (legado.db)    │
└────────────────┘                      └────────────────┘

通过以下方式迁移数据：
1. 原版备份 → 导出为 JSON → Flutter 版导入
2. 直接导入原版导出的 .json 书源文件
3. 不支持直接读取原版 db 文件（但可提供转换工具）
```

---

## 九、分阶段实施路线图

### Phase 1：基础设施搭建（预计 2 周）

| 任务 | 内容 |
|------|------|
| Flutter 项目初始化 | 创建项目、配置依赖、CI/CD |
| 数据库层 | 完成 drift 数据库定义、实现所有 DAO |
| 网络层 | 封装 dio 客户端、Cookie 管理、SSL |
| 依赖注入 | 配置 get_it + riverpod |
| 主题系统 | Material 3 主题、动态取色 |
| JS 引擎 | 集成 flutter_js，封装 JsEngine |
| 模型定义 | 全部 30+ 实体 freezed 模型 |

### Phase 2：书源与规则系统（预计 3 周）

| 任务 | 内容 |
|------|------|
| 规则引擎 | 移植四种规则解析器 |
| JS 扩展 | 实现所有 JS 扩展函数 |
| AnalyzeUrl | URL 拼接与请求发送 |
| WebBook 引擎 | 搜索、书籍信息、目录、正文 |
| 书源管理 | 列表、编辑、分组、导入导出 |
| 书源调试器 | 实时测试书源规则 |

### Phase 3：核心阅读体验（预计 4 周）

| 任务 | 内容 |
|------|------|
| 书架 | 书籍列表/网格展示、分组、排序 |
| 搜索 | 多源并发搜索、结果聚合 |
| 书籍详情 | 信息展示、目录、阅读按钮 |
| TXT 阅读器 | 章节渲染、翻页、进度保存 |
| 阅读配置 | 字体、行距、背景色、翻页模式 |
| 翻页动画 | 仿真翻页、滑动、滚动、覆盖 |
| 书签 | 添加、查看、跳转 |
| 替换净化 | 规则管理、正文处理 |

### Phase 4：完整功能（预计 3 周）

| 任务 | 内容 |
|------|------|
| EPUB 阅读 | EPUB 解析与渲染 |
| PDF/MOBI/UMD | 余下格式解析 |
| 漫画阅读 | 图片流加载、滚动画廊 |
| TTS 朗读 | flutter_tts 集成、控制面板 |
| 音频播放 | just_audio、有声书支持 |
| 本地书籍 | 文件导入、编码检测 |

### Phase 5：扩展功能（预计 2 周）

| 任务 | 内容 |
|------|------|
| RSS 订阅 | 订阅管理、文章阅读 |
| AI 对话 | 聊天 UI、流式输出、OpenAI/Anthropic |
| Web 管理 | shelf HTTP 服务器、管理页面 |
| 备份同步 | WebDAV 上传下载、本地备份 |
| 简繁转换 | 汉字转换服务 |

### Phase 6：打磨与发布（预计 2 周）

| 任务 | 内容 |
|------|------|
| iOS 适配 | 签名、沙盒、权限、App Store |
| 性能优化 | 数据库查询、列表复用、图片缓存 |
| 测试 | 单元测试、Widget 测试、集成测试 |
| 本地化 | 中英双语支持 |
| 发布准备 | App 图标、商店截图、隐私政策 |

**总计：约 16 周（4 个月）全职开发**

---

## 十、关键技术难点及解决方案

### 10.1 难点一：JS 引擎兼容性 🔴

**问题**：原版 Rhino 引擎在 Android 上运行，用户书源中可能使用各种 Rhino 特有 API。

**方案**：
- 使用 `flutter_js`（QuickJS）作为底层引擎，支持 ES2020，比 Rhino 更现代
- 在 JS 上下文中注册 polyfill 对象（如 `java` 对象、`Packages` 等）
- 建立兼容性测试套件，覆盖主流书源

### 10.2 难点二：阅读器翻页动画 🔴

**问题**：Flutter 原生不支持仿真翻页效果。

**方案**：
- 使用 `CustomPainter` + `GestureDetector` 实现自定义翻页动画
- 参考开源实现（如 `flutter_reader` 社区项目）
- 实现 5 种翻页模式：仿真、滑动、滚动、覆盖、无动画

### 10.3 难点三：EPUB 排版引擎 🟡

**问题**：EPUB 本质是 HTML + CSS + zip 包，需要完整的排版渲染。

**方案**：
- 通过 `archive` 包解压 EPUB
- 解析 OPF 文件获取元数据和章节列表
- 使用 `flutter_widget_from_html` 或 `flutter_html` 渲染 HTML 内容
- 自定义 CSS 样式覆写（字体、行距、边距）

### 10.4 难点四：多源并发搜索 🟡

**问题**：搜索时需要同时请求多个书源，需要流量控制。

**方案**：
- 使用 Dart `Future.wait` + 信号量（Semaphore）控制并发数
- 搜索结果实时聚合，去重排序
- 对标原版 `concurrentRate` 书源配置

### 10.5 难点五：Cookie 管理与登录 🟢

**方案**：
- 使用 dio 的拦截器实现 Cookie 自动管理
- Cookie 持久化到 drift 数据库
- 实现与书源关联的 Cookie 存储

---

## 十一、Flutter 依赖清单

```yaml
# pubspec.yaml
dependencies:
  flutter:
    sdk: flutter

  # 状态管理
  flutter_riverpod: ^2.5.0
  riverpod_annotation: ^2.3.0

  # 导航
  go_router: ^14.0.0

  # 网络
  dio: ^5.4.0
  dio_cookie_manager: ^3.1.0
  cookie_jar: ^4.0.0
  cronet_http: ^1.2.0    # Android Cronet 支持

  # 数据库
  drift: ^2.16.0
  sqlite3_flutter_libs: ^0.5.0
  path_provider: ^2.1.0
  path: ^1.9.0

  # 序列化
  freezed_annotation: ^2.4.0
  json_annotation: ^4.8.0

  # 依赖注入
  get_it: ^7.6.0

  # 图片加载
  cached_network_image: ^3.3.0
  flutter_svg: ^2.0.0

  # HTML 和 XML 解析
  html: ^0.15.0          # 对标 jsoup
  xml: ^6.5.0            # XPath 支持
  json_path: ^0.7.0      # JSONPath 支持

  # JS 引擎
  flutter_js: ^0.8.0     # QuickJS 封装

  # 文件解析
  archive: ^3.4.0        # ZIP 解压（EPUB）
  epubx: ^2.0.0          # EPUB 元数据解析
  pdfx: ^2.6.0           # PDF 查看（可选）

  # 音频和 TTS
  just_audio: ^0.9.36
  flutter_tts: ^4.0.0

  # WebView
  webview_flutter: ^4.5.0

  # Markdown
  flutter_markdown: ^0.7.0

  # UI 组件
  flutter_colorpicker: ^1.1.0
  shimmer: ^3.0.0
  extended_image: ^8.0.0

  # 工具
  shared_preferences: ^2.2.0
  local_auth: ^2.1.0
  mobile_scanner: ^5.0.0
  connectivity_plus: ^6.0.0
  package_info_plus: ^8.0.0
  url_launcher: ^6.2.0
  permission_handler: ^11.3.0
  file_picker: ^8.0.0
  crypto: ^3.0.3
  collection: ^1.18.0
  intl: ^0.19.0
  logger: ^2.0.0
  device_info_plus: ^10.0.0
  wakelock_plus: ^1.2.0

dev_dependencies:
  flutter_test:
    sdk: flutter

  drift_dev: ^2.16.0
  build_runner: ^2.4.0
  freezed: ^2.4.0
  json_serializable: ^6.7.0
  riverpod_generator: ^2.3.0
  mockito: ^5.4.0
  flutter_lints: ^4.0.0
```

---

## 十二、关键风险与应对

| 风险 | 等级 | 影响 | 应对措施 |
|------|------|------|----------|
| JS 书源兼容性问题 | 🔴 高 | 大量用户书源无法使用 | 建立书源兼容性测试集；提供 polyfill；保留上报渠道 |
| 阅读器仿真翻页性能 | 🟡 中 | iOS 低端机型卡顿 | 使用 `RepaintBoundary` 优化；提供简化翻页模式 |
| EPUB 渲染效果差异 | 🟡 中 | 部分 EPUB 排版错乱 | 原生渲染 + WebView 降级方案 |
| 数据库迁移数据丢失 | 🟢 低 | 用户数据需重新导入 | 提供清晰的书源/备份导入引导 |
| iOS 审核被拒 | 🟡 中 | 因书源灵活性被质疑 | 确保内容合规，无侵权风险 |

---

## 十三、与原版功能对标检查表

| 功能 | 原版 | Flutter 版 | 优先级 |
|------|------|-----------|--------|
| 书架管理 | ✅ | ✅ | P0 |
| 书源管理 | ✅ | ✅ | P0 |
| 书源规则引擎 | ✅ | ✅ | P0 |
| JS 脚本执行 | ✅ | ✅ | P0 |
| 搜索（多源并发） | ✅ | ✅ | P0 |
| TXT 阅读 | ✅ | ✅ | P0 |
| EPUB 阅读 | ✅ | ✅ | P1 |
| PDF 阅读 | ✅ | ✅ | P2 |
| MOBI 阅读 | ✅ | ✅ | P3 |
| UMD 阅读 | ✅ | ✅ | P3 |
| 仿真翻页 | ✅ | ✅ | P1 |
| TTS 朗读 | ✅ | ✅ | P1 |
| 有声书播放 | ✅ | ✅ | P1 |
| 替换净化 | ✅ | ✅ | P1 |
| RSS 订阅 | ✅ | ✅ | P1 |
| AI 对话 | ✅ | ✅ | P1 |
| WebDAV 备份 | ✅ | ✅ | P2 |
| Web 管理 | ✅ | ✅ | P2 |
| 书源调试器 | ✅ | ✅ | P1 |
| 简繁转换 | ✅ | ✅ | P2 |
| 漫画阅读 | ✅ | ✅ | P2 |
| 段评/章评 | ✅ | ✅ | P3 |
| 自定义按钮 | ✅ | ✅ | P3 |
| 事件监听书源 | ✅ | ✅ | P3 |
| 首页模块 | ✅ | ✅ | P3 |

> P0 = 必须（MVP核心功能）
> P1 = 重要（后续快速迭代）
> P2 = 一般（逐步补齐）
> P3 = 锦上添花（视情况而定）

---

## 十四、总结

本方案的核心策略是：**使用 Flutter 将原 Legado 项目完整"翻译"一遍**，保持与原版书源生态的完全兼容，同时实现 iOS/Android 双端覆盖。

关键要点：
1. **书源兼容是生命线** — 通过 QuickJS + Dart 规则引擎确保 99%+ 兼容
2. **数据模型一对一映射** — 所有实体字段保持完全一致
3. **分阶段迭代** — MVP 聚焦核心阅读体验，逐步补齐全功能
4. **统一代码库** — 一套代码，双端运行，降低维护成本
5. **Material 3 设计** — 跨平台统一视觉风格

如果按照全职开发，预计 **4 个月** 左右可以完成全部功能的稳定版本。
