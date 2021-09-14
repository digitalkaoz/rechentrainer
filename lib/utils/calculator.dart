import 'dart:math';

import 'package:petitparser/petitparser.dart';

class EquationParser {
  static Parser<dynamic> instance = parser();

  static Parser<dynamic> parser() {
    final builder = ExpressionBuilder();

    builder.group()
      ..primitive(digit()
          .plus()
          .seq(char('.').seq(digit().plus()).optional())
          .flatten()
          .trim()
          .map((a) => num.tryParse(a)))
      ..wrapper(
          char('(').trim(), char(')').trim(), (String l, num a, String r) => a);

    builder.group().prefix(char('-').trim(), (String op, num a) => -a);

// power is right-associative
    builder
        .group()
        .right(char('^').trim(), (num a, String op, num b) => pow(a, b));

// multiplication and addition are left-associative
    builder.group()
      ..left(char('*').trim(), (num a, String op, num b) => a * b)
      ..left(char('/').trim(), (num a, String op, num b) => a / b);
    builder.group()
      ..left(char('+').trim(), (num a, String op, num b) => a + b)
      ..left(char('-').trim(), (num a, String op, num b) => a - b);

    return builder.build().end();
  }
}

List<Equation> createSet(
    int count, int range, int ops, List<String> arithmetics) {
  List<Equation> sets = [];

  for (var i = 0; i < count; i++) {
    sets.add(Equation.random(range, ops, arithmetics));
  }

  return sets;
}

class Equation {
  late final String plain;
  late final String masked;
  late final int solution;
  late final int result;
  int? answer;

  Equation(String line) {
    result =
        calc(line.contains(" = ") ? line.split(" = ").first : line).toInt();
    plain = line.contains(" = ") ? line : "$line = ${result.toString()}";
    masked = _maskLine(plain);

    var splitStart = masked.indexOf('?');
    var splitEnd = plain.indexOf(" ", masked.indexOf('?'));
    if (splitEnd == -1) {
      splitEnd = plain.length;
    }

    solution = int.parse(plain.substring(splitStart, splitEnd));
  }

  List<String> get parts => masked.split(" ");

  bool get solved => solution == answer;

  factory Equation.random(range, ops, arithmetics) {
    var eq = generate(range, ops, arithmetics);
    var res = calc(eq).toString();
    return Equation("$eq= $res");
  }

  static num calc(String equation) {
    final _parser = EquationParser.instance;

    return _parser.parse(equation).value;
  }

  static String generate(int range, int ops, List<String> arithmetics) {
    String eq = '';
    bool initial = true;
    var trys = 0;

    while (ops > 0) {
      var _eq = eq;
      if (initial) {
        _eq += Random()
                .nextInt(Random().nextBool() ? range : (range / ops).floor())
                .toString() +
            " ";
        eq = _eq;
        initial = false;
      }
      _eq += arithmetics[Random().nextInt(arithmetics.length)] + " ";
      _eq += Random()
              .nextInt(Random().nextBool() ? range : (range / ops).floor())
              .toString() +
          " ";

      var res = calc(_eq);
      trys++;
      if (res > 0 && res <= range) {
        eq = _eq;
        ops--;
      }
      if (trys == 100) {
        //start all over again
        initial = true;
        eq = '';
        trys = 0;
      }
    }

    return eq;
  }

  String _maskLine(String line) {
    var parts = line.split(' ');
    var hidden = false;
    while (!hidden) {
      var hideIndex = Random().nextInt(parts.length);
      if (int.tryParse(parts[hideIndex]) != null) {
        parts[hideIndex] = '?';
        hidden = true;
      }
    }

    return parts.join(" ");
  }
}

Set<dynamic> buildResultLine(String masked, String answer, String solution) {
  var _solution = solution.substring(
      masked.indexOf('?'), masked.indexOf(" ", masked.indexOf('?')));
  var solved = masked.replaceFirst('?', answer.trim()) == solution;

  return {masked, answer, _solution, solved};
}
