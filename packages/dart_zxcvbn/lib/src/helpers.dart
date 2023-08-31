part of 'zxcvbn.dart';

List<T> _sorted<T extends Match>(List<T> matches) {
  return matches
    ..sort((a, b) {
      final i = a.i.compareTo(b.i);
      if (i != 0) return i;
      return a.j.compareTo(b.j);
    });
}
