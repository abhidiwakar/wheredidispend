import 'dart:math';

double processPart(String text) {
  int accumulator = 0;
  String oper = 'sum';

  List<String> parts = text.toLowerCase().split(' ');

  List<String> units = [
    '',
    'one',
    'two',
    'three',
    'four',
    'five',
    'six',
    'seven',
    'eight',
    'nine'
  ];
  List<String> teens = [
    '',
    'eleven',
    'twelve',
    'thirteen',
    'fourteen',
    'fifteen',
    'sixteen',
    'seventeen',
    'eighteen',
    'nineteen'
  ];
  List<String> tens = [
    '',
    'ten',
    'twenty',
    'thirty',
    'forty',
    'fifty',
    'sixty',
    'seventy',
    'eighty',
    'ninety',
    'hundred'
  ];
  List<String> thousands = [
    '',
    'thousand',
    'million',
    'billion',
    'trillion',
    'quadrillion',
    'quintillion',
    'sextillion',
    'septillion',
    'octillion',
    'nonillion',
    'decillion',
    'undecillion',
    'duodecillion',
    'tredecillion',
    'quattuordecillion',
    'sexdecillion',
    'septendecillion',
    'octodecillion',
    'novemdecillion',
    'vigintillion'
  ];

  List<int> number = [];
  List<int> totals = [];

  for (String part in parts) {
    oper = 'sum';
    int nr = 0;

    if (units.contains(part)) {
      nr = units.indexOf(part);
    }

    if (tens.contains(part)) {
      nr = int.parse("${tens.indexOf(part)}0");
      if (part == 'hundred') {
        oper = 'times';
      }
    }

    if (teens.contains(part)) {
      nr = int.parse("1${teens.indexOf(part)}");
    }

    if (thousands.contains(part)) {
      nr = int.parse(pow(1000, thousands.indexOf(part)).toString());
      oper = 'times';
    }

    if (oper == 'sum') {
      accumulator += nr;
    } else if (oper == 'times') {
      if (accumulator == 0) {
        accumulator = 1;
      }
      accumulator *= nr;
      totals.add(accumulator);
      accumulator = 0;
    }

    number.add(nr);
  }

  totals.add(accumulator);
  return totals.reduce((a, b) => a + b).toDouble();
}

double numberTextToInteger(String text) {
  List<String> parts = text.toLowerCase().split(' and ');
  String integerPart = parts[0];
  String decimalPart = parts.length > 1 ? parts[1].replaceAll('paise', '') : '';
  double integerResult = processPart(integerPart);
  double decimalResult =
      decimalPart.isNotEmpty ? processPart(decimalPart) / 100 : 0;
  return integerResult + decimalResult;
}
