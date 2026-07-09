/// 测试用 HTML 样本数据
class TestHtmlSamples {
  /// 模拟搜索结果页 HTML
  static const String searchResult = '''<!DOCTYPE html>
<html><head><meta charset="utf-8">
<title>搜索_凡人修仙传</title></head>
<body>
<div class="result-list">
  <div class="result-item">
    <a href="/book/12345/" class="book-name">凡人修仙传</a>
    <span class="author">忘语</span>
    <span class="kind">仙侠</span>
    <img class="cover" src="/cover/frxxz.jpg" alt="封面"/>
    <p class="intro">一个普通少年踏入修仙界的传奇故事。</p>
    <span class="last-chapter">第一千三百章 飞升仙界</span>
    <span class="word-count">800万</span>
  </div>
  <div class="result-item">
    <a href="/book/67890/" class="book-name">凡人修仙传·仙界篇</a>
    <span class="author">忘语</span>
    <span class="kind">仙侠</span>
    <img class="cover" src="/cover/frxxz_xj.jpg" alt="封面"/>
    <p class="intro">仙界风云再起，韩立飞升后的故事。</p>
    <span class="last-chapter">第五百章 轮回殿主</span>
    <span class="word-count">500万</span>
  </div>
</div>
</body></html>''';

  /// 模拟书籍详情页 HTML
  static const String bookDetail = '''<!DOCTYPE html>
<html><head><meta charset="utf-8"></head>
<body>
<div class="book-info">
  <h1 class="book-name">凡人修仙传</h1>
  <div class="author">忘语</div>
  <img class="cover-img" src="https://example.com/cover.jpg" alt="封面"/>
  <div class="intro">一个普通少年踏入修仙界的传奇故事。韩立，一个普通的小山村少年，机缘巧合进入修仙世界...</div>
  <div class="kind">仙侠</div>
  <div class="word-count">800万字</div>
  <div class="last-chapter">第一千三百章 飞升仙界</div>
</div>
</body></html>''';

  /// 模拟目录页 HTML
  static const String chapterList = '''<!DOCTYPE html>
<html><head><meta charset="utf-8"></head>
<body>
<div class="chapter-list">
  <ul>
    <li><a href="/read/1.html">第一章 山边小村</a></li>
    <li><a href="/read/2.html">第二章 七玄门</a></li>
    <li><a href="/read/3.html">第三章 墨家姐妹</a></li>
    <li><a href="/read/4.html">第四章 血色试炼</a></li>
    <li><a href="/read/5.html">第五章 大衍诀</a></li>
  </ul>
</div>
</body></html>''';

  /// 模拟正文页 HTML
  static const String bookContent = '''<!DOCTYPE html>
<html><head><meta charset="utf-8"></head>
<body>
<div id="content">
<p>韩立盘膝坐在洞府之中，感受着体内澎湃的灵力流转。</p>
<p>经过数十年的苦修，他的修为已经达到了筑基后期大圆满的境界，距离结丹只有一步之遥。</p>
<p>然而这一步却如同天堑一般，难以跨越。</p>
<p>"看来，必须要去寻找传说中的九曲灵参了。"韩立低声自语道。</p>
</div>
</body></html>''';

  /// 模拟 JSON API 搜索结果
  static const String jsonSearchResult = '''
{
  "code": 0,
  "data": {
    "total": 1,
    "list": [
      {
        "bookId": "12345",
        "title": "凡人修仙传",
        "author": "忘语",
        "cover": "https://example.com/cover.jpg",
        "intro": "修仙传奇",
        "cat": "仙侠",
        "latestChapter": "第一千三百章",
        "words": "8000000"
      }
    ]
  }
}''';
}
