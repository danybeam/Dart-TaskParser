import 'package:task_parser/task_parser.dart' as parser;
import 'package:test/test.dart';
import 'package:tuple/tuple.dart';

void main() {
  group('Property positive tests => ', () {
    test('parse 1 property alone', () {
      Tuple2<List<parser.Property>, String> expected =
          Tuple2([new parser.Property("foo", "bar")], '');
      expect(parser.parseProperties("@foo:bar"), expected);
    });

    test('parse 2 properties alone', () {
      Tuple2<List<parser.Property>, String> expected = Tuple2([
        new parser.Property("foo", "bar"),
        new parser.Property("foo1", "bar")
      ], '');
      expect(parser.parseProperties("@foo:bar @foo1:bar"), expected);
    });

    test('parse properties with text before', () {
      Tuple2<List<parser.Property>, String> expected = Tuple2([
        new parser.Property("foo", "baz"),
        new parser.Property("bar", "baz")
      ], '-task');
      expect(parser.parseSwitches('-task @foo:baz@bar:baz'), expected);
    });

    test('parse properties with text in the middle', () {
      Tuple2<List<parser.Property>, String> expected = Tuple2([
        new parser.Property("foo", "baz"),
        new parser.Property("bar", "baz")
      ], '-task');
      expect(parser.parseSwitches('@foo:baz-task@bar:baz'), expected);
    });

    test('parse properties with text in the end', () {
      Tuple2<List<parser.Property>, String> expected = Tuple2([
        new parser.Property("foo", "baz"),
        new parser.Property("bar", "baz")
      ], '-task');
      expect(parser.parseSwitches('@foo:baz @bar:baz -task'), expected);
    });
  });

  group('Property negative tests => ', () {
    test('raise exception if task has repeated property', () {
      expect(() => parser.parseProperties("@foo:bar @foo:baz"),
          throwsFormatException);
    });

    test('raise exception if property is not properly formated (prefix)', () {
      expect(() => parser.parseProperties("+foo:bar"), throwsFormatException);
    });

    test('raise exception if property is not properly formated (value)', () {
      expect(() => parser.parseProperties("@foo"), throwsFormatException);
    });
  });
}
