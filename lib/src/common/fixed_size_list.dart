import 'dart:collection';

class FixedLengthList<E> extends ListBase<E> {
  final List<E> _list;
  final int _length;

  FixedLengthList(this._length) : _list = List<E>.empty(growable: true);

  @override
  int get length => _length;

  @override
  set length(int value) {
    assert(value <= _length);
  }

  @override
  E operator [](int index) => _list[index];

  @override
  operator []=(int index, E value) {
    _list[index] = value;
  }

  @override
  void add(E element) {
    assert(_list.length <= _length);
    super.add(element);
  }

  @override
  void addAll(Iterable<E> iterable) {
    assert(_list.length + iterable.length <= _length);
    super.addAll(iterable);
  }
}
