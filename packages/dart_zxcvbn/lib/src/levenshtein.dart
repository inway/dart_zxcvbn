part of 'zxcvbn.dart';

class FindLevenshteinDistanceResult {
  final int? levenshteinDistance;
  final String? levenshteinDistanceEntry;

  FindLevenshteinDistanceResult({
    this.levenshteinDistance,
    this.levenshteinDistanceEntry,
  });
}

/// Levenshtein algorithm implementation based on:
/// http://en.wikipedia.org/wiki/Levenshtein_distance#Iterative_with_two_matrix_rows
///
/// Original code by https://github.com/brinkler/levenshtein-dart released as
/// Public Domain
int levenshtein(String s, String t) {
  if (s == t) return 0;
  if (s.length == 0) return t.length;
  if (t.length == 0) return s.length;

  List<int> v0 = new List<int>.filled(t.length + 1, 0);
  List<int> v1 = new List<int>.filled(t.length + 1, 0);

  for (int i = 0; i < t.length + 1; i < i++) v0[i] = i;

  for (int i = 0; i < s.length; i++) {
    v1[0] = i + 1;

    for (int j = 0; j < t.length; j++) {
      int cost = (s[i] == t[j]) ? 0 : 1;
      v1[j + 1] = min(v1[j] + 1, min(v0[j + 1] + 1, v0[j] + cost));
    }

    for (int j = 0; j < t.length + 1; j++) {
      v0[j] = v1[j];
    }
  }

  return v1[t.length];
}

int getUsedThreshold(
  String password,
  String entry,
  int threshold,
) {
  bool isPasswordToShort = password.length <= entry.length;
  bool isThresholdLongerThanPassword = password.length <= threshold;
  bool shouldUsePasswordLength =
      isPasswordToShort || isThresholdLongerThanPassword;

  // if password is too small use the password length divided by 4 while the
  // threshold needs to be at least 1
  return shouldUsePasswordLength ? (password.length / 4).ceil() : threshold;
}

FindLevenshteinDistanceResult? findLevenshteinDistance(
  String password,
  Map<String, int> rankedDictionary,
  int threshold,
) {
  try {
    int foundDistance = 0;

    String found = rankedDictionary.keys.firstWhere((entry) {
      final usedThreshold = getUsedThreshold(password, entry, threshold);
      if ((password.length - entry.length).abs() > usedThreshold) {
        return false;
      }
      final foundEntryDistance = levenshtein(password, entry);
      final isInThreshold = foundEntryDistance <= usedThreshold;

      if (isInThreshold) {
        foundDistance = foundEntryDistance;
      }
      return isInThreshold;
    });

    return FindLevenshteinDistanceResult(
      levenshteinDistance: foundDistance,
      levenshteinDistanceEntry: found,
    );
  } on StateError {
    return null;
  }
}
