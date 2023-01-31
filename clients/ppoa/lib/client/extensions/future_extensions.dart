extension FutureExtensions on Future {
  Future<void> timeoutSilently(Duration duration) async {
    try {
      await timeout(duration);
    } catch (ex) {
      // ignore: avoid_print
      print(ex);
    }
  }
}
