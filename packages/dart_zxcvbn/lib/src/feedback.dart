part of 'zxcvbn.dart';

final _defaultFeedback = Feedback(
  warning: null,
  suggestions: [],
);

class Feedback {
  static EstimatedGuessesMixin getLongestMatch(
      List<EstimatedGuessesMixin> sequence) {
    EstimatedGuessesMixin longestMatch = sequence[0];
    final slicedSequence = sequence.sublist(1);

    slicedSequence.forEach((match) {
      if (match.token.length > longestMatch.token.length) {
        longestMatch = match;
      }
    });

    return longestMatch;
  }

  static Feedback? getMatchFeedback(
      EstimatedGuessesMixin match, bool isSoleMatch) {
    // TODO return here, after properly implementing feedback to all matchers
    if (_defaultMatchers.containsKey(match.pattern)) {
      return _defaultMatchers[match.pattern]!().feedback(match, isSoleMatch);
    }
    // if (
    //   zxcvbnOptions.matchers[match.pattern] &&
    //   'feedback' in zxcvbnOptions.matchers[match.pattern]
    // ) {
    //   return zxcvbnOptions.matchers[match.pattern].feedback(match, isSoleMatch)
    // }

    return _defaultFeedback;
  }

  final String? warning;
  final List<String> suggestions;

  Feedback({
    this.warning,
    List<String>? suggestions,
  }) : this.suggestions = suggestions ?? [];

  factory Feedback.fromJson(Map<String, dynamic> json) => Feedback(
        warning: json['warning'],
        suggestions: List<String>.from(json['suggestions'], growable: false),
      );

  factory Feedback.getFeedback(
      double score, List<EstimatedGuessesMixin> sequence) {
    if (sequence.isEmpty) {
      return _defaultFeedback;
    }

    if (score > 2) {
      return _defaultFeedback;
    }

    final String extraFeedback =
        zxcvbn.options.translations.suggestions.anotherWord;

    final longestMatch = getLongestMatch(sequence);

    final feedback = getMatchFeedback(longestMatch, sequence.length == 1);

    if (feedback != null) {
      feedback.suggestions.insert(0, extraFeedback);
      return feedback;
    }

    return Feedback(
      warning: null,
      suggestions: [extraFeedback],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Feedback &&
          warning == other.warning &&
          ListEquality().equals(suggestions, other.suggestions);

  @override
  int get hashCode => warning.hashCode ^ suggestions.hashCode;

  @override
  String toString() => 'Feedback('
      'warning: $warning, '
      'suggestions: $suggestions'
      ')';
}
