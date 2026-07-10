import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

part 'app_database.g.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// 第 1 批：核心功能表（5 张）
// ═══════════════════════════════════════════════════════════════════════════════

/// 书籍（books）
/// 对应原：Book.kt（实现 BaseBook 接口）
/// 主键：bookUrl
class Books extends Table {
  TextColumn get bookUrl => text()(); // 主键，详情页URL/本地文件路径
  TextColumn get tocUrl => text()(); // 目录页URL
  TextColumn get origin =>
      text().withDefault(const Constant('loc_book'))(); // 书源URL
  TextColumn get originName => text()(); // 书源名称/本地文件名
  TextColumn get name => text()(); // 书名
  TextColumn get author => text()(); // 作者
  TextColumn? get kind => text().nullable()(); // 分类（来自书源）
  TextColumn? get customTag => text().nullable()(); // 分类（用户修改）
  TextColumn? get coverUrl => text().nullable()(); // 封面URL
  TextColumn? get customCoverUrl => text().nullable()(); // 封面URL（用户修改）
  TextColumn? get intro => text().nullable()(); // 简介
  TextColumn? get customIntro => text().nullable()(); // 简介（用户修改）
  TextColumn? get remark => text().nullable()(); // 备注
  TextColumn? get charset => text().nullable()(); // 字符集（仅本地）
  IntColumn get type => integer().withDefault(const Constant(8))(); // 书籍类型
  IntColumn get group => integer().withDefault(const Constant(0))(); // 分组ID
  TextColumn? get latestChapterTitle => text().nullable()(); // 最新章节标题
  IntColumn get latestChapterTime =>
      integer().withDefault(const Constant(0))(); // 最新章节时间
  IntColumn get lastCheckTime =>
      integer().withDefault(const Constant(0))(); // 最后检查时间
  IntColumn get lastCheckCount =>
      integer().withDefault(const Constant(0))(); // 新章节数
  IntColumn get totalChapterNum =>
      integer().withDefault(const Constant(0))(); // 总章节数
  TextColumn? get durChapterTitle => text().nullable()(); // 当前章节名
  IntColumn get durChapterIndex =>
      integer().withDefault(const Constant(0))(); // 当前章节索引
  IntColumn get durChapterPos =>
      integer().withDefault(const Constant(0))(); // 阅读位置
  IntColumn get durChapterTime =>
      integer().withDefault(const Constant(0))(); // 最后阅读时间
  TextColumn? get wordCount => text().nullable()(); // 字数
  BoolColumn get canUpdate =>
      boolean().withDefault(const Constant(true))(); // 可更新
  IntColumn get order => integer().withDefault(const Constant(0))(); // 手动排序
  IntColumn get originOrder =>
      integer().withDefault(const Constant(0))(); // 书源排序
  TextColumn? get variable => text().nullable()(); // 自定义变量
  TextColumn? get readConfig => text().nullable()(); // 阅读设置（JSON）
  IntColumn get syncTime => integer().withDefault(const Constant(0))(); // 同步时间

  @override
  Set<Column> get primaryKey => {bookUrl};

  @override
  List<Set<Column>> get uniqueKeys => [
    {name, author},
  ];
}

/// 章节（chapters）
/// 对应原：BookChapter.kt
/// 联合主键：(url, bookUrl)，外键关联 Books
class BookChapters extends Table {
  TextColumn get url => text()(); // 复合主键1，章节地址
  TextColumn get title => text()(); // 标题
  BoolColumn get isVolume =>
      boolean().withDefault(const Constant(false))(); // 是否是卷
  TextColumn get baseUrl => text()(); // 基础URL
  TextColumn get bookUrl =>
      text().references(Books, #bookUrl)(); // 复合主键2，外键关联 Books（级联删除在应用层处理）
  IntColumn get index => integer().withDefault(const Constant(0))(); // 章节序号
  BoolColumn get isVip =>
      boolean().withDefault(const Constant(false))(); // 是否VIP
  BoolColumn get isPay =>
      boolean().withDefault(const Constant(false))(); // 是否购买
  TextColumn? get resourceUrl => text().nullable()(); // 音频URL
  TextColumn? get tag => text().nullable()(); // 附加信息
  TextColumn? get wordCount => text().nullable()(); // 本章字数
  IntColumn? get start => integer().nullable()(); // 起始位置
  IntColumn? get end => integer().nullable()(); // 终止位置
  TextColumn? get startFragmentId => text().nullable()(); // EPUB 起始 fragmentId
  TextColumn? get endFragmentId => text().nullable()(); // EPUB 终止 fragmentId
  TextColumn? get variable => text().nullable()(); // 变量
  TextColumn? get reviewImg => text().nullable()(); // 段评图标

  @override
  Set<Column> get primaryKey => {url, bookUrl};

  @override
  List<Set<Column>> get uniqueKeys => [
    {bookUrl, index},
  ];
}

/// 书源（book_sources）
/// 对应原：BookSource.kt（实现 BaseSource 接口）
/// 主键：bookSourceUrl
class BookSources extends Table {
  TextColumn get bookSourceUrl => text()(); // 主键
  TextColumn get bookSourceName => text()(); // 名称
  TextColumn? get bookSourceGroup => text().nullable()(); // 分组
  IntColumn get bookSourceType =>
      integer().withDefault(const Constant(0))(); // 类型
  TextColumn? get bookUrlPattern => text().nullable()(); // 详情页URL正则
  IntColumn get customOrder => integer().withDefault(const Constant(0))(); // 排序
  BoolColumn get enabled => boolean().withDefault(const Constant(true))(); // 启用
  BoolColumn get enabledExplore =>
      boolean().withDefault(const Constant(true))(); // 启用发现
  TextColumn? get jsLib => text().nullable()(); // JS库
  BoolColumn? get enabledCookieJar => boolean().nullable()(); // CookieJar
  TextColumn? get concurrentRate => text().nullable()(); // 并发率
  TextColumn? get header => text().nullable()(); // 请求头
  TextColumn? get loginUrl => text().nullable()(); // 登录地址
  TextColumn? get loginUi => text().nullable()(); // 登录UI
  TextColumn? get loginCheckJs => text().nullable()(); // 登录检测JS
  TextColumn? get coverDecodeJs => text().nullable()(); // 封面解密JS
  TextColumn? get bookSourceComment => text().nullable()(); // 注释
  TextColumn? get variableComment => text().nullable()(); // 变量说明
  IntColumn get lastUpdateTime =>
      integer().withDefault(const Constant(0))(); // 更新时间
  IntColumn get respondTime =>
      integer().withDefault(const Constant(180000))(); // 响应时间
  IntColumn get weight => integer().withDefault(const Constant(0))(); // 权重
  TextColumn? get exploreUrl => text().nullable()(); // 发现URL
  TextColumn? get exploreScreen => text().nullable()(); // 发现筛选规则
  TextColumn? get ruleExplore => text().nullable()(); // 发现规则（JSON）
  TextColumn? get searchUrl => text().nullable()(); // 搜索URL
  TextColumn? get ruleSearch => text().nullable()(); // 搜索规则（JSON）
  TextColumn? get ruleBookInfo => text().nullable()(); // 详情规则（JSON）
  TextColumn? get ruleToc => text().nullable()(); // 目录规则（JSON）
  TextColumn? get ruleContent => text().nullable()(); // 正文规则（JSON）
  TextColumn? get ruleReview => text().nullable()(); // 段评规则（JSON）
  BoolColumn get eventListener =>
      boolean().withDefault(const Constant(false))(); // 事件监听
  BoolColumn get customButton =>
      boolean().withDefault(const Constant(false))(); // 自定义按钮
  TextColumn? get homepageModules => text().nullable()(); // 首页模块（JSON）

  @override
  Set<Column> get primaryKey => {bookSourceUrl};
}

/// 搜索结果（searchBooks）
/// 对应原：SearchBook.kt
/// 主键：bookUrl，外键关联 BookSource
class SearchBooks extends Table {
  TextColumn get bookUrl => text()(); // 主键
  TextColumn get origin =>
      text().references(BookSources, #bookSourceUrl)(); // 书源URL
  TextColumn get originName => text()(); // 书源名称
  IntColumn get type => integer().withDefault(const Constant(8))(); // 类型
  TextColumn get name => text()(); // 书名
  TextColumn get author => text()(); // 作者
  TextColumn? get kind => text().nullable()(); // 分类
  TextColumn? get coverUrl => text().nullable()(); // 封面
  TextColumn? get intro => text().nullable()(); // 简介
  TextColumn? get wordCount => text().nullable()(); // 字数
  TextColumn? get latestChapterTitle => text().nullable()(); // 最新章节
  TextColumn get tocUrl => text()(); // 目录URL
  IntColumn get time => integer().clientDefault(
    () => DateTime.now().millisecondsSinceEpoch,
  )(); // 搜索时间
  TextColumn? get variable => text().nullable()(); // 变量
  IntColumn get originOrder =>
      integer().withDefault(const Constant(0))(); // 书源排序
  TextColumn? get chapterWordCountText => text().nullable()(); // 章节字数文本
  IntColumn get chapterWordCount =>
      integer().withDefault(const Constant(-1))(); // 章节字数
  IntColumn get respondTime =>
      integer().withDefault(const Constant(-1))(); // 响应时间

  @override
  Set<Column> get primaryKey => {bookUrl};
}

/// 书签（bookmarks）
/// 对应原：Bookmark.kt
/// 主键：time
class Bookmarks extends Table {
  IntColumn get time => integer().clientDefault(
    () => DateTime.now().millisecondsSinceEpoch,
  )(); // 主键
  TextColumn get bookName => text()(); // 书名
  TextColumn get bookAuthor => text().withDefault(const Constant(''))(); // 作者
  IntColumn get chapterIndex =>
      integer().withDefault(const Constant(0))(); // 章节索引
  IntColumn get chapterPos => integer().withDefault(const Constant(0))(); // 位置
  TextColumn get chapterName => text()(); // 章节名
  TextColumn get bookText => text()(); // 文本
  TextColumn get content => text()(); // 内容

  @override
  Set<Column> get primaryKey => {time};

  @override
  List<Set<Column>> get uniqueKeys => [
    {bookName, bookAuthor},
  ];
}

// ═══════════════════════════════════════════════════════════════════════════════
// 第 2 批：阅读记录（4 张）
// ═══════════════════════════════════════════════════════════════════════════════

/// 阅读记录（readRecord）
/// 对应原：ReadRecord.kt
/// 联合主键：(deviceId, bookName, bookAuthor)
class ReadRecords extends Table {
  TextColumn get deviceId => text()(); // 主键1
  TextColumn get bookName => text()(); // 主键2
  TextColumn get bookAuthor => text().withDefault(const Constant(''))(); // 主键3
  IntColumn get readTime => integer().withDefault(const Constant(0))(); // 阅读时长
  IntColumn get lastRead =>
      integer().withDefault(const Constant(0))(); // 最后阅读时间

  @override
  Set<Column> get primaryKey => {deviceId, bookName, bookAuthor};
}

/// 阅读记录详情（readRecordDetail）
/// 对应原：ReadRecordDetail.kt
/// 联合主键：(deviceId, bookName, bookAuthor, date)
class ReadRecordDetails extends Table {
  TextColumn get deviceId => text()(); // 主键1
  TextColumn get bookName => text()(); // 主键2
  TextColumn get bookAuthor => text().withDefault(const Constant(''))(); // 主键3
  TextColumn get date => text()(); // 主键4
  IntColumn get readTime =>
      integer().withDefault(const Constant(0))(); // 当天阅读时长
  IntColumn get readWords =>
      integer().withDefault(const Constant(0))(); // 当天阅读字数
  IntColumn get firstReadTime =>
      integer().withDefault(const Constant(0))(); // 首次阅读时间
  IntColumn get lastReadTime =>
      integer().withDefault(const Constant(0))(); // 末次阅读时间

  @override
  Set<Column> get primaryKey => {deviceId, bookName, bookAuthor, date};
}

/// 阅读会话（readRecordSession）
/// 对应原：ReadRecordSession.kt
/// 主键：id（自增）
class ReadRecordSessions extends Table {
  IntColumn get id => integer().autoIncrement()(); // 自增主键（自动成为主键）
  TextColumn get deviceId => text()(); // 设备ID
  TextColumn get bookName => text()(); // 书名
  TextColumn get bookAuthor => text().withDefault(const Constant(''))(); // 作者
  IntColumn get startTime => integer().withDefault(const Constant(0))(); // 开始时间
  IntColumn get endTime => integer().withDefault(const Constant(0))(); // 结束时间
  IntColumn get words => integer().withDefault(const Constant(0))(); // 阅读字数
}

/// TXT 目录解析规则（txtTocRules）
/// 对应原：TxtTocRule.kt
/// 主键：id
class TxtTocRules extends Table {
  IntColumn get id => integer().clientDefault(
    () => DateTime.now().millisecondsSinceEpoch,
  )(); // 主键
  TextColumn get name => text()(); // 规则名
  TextColumn get rule => text()(); // 规则表达式
  TextColumn? get example => text().nullable()(); // 示例
  IntColumn get serialNumber =>
      integer().withDefault(const Constant(-1))(); // 排序
  BoolColumn get enable => boolean().withDefault(const Constant(true))(); // 启用

  @override
  Set<Column> get primaryKey => {id};
}

// ═══════════════════════════════════════════════════════════════════════════════
// 第 3 批：RSS（4 张）
// ═══════════════════════════════════════════════════════════════════════════════

/// RSS 源（rssSources）
/// 对应原：RssSource.kt
/// 主键：sourceUrl
class RssSources extends Table {
  TextColumn get sourceUrl => text()(); // 主键
  TextColumn get sourceName => text()(); // 名称
  TextColumn get sourceIcon => text()(); // 图标
  TextColumn? get sourceGroup => text().nullable()(); // 分组
  TextColumn? get sourceComment => text().nullable()(); // 注释
  BoolColumn get enabled => boolean().withDefault(const Constant(true))(); // 启用
  TextColumn? get variableComment => text().nullable()(); // 变量说明
  TextColumn? get jsLib => text().nullable()(); // JS库
  BoolColumn? get enabledCookieJar => boolean().nullable()(); // CookieJar
  TextColumn? get concurrentRate => text().nullable()(); // 并发率
  TextColumn? get header => text().nullable()(); // 请求头
  TextColumn? get loginUrl => text().nullable()(); // 登录地址
  TextColumn? get loginUi => text().nullable()(); // 登录UI
  TextColumn? get loginCheckJs => text().nullable()(); // 登录检测JS
  TextColumn? get coverDecodeJs => text().nullable()(); // 封面解密JS
  TextColumn? get sortUrl => text().nullable()(); // 分类URL
  BoolColumn get singleUrl =>
      boolean().withDefault(const Constant(false))(); // 单URL源
  IntColumn get articleStyle =>
      integer().withDefault(const Constant(0))(); // 列表样式
  TextColumn? get ruleArticles => text().nullable()(); // 列表规则
  TextColumn? get ruleNextPage => text().nullable()(); // 下一页规则
  TextColumn? get ruleTitle => text().nullable()(); // 标题规则
  TextColumn? get rulePubDate => text().nullable()(); // 日期规则
  TextColumn? get ruleDescription => text().nullable()(); // 描述规则
  TextColumn? get ruleImage => text().nullable()(); // 图片规则
  TextColumn? get ruleLink => text().nullable()(); // 链接规则
  TextColumn? get ruleContent => text().nullable()(); // 正文规则
  TextColumn? get contentWhitelist => text().nullable()(); // 正文白名单
  TextColumn? get contentBlacklist => text().nullable()(); // 正文黑名单
  TextColumn? get shouldOverrideUrlLoading => text().nullable()(); // 跳转拦截
  TextColumn? get style => text().nullable()(); // WebView样式
  BoolColumn get enableJs =>
      boolean().withDefault(const Constant(true))(); // 启用JS
  BoolColumn get loadWithBaseUrl =>
      boolean().withDefault(const Constant(true))(); // 使用BaseURL
  TextColumn? get injectJs => text().nullable()(); // 注入JS
  TextColumn? get preloadJs => text().nullable()(); // 预注入JS
  TextColumn? get startHtml => text().nullable()(); // 起始页HTML
  TextColumn? get startStyle => text().nullable()(); // 起始样式
  TextColumn? get startJs => text().nullable()(); // 起始JS
  BoolColumn get showWebLog =>
      boolean().withDefault(const Constant(false))(); // 显示日志
  IntColumn get lastUpdateTime =>
      integer().withDefault(const Constant(0))(); // 更新时间
  IntColumn get customOrder => integer().withDefault(const Constant(0))(); // 排序
  IntColumn get type => integer().withDefault(const Constant(0))(); // 类型
  BoolColumn get preload =>
      boolean().withDefault(const Constant(false))(); // 预加载
  BoolColumn get cacheFirst =>
      boolean().withDefault(const Constant(false))(); // 优先缓存
  TextColumn? get searchUrl => text().nullable()(); // 搜索URL
  TextColumn get redirectPolicy =>
      text().withDefault(const Constant('ASK_CROSS_ORIGIN'))(); // 重定向策略

  @override
  Set<Column> get primaryKey => {sourceUrl};
}

/// RSS 文章（rssArticles）
/// 对应原：RssArticle.kt
/// 联合主键：(origin, link, sort)
class RssArticles extends Table {
  TextColumn get origin => text()(); // 主键1
  TextColumn get sort => text()(); // 主键2
  TextColumn get title => text()(); // 标题
  IntColumn get order => integer().withDefault(const Constant(0))(); // 排序
  TextColumn get link => text()(); // 主键3
  TextColumn? get pubDate => text().nullable()(); // 发布日期
  TextColumn? get description => text().nullable()(); // 描述
  TextColumn? get content => text().nullable()(); // 正文
  TextColumn? get image => text().nullable()(); // 图片
  TextColumn get group => text().withDefault(const Constant('默认分组'))(); // 分组
  BoolColumn get read => boolean().withDefault(const Constant(false))(); // 已读
  TextColumn? get variable => text().nullable()(); // 变量
  IntColumn get type => integer().withDefault(const Constant(0))(); // 类型
  IntColumn get durPos => integer().withDefault(const Constant(0))(); // 阅读进度

  @override
  Set<Column> get primaryKey => {origin, link, sort};
}

/// RSS 收藏（rssStars）
/// 对应原：RssStar.kt
/// 联合主键：(origin, link)
class RssStars extends Table {
  TextColumn get origin => text()(); // 主键1
  TextColumn get sort => text()(); // 分类
  TextColumn get title => text()(); // 标题
  IntColumn get starTime => integer().withDefault(const Constant(0))(); // 收藏时间
  TextColumn get link => text()(); // 主键2
  TextColumn? get pubDate => text().nullable()(); // 发布日期
  TextColumn? get description => text().nullable()(); // 描述
  TextColumn? get content => text().nullable()(); // 正文
  TextColumn? get image => text().nullable()(); // 图片
  TextColumn get group => text().withDefault(const Constant('默认分组'))(); // 分组
  TextColumn? get variable => text().nullable()(); // 变量
  IntColumn get type => integer().withDefault(const Constant(0))(); // 类型
  IntColumn get durPos => integer().withDefault(const Constant(0))(); // 阅读进度

  @override
  Set<Column> get primaryKey => {origin, link};
}

/// RSS 阅读记录（rssReadRecords）
/// 对应原：RssReadRecord.kt
/// 主键：record
class RssReadRecords extends Table {
  TextColumn get record => text()(); // 主键
  TextColumn? get title => text().nullable()(); // 标题
  IntColumn? get readTime => integer().nullable()(); // 阅读时间
  BoolColumn get read => boolean().withDefault(const Constant(true))(); // 是否已读
  TextColumn get origin => text().withDefault(const Constant(''))(); // 来源
  TextColumn get sort => text().withDefault(const Constant(''))(); // 分类
  TextColumn? get image => text().nullable()(); // 图片
  IntColumn get type => integer().withDefault(const Constant(0))(); // 类型
  IntColumn get durPos => integer().withDefault(const Constant(0))(); // 阅读进度
  TextColumn? get pubDate => text().nullable()(); // 发布日期

  @override
  Set<Column> get primaryKey => {record};
}

// ═══════════════════════════════════════════════════════════════════════════════
// 第 4 批：规则与工具（4 张）
// ═══════════════════════════════════════════════════════════════════════════════

/// 替换规则（replace_rules）
/// 对应原：ReplaceRule.kt
/// 主键：id（自增）
class ReplaceRules extends Table {
  IntColumn get id => integer().autoIncrement()(); // 自增主键（自动成为主键）
  TextColumn get name => text().withDefault(const Constant(''))(); // 名称
  TextColumn? get group => text().nullable()(); // 分组
  TextColumn get pattern => text().withDefault(const Constant(''))(); // 匹配模式
  TextColumn get replacement => text().withDefault(const Constant(''))(); // 替换为
  TextColumn? get scope => text().nullable()(); // 作用范围
  BoolColumn get scopeTitle =>
      boolean().withDefault(const Constant(false))(); // 作用于标题
  BoolColumn get scopeContent =>
      boolean().withDefault(const Constant(true))(); // 作用于正文
  TextColumn? get excludeScope => text().nullable()(); // 排除范围
  BoolColumn get isEnabled =>
      boolean().withDefault(const Constant(true))(); // 启用
  BoolColumn get isRegex => boolean().withDefault(const Constant(true))(); // 正则
  IntColumn get timeoutMillisecond =>
      integer().withDefault(const Constant(3000))(); // 超时
  IntColumn get order => integer().withDefault(const Constant(0))(); // 排序
}

/// 高亮规则（highlightRules）
/// 对应原：HighlightRule.kt
/// 主键：id
class HighlightRules extends Table {
  TextColumn get id =>
      text().clientDefault(() => _generateUuid())(); // 主键（UUID）
  TextColumn get name => text()(); // 规则名
  TextColumn get pattern => text()(); // 正则
  TextColumn get sampleText => text()(); // 示例文本
  IntColumn get targetScope =>
      integer().withDefault(const Constant(0))(); // 作用域
  BoolColumn get enabled => boolean().withDefault(const Constant(true))(); // 启用
  IntColumn get position => integer().withDefault(const Constant(0))(); // 排序
  IntColumn? get textColor => integer().nullable()(); // 文字颜色
  IntColumn? get bgColor => integer().nullable()(); // 背景颜色
  IntColumn get underlineMode =>
      integer().withDefault(const Constant(0))(); // 下划线模式
  IntColumn? get underlineColor => integer().nullable()(); // 下划线颜色
  RealColumn get underlineWidth =>
      real().withDefault(const Constant(1.0))(); // 下划线宽度
  RealColumn get underlineOffset =>
      real().withDefault(const Constant(2.0))(); // 下划线偏移
  TextColumn? get underlineSvgPath => text().nullable()(); // SVG路径
  TextColumn? get bgImage => text().nullable()(); // 背景图
  IntColumn get bgImageFit =>
      integer().withDefault(const Constant(0))(); // 背景图适配
  RealColumn get bgImageScale =>
      real().withDefault(const Constant(1.0))(); // 背景图缩放
  TextColumn? get configName => text().nullable()(); // 配置名
  TextColumn? get fontPath => text().nullable()(); // 字体路径

  @override
  Set<Column> get primaryKey => {id};
}

/// 缓存（caches）
/// 对应原：Cache.kt
/// 主键：key
class Caches extends Table {
  TextColumn get key => text()(); // 主键
  TextColumn? get value => text().nullable()(); // 缓存值
  IntColumn get deadline => integer().withDefault(const Constant(0))(); // 过期时间

  @override
  Set<Column> get primaryKey => {key};
}

/// Cookie（cookies）
/// 对应原：Cookie.kt
/// 主键：url
class Cookies extends Table {
  TextColumn get url => text()(); // 主键
  TextColumn get cookie => text()(); // Cookie值

  @override
  Set<Column> get primaryKey => {url};
}

// ═══════════════════════════════════════════════════════════════════════════════
// 第 6 批：配置（1 张）
// ═══════════════════════════════════════════════════════════════════════════════

/// 书籍分组（book_groups）
/// 对应原：BookGroup.kt
/// 主键：groupId
class BookGroups extends Table {
  IntColumn get groupId => integer().withDefault(const Constant(1))(); // 主键
  TextColumn get groupName => text()(); // 分组名
  TextColumn? get cover => text().nullable()(); // 封面
  IntColumn get order => integer().withDefault(const Constant(0))(); // 排序
  BoolColumn get enableRefresh =>
      boolean().withDefault(const Constant(true))(); // 刷新
  BoolColumn get show => boolean().withDefault(const Constant(true))(); // 显示
  IntColumn get bookSort => integer().withDefault(const Constant(-1))(); // 排序方式
  BoolColumn get isPrivate =>
      boolean().withDefault(const Constant(false))(); // 私密

  @override
  Set<Column> get primaryKey => {groupId};
}

// ═══════════════════════════════════════════════════════════════════════════════
// 第 5 批：正文处理（1 张）
// ═══════════════════════════════════════════════════════════════════════════════

/// 正文处理（book_content_processes）
/// 对应原：BookContentProcess.kt
/// 主键：id
class BookContentProcesses extends Table {
  TextColumn get id => text()(); // 主键
  TextColumn get bookUrl => text()(); // 书籍URL
  IntColumn? get chapterIndex => integer().nullable()(); // 章节索引
  TextColumn get kind =>
      text()(); // 处理类型：ai_clean/ai_rewrite/user_underline/user_highlight
  TextColumn get stage =>
      text().withDefault(const Constant('content'))(); // 阶段：content/style
  TextColumn get target => text().withDefault(
    const Constant('selection'),
  )(); // 目标：selection/paragraph/chapter
  TextColumn get anchorJson => text()(); // 锚点JSON
  TextColumn get actionJson => text()(); // 动作JSON
  TextColumn? get styleJson => text().nullable()(); // 样式JSON
  TextColumn get source =>
      text().withDefault(const Constant('user'))(); // 来源：user/ai
  TextColumn? get aiArtifactId => text().nullable()(); // AI工件ID
  TextColumn? get sourceContentHash => text().nullable()(); // 源内容哈希
  BoolColumn get enabled => boolean().withDefault(const Constant(true))(); // 启用
  IntColumn get sortOrder => integer().withDefault(const Constant(0))(); // 排序
  IntColumn get status =>
      integer().withDefault(const Constant(1))(); // 状态：0草稿/1激活/2禁用/3删除
  IntColumn get schemaVersion =>
      integer().withDefault(const Constant(1))(); // 版本
  IntColumn get createdAt => integer().clientDefault(
    () => DateTime.now().millisecondsSinceEpoch,
  )(); // 创建时间
  IntColumn get updatedAt => integer().clientDefault(
    () => DateTime.now().millisecondsSinceEpoch,
  )(); // 更新时间

  @override
  Set<Column> get primaryKey => {id};
}

// ═══════════════════════════════════════════════════════════════════════════════
// 第 6 批：字典 & 规则工具（4 张）
// ═══════════════════════════════════════════════════════════════════════════════

/// 字典规则（dictRules）
/// 对应原：DictRule.kt
/// 主键：name
class DictRules extends Table {
  TextColumn get name => text()(); // 主键
  TextColumn get urlRule => text()(); // URL规则
  TextColumn get showRule => text()(); // 显示规则
  BoolColumn get enabled => boolean().withDefault(const Constant(true))(); // 启用
  IntColumn get sortNumber => integer().withDefault(const Constant(0))(); // 排序

  @override
  Set<Column> get primaryKey => {name};
}

/// 规则子项（ruleSubs）
/// 对应原：RuleSub.kt
/// 主键：id
class RuleSubs extends Table {
  IntColumn get id => integer().clientDefault(
    () => DateTime.now().millisecondsSinceEpoch,
  )(); // 主键
  TextColumn get name => text()(); // 名称
  TextColumn get url => text()(); // URL
  IntColumn get type =>
      integer().withDefault(const Constant(0))(); // 类型：0书源/1订阅源/2替换规则/3自动
  IntColumn get customOrder => integer().withDefault(const Constant(0))(); // 排序
  BoolColumn get autoUpdate =>
      boolean().withDefault(const Constant(false))(); // 自动更新
  IntColumn get update => integer().clientDefault(
    () => DateTime.now().millisecondsSinceEpoch,
  )(); // 更新时间

  @override
  Set<Column> get primaryKey => {id};
}

/// 键盘辅助（keyboardAssists）
/// 对应原：KeyboardAssist.kt
/// 联合主键：(type, key)
class KeyboardAssists extends Table {
  IntColumn get type => integer().withDefault(const Constant(0))(); // 主键1
  TextColumn get key => text().withDefault(const Constant(''))(); // 主键2
  TextColumn get value => text().withDefault(const Constant(''))(); // 值
  IntColumn get serialNo => integer().withDefault(const Constant(0))(); // 序号

  @override
  Set<Column> get primaryKey => {type, key};
}

/// 服务端配置（servers）
/// 对应原：Server.kt
/// 主键：id
class Servers extends Table {
  IntColumn get id => integer().clientDefault(
    () => DateTime.now().millisecondsSinceEpoch,
  )(); // 主键
  TextColumn get name => text()(); // 名称
  TextColumn get type => text().withDefault(const Constant('WEBDAV'))(); // 类型
  TextColumn? get config => text().nullable()(); // 配置JSON

  @override
  Set<Column> get primaryKey => {id};
}

// ═══════════════════════════════════════════════════════════════════════════════
// 第 7 批：搜索 & TTS（3 张）
// ═══════════════════════════════════════════════════════════════════════════════

/// HTTP TTS（httpTTS）
/// 对应原：HttpTTS.kt（实现 BaseSource 接口）
/// 主键：id
class HttpTTSList extends Table {
  IntColumn get id => integer().clientDefault(
    () => DateTime.now().millisecondsSinceEpoch,
  )(); // 主键
  TextColumn get name => text()(); // 名称
  TextColumn get url => text()(); // URL
  TextColumn? get contentType => text().nullable()(); // 内容类型
  TextColumn? get concurrentRate => text().nullable()(); // 并发率
  TextColumn? get loginUrl => text().nullable()(); // 登录地址
  TextColumn? get loginUi => text().nullable()(); // 登录UI
  TextColumn? get header => text().nullable()(); // 请求头
  TextColumn? get jsLib => text().nullable()(); // JS库
  BoolColumn? get enabledCookieJar => boolean().nullable()(); // CookieJar
  TextColumn? get loginCheckJs => text().nullable()(); // 登录检测JS
  IntColumn get lastUpdateTime =>
      integer().withDefault(const Constant(0))(); // 更新时间

  @override
  Set<Column> get primaryKey => {id};
}

/// 搜索关键词（search_keywords）
/// 对应原：SearchKeyword.kt
/// 主键：word
class SearchKeywords extends Table {
  TextColumn get word => text()(); // 主键
  IntColumn get usage => integer().withDefault(const Constant(1))(); // 使用次数
  IntColumn get lastUseTime => integer().clientDefault(
    () => DateTime.now().millisecondsSinceEpoch,
  )(); // 最后使用时间

  @override
  Set<Column> get primaryKey => {word};
}

/// 搜索内容历史（search_content_history）
/// 对应原：SearchContentHistory.kt
/// 主键：id（自增）
class SearchContentHistory extends Table {
  IntColumn get id => integer().autoIncrement()(); // 自增主键
  TextColumn get bookName => text().withDefault(const Constant(''))(); // 书名
  TextColumn get bookAuthor => text().withDefault(const Constant(''))(); // 作者
  TextColumn get query => text()(); // 搜索词
  IntColumn get time => integer().clientDefault(
    () => DateTime.now().millisecondsSinceEpoch,
  )(); // 时间
}

// ═══════════════════════════════════════════════════════════════════════════════
// 第 8 批：首页模块（2 张）
// ═══════════════════════════════════════════════════════════════════════════════

/// 首页模块（homepage_modules）
/// 对应原：HomepageModule.kt
/// 主键：id
class HomepageModules extends Table {
  TextColumn get id => text()(); // 主键
  TextColumn get sourceUrl => text()(); // 源URL
  TextColumn get moduleKey => text()(); // 模块键
  TextColumn get type => text()(); // 类型
  TextColumn get title => text()(); // 标题
  TextColumn? get args => text().nullable()(); // 参数
  TextColumn? get layoutConfig => text().nullable()(); // 布局配置
  TextColumn? get url => text().nullable()(); // URL
  BoolColumn get isEnabled =>
      boolean().withDefault(const Constant(true))(); // 启用
  IntColumn get sortOrder => integer().withDefault(const Constant(0))(); // 排序
  TextColumn? get customSetId => text().nullable()(); // 自定义集ID
  BoolColumn get isUserCreated =>
      boolean().withDefault(const Constant(false))(); // 用户创建
  TextColumn? get customTitle => text().nullable()(); // 自定义标题
  TextColumn? get customSetTitle => text().nullable()(); // 自定义集标题
  TextColumn? get sourceJsonHash => text().nullable()(); // 源JSON哈希
  IntColumn get syncedAt => integer().withDefault(const Constant(0))(); // 同步时间

  @override
  Set<Column> get primaryKey => {id};
}

/// 首页自定义集（homepage_custom_sets）
/// 对应原：HomepageCustomSet.kt
/// 主键：id
class HomepageCustomSets extends Table {
  TextColumn get id => text()(); // 主键
  TextColumn get name => text()(); // 名称
  IntColumn get sortOrder => integer().withDefault(const Constant(0))(); // 排序

  @override
  Set<Column> get primaryKey => {id};
}

// ═══════════════════════════════════════════════════════════════════════════════
// 第 9 批：高亮标签规则（2 张）
// ═══════════════════════════════════════════════════════════════════════════════

/// 高亮标签规则（highlight_tag_rules）
/// 对应原：HighlightTagRule.kt
/// 主键：id
class HighlightTagRules extends Table {
  IntColumn get id => integer().clientDefault(
    () => DateTime.now().millisecondsSinceEpoch,
  )(); // 主键
  TextColumn get title => text()(); // 标题
  TextColumn get pattern => text()(); // 正则
  BoolColumn get enabled => boolean().withDefault(const Constant(true))(); // 启用
  IntColumn get order => integer().withDefault(const Constant(0))(); // 排序

  @override
  Set<Column> get primaryKey => {id};
}

/// 标签分组规则（tag_group_rules）
/// 对应原：TagGroupRule.kt
/// 主键：id
class TagGroupRules extends Table {
  IntColumn get id => integer().clientDefault(
    () => DateTime.now().millisecondsSinceEpoch,
  )(); // 主键
  TextColumn get pattern => text()(); // 正则
  TextColumn get groupName => text()(); // 分组名
  IntColumn get order => integer().withDefault(const Constant(0))(); // 排序

  @override
  Set<Column> get primaryKey => {id};
}

// ═══════════════════════════════════════════════════════════════════════════════
// 第 10 批：AI 功能（9 张）
// ═══════════════════════════════════════════════════════════════════════════════

/// AI 提供方配置（ai_provider_profiles）
/// 对应原：AiProviderProfile.kt
/// 主键：id
class AiProviderProfiles extends Table {
  TextColumn get id => text()(); // 主键
  TextColumn get name => text()(); // 名称
  TextColumn get protocol => text()(); // 协议
  TextColumn get baseUrl => text()(); // 基础URL
  TextColumn? get modelsUrl => text().nullable()(); // 模型列表URL
  TextColumn get apiKey => text().withDefault(const Constant(''))(); // API密钥
  TextColumn get authType =>
      text().withDefault(const Constant('bearer'))(); // 认证类型
  TextColumn? get secretRef => text().nullable()(); // 密钥引用
  TextColumn? get headersJson => text().nullable()(); // 请求头JSON
  TextColumn? get chatPath => text().nullable()(); // 聊天路径
  TextColumn? get responsesPath => text().nullable()(); // 响应路径
  TextColumn? get messagesPath => text().nullable()(); // 消息路径
  TextColumn? get modelsPath => text().nullable()(); // 模型路径
  TextColumn? get customHeadersJson => text().nullable()(); // 自定义请求头JSON
  BoolColumn get enabled => boolean().withDefault(const Constant(true))(); // 启用
  IntColumn get createdAt => integer().clientDefault(
    () => DateTime.now().millisecondsSinceEpoch,
  )(); // 创建时间
  IntColumn get updatedAt => integer().clientDefault(
    () => DateTime.now().millisecondsSinceEpoch,
  )(); // 更新时间

  @override
  Set<Column> get primaryKey => {id};
}

/// AI 模型配置（ai_model_profiles）
/// 对应原：AiModelProfile.kt
/// 主键：id，索引：(providerId)
class AiModelProfiles extends Table {
  TextColumn get id => text()(); // 主键
  TextColumn get providerId => text()(); // 提供方ID
  TextColumn get displayName => text()(); // 显示名称
  TextColumn get modelId => text()(); // 模型ID
  IntColumn get contextWindow =>
      integer().withDefault(const Constant(0))(); // 上下文窗口
  IntColumn get maxOutputTokens =>
      integer().withDefault(const Constant(0))(); // 最大输出Token
  TextColumn get capabilities => text().withDefault(const Constant(''))(); // 能力
  TextColumn? get defaultParamsJson => text().nullable()(); // 默认参数JSON
  BoolColumn get enabled => boolean().withDefault(const Constant(true))(); // 启用
  IntColumn get sortNumber => integer().withDefault(const Constant(0))(); // 排序
  IntColumn get createdAt => integer().clientDefault(
    () => DateTime.now().millisecondsSinceEpoch,
  )(); // 创建时间
  IntColumn get updatedAt => integer().clientDefault(
    () => DateTime.now().millisecondsSinceEpoch,
  )(); // 更新时间

  @override
  Set<Column> get primaryKey => {id};
}

/// AI 任务预设（ai_task_presets）
/// 对应原：AiTaskPreset.kt
/// 主键：id，索引：(taskType), (modelProfileId)
class AiTaskPresets extends Table {
  TextColumn get id => text()(); // 主键
  TextColumn get taskType => text()(); // 任务类型
  TextColumn get name => text()(); // 名称
  TextColumn get modelProfileId => text()(); // 模型ID
  TextColumn get promptTemplate => text()(); // 提示词模板
  TextColumn? get paramsJson => text().nullable()(); // 参数JSON
  TextColumn? get chunkPolicyJson => text().nullable()(); // 分块策略JSON
  BoolColumn get enabled => boolean().withDefault(const Constant(true))(); // 启用
  BoolColumn get isDefault =>
      boolean().withDefault(const Constant(false))(); // 默认
  IntColumn get sortNumber => integer().withDefault(const Constant(0))(); // 排序
  IntColumn get createdAt => integer().clientDefault(
    () => DateTime.now().millisecondsSinceEpoch,
  )(); // 创建时间
  IntColumn get updatedAt => integer().clientDefault(
    () => DateTime.now().millisecondsSinceEpoch,
  )(); // 更新时间

  @override
  Set<Column> get primaryKey => {id};
}

/// AI 工件（ai_artifacts）
/// 对应原：AiArtifact.kt
/// 主键：id，索引：(bookUrl, chapterIndex, taskType), (contentHash, promptHash, modelProfileId)
class AiArtifacts extends Table {
  TextColumn get id => text()(); // 主键
  TextColumn get taskType => text()(); // 任务类型
  TextColumn get bookUrl => text()(); // 书籍URL
  IntColumn? get chapterIndex => integer().nullable()(); // 章节索引
  TextColumn get contentHash => text()(); // 内容哈希
  TextColumn get promptHash => text()(); // 提示词哈希
  TextColumn get modelProfileId => text()(); // 模型ID
  IntColumn get status =>
      integer().withDefault(const Constant(0))(); // 状态：0待处理/1处理中/2成功/3失败
  TextColumn? get output => text().nullable()(); // 输出
  TextColumn? get errorMessage => text().nullable()(); // 错误信息
  IntColumn get schemaVersion =>
      integer().withDefault(const Constant(1))(); // 版本
  IntColumn get createdAt => integer().clientDefault(
    () => DateTime.now().millisecondsSinceEpoch,
  )(); // 创建时间
  IntColumn get updatedAt => integer().clientDefault(
    () => DateTime.now().millisecondsSinceEpoch,
  )(); // 更新时间

  @override
  Set<Column> get primaryKey => {id};
}

/// AI 聊天会话（ai_chat_conversations）
/// 对应原：AiChatConversation.kt
/// 主键：id
class AiChatConversations extends Table {
  TextColumn get id => text()(); // 主键
  TextColumn get title => text()(); // 标题
  TextColumn get reasoningLevel =>
      text().withDefault(const Constant('auto'))(); // 推理级别
  TextColumn? get modelProfileId => text().nullable()(); // 模型ID
  IntColumn get createdAt => integer().clientDefault(
    () => DateTime.now().millisecondsSinceEpoch,
  )(); // 创建时间
  IntColumn get updatedAt => integer().clientDefault(
    () => DateTime.now().millisecondsSinceEpoch,
  )(); // 更新时间

  @override
  Set<Column> get primaryKey => {id};
}

/// AI 聊天消息（ai_chat_messages）
/// 对应原：AiChatMessage.kt
/// 主键：id，索引：(conversationId, createdAt)
class AiChatMessages extends Table {
  TextColumn get id => text()(); // 主键
  TextColumn get conversationId => text()(); // 会话ID
  TextColumn get role => text()(); // 角色
  TextColumn get partsJson => text()(); // 内容JSON
  IntColumn get createdAt => integer().clientDefault(
    () => DateTime.now().millisecondsSinceEpoch,
  )(); // 创建时间
  IntColumn get branchIndex =>
      integer().withDefault(const Constant(0))(); // 分支索引
  BoolColumn get isSelected =>
      boolean().withDefault(const Constant(true))(); // 选中
  TextColumn? get parentMessageId => text().nullable()(); // 父消息ID
  IntColumn get thinkingDuration =>
      integer().withDefault(const Constant(0))(); // 思考时长

  @override
  Set<Column> get primaryKey => {id};
}

/// AI 记忆（ai_memory）
/// 对应原：AiMemory.kt
/// 联合主键：(conversationId, key)，索引：(conversationId)
class AiMemories extends Table {
  TextColumn get conversationId => text()(); // 主键1
  TextColumn get key => text()(); // 主键2
  TextColumn get value => text()(); // 值
  IntColumn get updatedAt => integer().clientDefault(
    () => DateTime.now().millisecondsSinceEpoch,
  )(); // 更新时间

  @override
  Set<Column> get primaryKey => {conversationId, key};
}

/// AI 提示词预设（ai_prompt_presets）
/// 对应原：AiPromptPreset.kt
/// 主键：id，索引：(taskType, enabled, sortNumber)
class AiPromptPresets extends Table {
  TextColumn get id => text()(); // 主键
  TextColumn get taskType => text()(); // 任务类型
  TextColumn get name => text()(); // 名称
  TextColumn get instruction => text()(); // 指令
  BoolColumn get enabled => boolean().withDefault(const Constant(true))(); // 启用
  BoolColumn get builtIn =>
      boolean().withDefault(const Constant(false))(); // 内置
  IntColumn get sortNumber => integer().withDefault(const Constant(0))(); // 排序
  IntColumn get createdAt => integer().clientDefault(
    () => DateTime.now().millisecondsSinceEpoch,
  )(); // 创建时间
  IntColumn get updatedAt => integer().clientDefault(
    () => DateTime.now().millisecondsSinceEpoch,
  )(); // 更新时间

  @override
  Set<Column> get primaryKey => {id};
}

// ═══════════════════════════════════════════════════════════════════════════════
// 数据库定义
// ═══════════════════════════════════════════════════════════════════════════════

/// Legado 应用数据库
///
/// 全部 38 张表已定义完毕
@DriftDatabase(
  tables: [
    // 第 1 批：核心
    Books,
    BookChapters,
    BookSources,
    SearchBooks,
    Bookmarks,
    // 第 2 批：阅读记录
    ReadRecords,
    ReadRecordDetails,
    ReadRecordSessions,
    TxtTocRules,
    // 第 3 批：RSS
    RssSources,
    RssArticles,
    RssStars,
    RssReadRecords,
    // 第 4 批：规则与工具
    ReplaceRules,
    HighlightRules,
    Caches,
    Cookies,
    // 第 5 批：正文处理
    BookContentProcesses,
    // 第 6 批：字典 & 规则工具
    DictRules,
    RuleSubs,
    KeyboardAssists,
    Servers,
    // 第 7 批：搜索 & TTS
    HttpTTSList,
    SearchKeywords,
    SearchContentHistory,
    // 第 8 批：首页模块
    HomepageModules,
    HomepageCustomSets,
    // 第 9 批：高亮标签规则
    HighlightTagRules,
    TagGroupRules,
    // 第 10 批：AI 功能
    AiProviderProfiles,
    AiModelProfiles,
    AiTaskPresets,
    AiArtifacts,
    AiChatConversations,
    AiChatMessages,
    AiMemories,
    AiPromptPresets,
    // 第 6 批：配置
    BookGroups,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;

  /// 创建数据库实例（使用 Native SQLite）
  static Future<AppDatabase> create() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'legado.db'));

    // 确保 sqlite3 库已加载
    await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();

    // 使用 NativeDatabase 运行
    final database = AppDatabase(NativeDatabase(file));
    return database;
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// 工具函数
// ═══════════════════════════════════════════════════════════════════════════════

String _generateUuid() {
  final now = DateTime.now();
  final timestamp = now.millisecondsSinceEpoch;
  final random = (timestamp % 100000).toString().padLeft(5, '0');
  return '$timestamp-$random';
}
