class StrUtil {
  //時間のフォーマット
  static String formatToMS(int seconds) {
    Duration duration = Duration(seconds: seconds);
    return duration
        .toString()
        .replaceAll(RegExp("^0:"), "")
        .replaceAll(RegExp("\\..*"), "");
  }
}
