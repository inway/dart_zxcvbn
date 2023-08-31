part of 'zxcvbn.dart';

class Dictionary {
  final Map<String, List<String>> _dictionary = {};

  Dictionary(Map<String, List<String>> dictionary) {
    _dictionary.addAll(dictionary);
  }

  Dictionary.merge(List<Dictionary> dictionaries) {
    for (var dictionary in dictionaries) {
      _dictionary.addAll(dictionary._dictionary);
    }
  }

  Iterable<String> get dictionaries => _dictionary.keys;

  List<String>? get(String name) {
    return _dictionary[name];
  }

  void set(String name, List<String> list) {
    _dictionary[name] = list;
  }

  @override
  String toString() => 'Dictionary{dictionaries: $dictionaries}';
}
