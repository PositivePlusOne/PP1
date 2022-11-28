extension FutureExtensions on Future {
  Future<void> timeoutSilently(Duration duration) async {
    try {
      await timeout(duration);
    } catch (ex) {
      print(ex);
    }
  }
}
