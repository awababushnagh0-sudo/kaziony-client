import 'package:flutter_test/flutter_test.dart';
import 'package:partner/features/counter/domain/claim.dart';

import '../../fakes.dart';

void main() {
  group('ClaimCode.read', () {
    test('takes any case, spaces and dashes', () {
      expect(ClaimCode.read('abcd-2345'), 'ABCD2345');
      expect(ClaimCode.read(' ABCD 2345 '), 'ABCD2345');
    });

    test('refuses what the backend never makes', () {
      expect(ClaimCode.read('ABCD234'), isNull);
      expect(ClaimCode.read('ABCD23456'), isNull);
      // 0, 1, I, L and O look like each other.
      expect(ClaimCode.read('ABCD2340'), isNull);
      expect(ClaimCode.read('ABCDI345'), isNull);
      expect(ClaimCode.read('ABCDL345'), isNull);
      expect(ClaimCode.read('https://example.com'), isNull);
    });
  });

  group('Claim.problem', () {
    test('none when it can be picked up', () {
      expect(claim('ABCD2345').problem, isNull);
    });

    test('says why from its status', () {
      expect(
        claim(
          'ABCD2345',
          status: ClaimStatus.redeemed,
          canRedeem: false,
        ).problem,
        ClaimProblem.alreadyRedeemed,
      );
      expect(
        claim(
          'ABCD2345',
          status: ClaimStatus.cancelled,
          canRedeem: false,
        ).problem,
        ClaimProblem.cancelled,
      );
    });

    test('a refused reservation still on time is for another branch', () {
      expect(
        claim('ABCD2345', canRedeem: false).problem,
        ClaimProblem.otherBranch,
      );
    });
  });
}
