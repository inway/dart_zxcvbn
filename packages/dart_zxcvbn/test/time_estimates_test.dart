import 'package:test/test.dart';
import 'package:dart_zxcvbn/dart_zxcvbn.dart';
import 'package:dart_zxcvbn_language_en/dart_zxcvbn_language_en.dart';

void main() {
  zxcvbn.setOptions(Options(
    translations: LanguageEn().translations,
  ));

  test(
    'should be very weak',
    () => expect(
      TimeEstimates.estimateAttackTimes(10),
      equals(
        TimeEstimates(
          crackTimesDisplay: CrackTimesDisplay(
            offlineFastHashing1e10PerSecond: 'less than a second',
            offlineSlowHashing1e4PerSecond: 'less than a second',
            onlineNoThrottling10PerSecond: '1 second',
            onlineThrottling100PerHour: '6 minutes',
          ),
          crackTimesSeconds: CrackTimesSeconds(
            offlineFastHashing1e10PerSecond: 1e-9,
            offlineSlowHashing1e4PerSecond: 0.001,
            onlineNoThrottling10PerSecond: 1,
            onlineThrottling100PerHour: 360,
          ),
          score: 0,
        ),
      ),
    ),
  );

  test(
    'should be weak',
    () => expect(
      TimeEstimates.estimateAttackTimes(100000),
      equals(
        TimeEstimates(
          crackTimesDisplay: CrackTimesDisplay(
            offlineFastHashing1e10PerSecond: 'less than a second',
            offlineSlowHashing1e4PerSecond: '10 seconds',
            onlineNoThrottling10PerSecond: '3 hours',
            onlineThrottling100PerHour: '1 month',
          ),
          crackTimesSeconds: CrackTimesSeconds(
            offlineFastHashing1e10PerSecond: 0.00001,
            offlineSlowHashing1e4PerSecond: 10,
            onlineNoThrottling10PerSecond: 10000,
            onlineThrottling100PerHour: 3600000,
          ),
          score: 1,
        ),
      ),
    ),
  );

  test(
    'should be good',
    () => expect(
      TimeEstimates.estimateAttackTimes(10000000),
      equals(
        TimeEstimates(
          crackTimesDisplay: CrackTimesDisplay(
            offlineFastHashing1e10PerSecond: 'less than a second',
            offlineSlowHashing1e4PerSecond: '17 minutes',
            onlineNoThrottling10PerSecond: '12 days',
            onlineThrottling100PerHour: '11 years',
          ),
          crackTimesSeconds: CrackTimesSeconds(
            offlineFastHashing1e10PerSecond: 0.001,
            offlineSlowHashing1e4PerSecond: 1000,
            onlineNoThrottling10PerSecond: 1000000,
            onlineThrottling100PerHour: 360000000,
          ),
          score: 2,
        ),
      ),
    ),
  );

  test(
    'should be very good',
    () => expect(
      TimeEstimates.estimateAttackTimes(1000000000),
      equals(
        TimeEstimates(
          crackTimesDisplay: CrackTimesDisplay(
            offlineFastHashing1e10PerSecond: 'less than a second',
            offlineSlowHashing1e4PerSecond: '1 day',
            onlineNoThrottling10PerSecond: '3 years',
            onlineThrottling100PerHour: 'centuries',
          ),
          crackTimesSeconds: CrackTimesSeconds(
            offlineFastHashing1e10PerSecond: 0.1,
            offlineSlowHashing1e4PerSecond: 100000,
            onlineNoThrottling10PerSecond: 100000000,
            onlineThrottling100PerHour: 36000000000,
          ),
          score: 3,
        ),
      ),
    ),
  );

  test(
    'should be excellent',
    () => expect(
      TimeEstimates.estimateAttackTimes(100000000000),
      equals(
        TimeEstimates(
          crackTimesDisplay: CrackTimesDisplay(
            offlineFastHashing1e10PerSecond: '10 seconds',
            offlineSlowHashing1e4PerSecond: '4 months',
            onlineNoThrottling10PerSecond: 'centuries',
            onlineThrottling100PerHour: 'centuries',
          ),
          crackTimesSeconds: CrackTimesSeconds(
            offlineFastHashing1e10PerSecond: 10,
            offlineSlowHashing1e4PerSecond: 10000000,
            onlineNoThrottling10PerSecond: 10000000000,
            onlineThrottling100PerHour: 3600000000000,
          ),
          score: 4,
        ),
      ),
    ),
  );
}
