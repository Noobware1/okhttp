import 'dart:collection';

abstract interface class _Map<K, V> implements Map<K, V> {
  const _Map();
}

// https://github.com/cfug/dio/blob/main/dio/lib/src/utils.dart#L138
Map<String, V> caseInsensitiveKeyMap<V>([Map<String, V>? value]) {
  final map = LinkedHashMap<String, V>(
    equals: (key1, key2) => key1.toLowerCase() == key2.toLowerCase(),
    hashCode: (key) => key.toLowerCase().hashCode,
  );
  if (value != null && value.isNotEmpty) map.addAll(value);
  return map;
}

class CommonMap<K, V> implements _Map<K, V> {
  const CommonMap(this._map);

  final Map<K, V> _map;

  // void apply(void Function(CommonMap<K, V>) fun) {
  //   return fun(this);
  // }

  // Map<K, V> get asMap => _map;

  @override
  V? operator [](Object? key) {
    return _map[key];
  }

  void add(K key, V value) {
    _map[key] = value;
  }

  @override
  void operator []=(K key, V value) {
    _map[key] = value;
  }

  @override
  void addAll(Map<K, V> other) {
    _map.addAll(other);
  }

  @override
  void addEntries(Iterable<MapEntry<K, V>> newEntries) {
    _map.addEntries(newEntries);
  }

  @override
  Map<RK, RV> cast<RK, RV>() {
    return _map.cast<RK, RV>();
  }

  @override
  void clear() {
    _map.clear();
  }

  @override
  bool containsKey(Object? key) {
    return _map.containsKey(key);
  }

  @override
  bool containsValue(Object? value) {
    return _map.containsValue(value);
  }

  @override
  Iterable<MapEntry<K, V>> get entries => _map.entries;

  @override
  void forEach(void Function(K key, V value) action) => _map.forEach(action);

  @override
  bool get isEmpty => _map.isEmpty;

  @override
  bool get isNotEmpty => _map.isNotEmpty;

  @override
  Iterable<K> get keys => _map.keys;

  @override
  int get length => _map.length;

  @override
  Map<K2, V2> map<K2, V2>(MapEntry<K2, V2> Function(K key, V value) convert) {
    return _map.map(convert);
  }

  @override
  V putIfAbsent(K key, V Function() ifAbsent) {
    return _map.putIfAbsent(key, ifAbsent);
  }

  @override
  V? remove(Object? key) {
    return _map.remove(key);
  }

  @override
  void removeWhere(bool Function(K key, V value) test) {
    return _map.removeWhere(test);
  }

  @override
  V update(K key, V Function(V value) update, {V Function()? ifAbsent}) {
    return _map.update(key, update, ifAbsent: ifAbsent);
  }

  @override
  void updateAll(V Function(K key, V value) update) {
    _map.updateAll(update);
  }

  @override
  String toString() {
    return _map.toString();
  }

  @override
  Iterable<V> get values => _map.values;
}
