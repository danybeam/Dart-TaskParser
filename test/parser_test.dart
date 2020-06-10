import 'package:test/test.dart';
import 'package:task_parser/task_parser.dart' as parser;

void main() {
  group('Parse task positive tests => ', () {
    test('parse task with everything', () {
      parser.Task expected = parser.Task(
          state: parser.states.dash,
          title: "foo",
          dueDate: DateTime(2020, 12, 31, 12, 34),
          description: parser.Property("description", "bar"),
          properties: [parser.Property("baz", "buzz")],
          switches: ["fizz"]);

      expect(
          parser.parseTask(
              "-foo@Description:bar@dueDate:2020-12-31T12:34@baz:buzz+fizz"),
          expected);
    });
    test('parse task with only title (dash)', () {
      parser.Task expected =
          parser.Task(state: parser.states.dash, title: "foo");
      expect(parser.parseTask("-foo"), expected);
    });

    test('parse task with only title (box)', () {
      parser.Task expected =
          parser.Task(state: parser.states.box, title: "foo");
      expect(parser.parseTask("[ ]foo"), expected);
    });

    test('parse task with only title (checked box)', () {
      parser.Task expected =
          parser.Task(state: parser.states.checked_box, title: "foo");
      expect(parser.parseTask("[x]foo"), expected);
    });

    test('parse properties with text before', () {
      parser.Task expected = parser.Task(properties: [
        new parser.Property("foo", "baz"),
        new parser.Property("bar", "baz")
      ], state: parser.states.dash, title: 'task');
      expect(parser.parseTask('-task @foo:baz @bar:baz'), expected);
    });

    test('parse properties with text in the middle', () {
      parser.Task expected = parser.Task(properties: [
        new parser.Property("foo", "baz"),
        new parser.Property("bar", "baz")
      ], state: parser.states.dash, title: 'task');
      expect(parser.parseTask('@foo:baz-task@bar:baz'), expected);
    });

    test('parse properties with text in the end', () {
      parser.Task expected = parser.Task(properties: [
        new parser.Property("foo", "baz"),
        new parser.Property("bar", "baz")
      ], state: parser.states.dash, title: 'task');
      expect(parser.parseTask('@foo:baz @bar:baz -task'), expected);
    });

    test('parse 1 property alone', () {
      parser.Task expected =
          new parser.Task(properties: [parser.Property("foo", "bar")]);
      expect(parser.parseTask("@foo:bar"), expected);
    });

    test('parse switches with text before', () {
      parser.Task expected = parser.Task(
          switches: ['foo', 'bar'], state: parser.states.dash, title: 'task');
      expect(parser.parseTask('-task +foo+bar'), expected);
    });

    test('parse switches with text in the middle', () {
      parser.Task expected = parser.Task(
          switches: ['foo', 'bar'], title: 'task', state: parser.states.dash);
      expect(parser.parseTask('+foo-task+bar'), expected);
    });

    test('parse switches with text in the end', () {
      parser.Task expected = parser.Task(
          switches: ['foo', 'bar'], title: 'task', state: parser.states.dash);
      expect(parser.parseTask('+foo +bar -task'), expected);
    });
    test('parse 2 switches', () {
      parser.Task expected = parser.Task(switches: ['foo', 'bar']);
      expect(parser.parseTask('+foo +bar'), expected);
    });
  });

  group('Parse task negative tests => ', () {
    test('raise error if anything goes wrong', () {
      expect(() => parser.parseTask("-foo:bar"), throwsFormatException);
    });

    test('Raise error if there are 2 titles', () {
      expect(() => parser.parseTask("-foo -bar"), throwsFormatException);
    });
    test('Raise error if the value is malformed (missing value)', () {
      expect(() => parser.parseDueDate(parser.Task(), "@DueDate"),
          throwsFormatException);
    });
    test('badly formated due date label act as property', () {
      parser.Task expected = parser.Task(
          state: parser.states.dash,
          title: "foo",
          properties: [parser.Property("dueate", "2020-12-31T12:34")]);
      expect(parser.parseTask("-foo@dueate:2020-12-31T12:34"), expected);
    });
    test('raise exception if property is not properly formated (prefix)', () {
      expect(() => parser.parseTask("+foo:bar"), throwsFormatException);
    });

    test('raise exception if property is not properly formated (value)', () {
      expect(() => parser.parseTask("-test @foo"), throwsFormatException);
    });
    test('parse 2 properties alone', () {
      expect(
          parser.parseTask("-test @foo:bar @foo1:bar"), throwsFormatException);
    });
    test('raise exception if task has repeated property', () {
      expect(() => parser.parseTask("-test @foo:bar @foo:baz"),
          throwsFormatException);
    });
    test('raise error if task has repeated switches', () {
      expect(() => parser.parseTask('+foo +foo'), throwsFormatException);
    });
  });
}
