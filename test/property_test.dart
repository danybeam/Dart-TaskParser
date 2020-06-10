import 'package:task_parser/task_parser.dart' as parser;
import 'package:test/test.dart';
import 'package:tuple/tuple.dart';

void main() {
  group('Property positive tests => ', () {
    test('parse 1 property alone', () {
      parser.Property expected = parser.Property("foo", "bar");
      expect(parser.parseProperties(parser.Task(), "foo", "bar"), expected);
    });
  });

  group('Property negative tests => ', () {
    test('raise exception if property is not properly formated (prefix)', () {
      expect(() => parser.parseProperties(parser.Task(), "", "bar"),
          throwsFormatException);
    });

    test('raise exception if property is not properly formated (value)', () {
      expect(() => parser.parseProperties(parser.Task(), "foo", ""),
          throwsFormatException);
    });
  });
}
