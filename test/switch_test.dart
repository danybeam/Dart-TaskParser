import 'package:test/test.dart';
import 'package:tuple/tuple.dart';
import 'package:task_parser/task_parser.dart' as parser;

void main() {
  group('Switch positive tests => ', () {
    test('parse switch alone', () {
      String expected = 'foo';
      expect(parser.parseSwitches(parser.Task(), 'foo'), expected);
    });

    test('parse switch alone (2 words)', () {
      String expected = 'foo bar';
      expect(parser.parseSwitches(parser.Task(), 'foo bar'), expected);
    });
  });

  group('Switch negative tests => ', () {
    test('raise error if label + value', () {
      expect(() => parser.parseSwitches(parser.Task(), 'foo:bar'),
          throwsFormatException);
    });
  });
}
