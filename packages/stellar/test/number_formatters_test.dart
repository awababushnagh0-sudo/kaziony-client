import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stellar/src/components/input/s_number_formatters.dart';

String typed(TextInputFormatter formatter, String text, [String before = '']) =>
    formatter
        .formatEditUpdate(
          TextEditingValue(text: before),
          TextEditingValue(text: text),
        )
        .text;

void main() {
  test('money keeps digits and one point, 3 decimals at most', () {
    expect(typed(moneyFormatter, '7.500'), '7.500');
    expect(typed(moneyFormatter, 'a7b.5'), '7.5');
    expect(typed(moneyFormatter, '7.5009'), '7.500');
    expect(typed(moneyFormatter, '7.5.1'), '7.51');
    expect(typed(moneyFormatter, '٧٫٥'), '7.5');
    expect(typed(moneyFormatter, '7,5'), '7.5');
    // Past 5 whole digits, what was there stays.
    expect(typed(moneyFormatter, '123456', '12345'), '12345');
  });

  test('a whole number keeps digits only, Arabic ones as Western', () {
    expect(typed(wholeNumberFormatter, '12'), '12');
    expect(typed(wholeNumberFormatter, '1.5'), '15');
    expect(typed(wholeNumberFormatter, '٣٠'), '30');
    expect(typed(wholeNumberFormatter, '-3'), '3');
  });
}
