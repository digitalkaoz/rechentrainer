import 'package:flutter_test/flutter_test.dart';
import 'package:rechentrainer/utils/calculator.dart';

void main() {
  group('equation solving', () {
    test('addition', () {
      expect(Equation('42 + 4').result, 46);
      expect(Equation('42 + 4 = 46').result, 46);
    });

    test('substraction', () {
      expect(Equation('42 - 4').result, 38);
    });

    test('multiplication', () {
      expect(Equation('7 * 3').result, 21);
    });

    test('division', () {
      expect(Equation('12 / 4').result, 3);
    });

    test('addition and substraction', () {
      expect(Equation('42 + 4 - 6').result, 40);
    });

    test('addition and multiplication', () {
      expect(Equation('8 + 4 * 3').result, 20);
    });

    test('addition and division', () {
      expect(Equation('8 + 12 / 3').result, 12);
    });
    test('addition multiplication substraction', () {
      expect(Equation('8 + 12 * 2 - 2').result, 30);
    });
  });

  group('equation generator', () {
    test('single operation', () {
      expect(' + '.allMatches(Equation.random(10, 1, ['+']).plain).length, 1);
      expect(' + '.allMatches(Equation.random(10, 1, ['+']).masked).length, 1);

      expect(' * '.allMatches(Equation.random(100, 1, ['*']).plain).length, 1);
      expect(' - '.allMatches(Equation.random(50, 1, ['-']).plain).length, 1);
      expect(' / '.allMatches(Equation.random(25, 1, ['/']).plain).length, 1);
    });

    test('create sets', () {
      expect(createSet(10, 10, 2, ['+', '-']).length, 10);
      expect(createSet(100, 10, 2, ['+', '-', '*', '/']).length, 100);
    });
  });

  group('masking', () {
    test('masks exactly once', () {
      var eq = Equation("9 + 4");
      expect("?".allMatches(eq.masked).length, 1);
    });

    test('result generation', () {
      var eq = Equation("9 + 4");
      expect(eq.solved, false);

      if (!eq.masked.contains(" 4 ")) {
        expect(eq.solution, 4);
        eq.answer = 4;
        expect(eq.solved, true);
      } else if (!eq.masked.contains("9 ")) {
        expect(eq.solution, 9);
        eq.answer = 9;
        expect(eq.solved, true);
      } else {
        expect(eq.solution, 13);
        eq.answer = 11;
        expect(eq.solved, false);
      }
    });
  });
}
