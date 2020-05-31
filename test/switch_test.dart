import 'package:test/test.dart';
import 'package:tuple/tuple.dart';
import 'package:task_parser/task_parser.dart' as parser;

void main() {
  group('Switch positive tests => ', () {
    test('parse switch alone', () {
      Tuple2<List<String>, String> expected = Tuple2(['foo'], '');
      expect(parser.parseSwitches('+foo'), expected);
    });

    test('parse switch alone (2 words)', () {
      Tuple2<List<String>, String> expected = Tuple2(['foo bar'], '');
      expect(parser.parseSwitches('+foo bar'), expected);
    });

    test('parse 2 switches', () {
      Tuple2<List<String>, String> expected = Tuple2(['foo', 'bar'], '');
      expect(parser.parseSwitches('+foo +bar'), expected);
    });

    test('parse switches with text before', () {
      Tuple2<List<String>, String> expected = Tuple2(['foo', 'bar'], '-task');
      expect(parser.parseSwitches('-task +foo+bar'), expected);
    });

    test('parse switches with text in the middle', () {
      Tuple2<List<String>, String> expected = Tuple2(['foo', 'bar'], '-task');
      expect(parser.parseSwitches('+foo-task+bar'), expected);
    });

    test('parse switches with text in the end', () {
      Tuple2<List<String>, String> expected = Tuple2(['foo', 'bar'], '-task');
      expect(parser.parseSwitches('+foo +bar -task'), expected);
    });
  });

  group('Switch negative tests => ', () {
    test('raise error if @', () {
      expect(() => parser.parseSwitches('@foo'), throwsFormatException);
    });

    test('raise error if label + value', () {
      expect(() => parser.parseSwitches('+foo:bar'), throwsFormatException);
    });

    test('raise error if task has repeated switches', () {
      expect(() => parser.parseSwitches('+foo +foo'), throwsFormatException);
    });
  });
}
