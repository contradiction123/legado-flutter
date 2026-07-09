/// 简繁转换工具
///
/// 对标原：JsExtensions.t2s() / s2t()
/// 从 js_extensions.dart 中提取独立的简繁转换模块
class ChineseConvert {
  /// 繁体中文转简体中文
  static String t2s(String text) {
    final buffer = StringBuffer();
    for (final char in text.runes) {
      buffer.write(_t2s[String.fromCharCode(char)] ?? String.fromCharCode(char));
    }
    return buffer.toString();
  }

  /// 简体中文转繁体中文
  static String s2t(String text) {
    final buffer = StringBuffer();
    for (final char in text.runes) {
      buffer.write(_s2t[String.fromCharCode(char)] ?? String.fromCharCode(char));
    }
    return buffer.toString();
  }

  /// 中文数字转阿拉伯数字
  static String chineseNumToArabic(String text) {
    const map = {
      '零': '0', '一': '1', '二': '2', '三': '3', '四': '4',
      '五': '5', '六': '6', '七': '7', '八': '8', '九': '9',
    };
    final buffer = StringBuffer();
    for (var i = 0; i < text.length; i++) {
      buffer.write(map[text[i]] ?? text[i]);
    }
    return buffer.toString();
  }

  static const _s2t = {
    '国': '國', '为': '爲', '与': '與', '书': '書', '发': '發',
    '对': '對', '导': '導', '实': '實', '体': '體', '关': '關',
    '开': '開', '门': '門', '问': '問', '长': '長', '们': '們',
    '个': '個', '来': '來', '说': '說', '时': '時', '间': '間',
    '过': '過', '这': '這', '还': '還', '学': '學', '习': '習',
    '爱': '愛', '写': '寫', '读': '讀', '让': '讓', '请': '請',
    '认': '認', '识': '識', '见': '見', '点': '點', '进': '進',
    '会': '會', '后': '後', '应': '應', '变': '變', '当': '當',
    '给': '給', '谁': '誰', '两': '兩', '只': '隻', '许': '許',
    '论': '論', '评': '評', '试': '試', '该': '該',
  };

  static const _t2s = {
    '國': '国', '爲': '为', '與': '与', '書': '书', '發': '发',
    '對': '对', '導': '导', '實': '实', '體': '体', '關': '关',
    '開': '开', '門': '门', '問': '问', '長': '长', '們': '们',
    '個': '个', '來': '来', '說': '说', '時': '时', '間': '间',
    '過': '过', '這': '这', '還': '还', '學': '学', '習': '习',
    '愛': '爱', '寫': '写', '讀': '读', '讓': '让', '請': '请',
    '認': '认', '識': '识', '見': '见', '點': '点', '進': '进',
    '會': '会', '後': '后', '應': '应', '變': '变', '當': '当',
    '給': '给', '誰': '谁', '兩': '两', '隻': '只', '許': '许',
    '論': '论', '評': '评', '試': '试', '該': '该',
  };
}
