import 'package:test/test.dart';
import 'package:task_parser/task_parser.dart' as parser;

void main() {
  group('Parse task positive tests => ', () {
    test('parse task with only title (dash)', () {
      parser.BasicTask expected = parser.BasicTask(parser.states.dash, "foo");
      expect(parser.parseTask("-foo"), expected);
    });

    test('parse task with only title (box)', () {
      parser.BasicTask expected = parser.BasicTask(parser.states.box, "foo");
      expect(parser.parseTask("[ ]foo"), expected);
    });

    test('parse task with only title (checked box)', () {
      parser.BasicTask expected =
          parser.BasicTask(parser.states.checked_box, "foo");
      expect(parser.parseTask("[x]foo"), expected);
    });

    test('parse task with everything', () {
      parser.BasicTask expected = parser.BasicTask(parser.states.dash, "foo",
          dueDate: DateTime(2020, 12, 31, 12, 34),
          description: "bar",
          properties: [parser.Property("baz", "buzz")],
          switches: ["fizz"]);

      expect(
          parser.parseTask(
              "-foo@dueDate:2020-12-31T12:34@Description:bar@baz:buzz+fizz"),
          expected);
    });
  });

  group('Parse task negative tests => ', () {
    test('raise error if anything goes wrong', () {
      expect(() => parser.parseTask("-foo:bar"), throwsFormatException);
    });

    test('badly formated due date label act as property', () {
      parser.BasicTask expected = parser.BasicTask(parser.states.dash, "foo",
          properties: [parser.Property("dueate", "2020-12-31T12:34")]);
      expect(parser.parseTask("-foo@dueate:2020-12-31T12:34"), expected);
    });
  });
}
