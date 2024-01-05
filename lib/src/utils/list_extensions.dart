extension ListExtensions<E> on List<E> {
  List<E> dropLast(int n) {
    for (var i = 0; i < n; i++) {
      removeAt(length - 1);
    }
    return this;
  }
}
