/*
Dart implementation of the task spec sheet
Copyright (C) 2020  Daniel Gerardo Orozco Hernandez

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https: //www.gnu.org/licenses/>.

For any questions contact me at daoroz94@gmail.com
*/

import 'package:petitparser/petitparser.dart';
import 'package:tuple/tuple.dart';

enum states { dash, box, checked_box }

Map<String, states> prefToState = {
  '-': states.dash,
  '[ ]': states.box,
  '[x]': states.checked_box,
  '[X]': states.checked_box,
};

Parser startString = char('-') |
    string('[ ]') |
    string('[x]') |
    string('[X]') |
    char('@') |
    char('+') |
    endOfInput();

class Property {
  String label;
  String value;

  Property(label, value) {
    this.label = label;
    this.value = value;
  }

  bool operator ==(covariant other) {
    return other.hashCode == this.hashCode;
  }

  @override
  int get hashCode => label.hashCode ^ value.hashCode;
}

class Task {
  states state;
  String title;
  Property description;
  DateTime dueDate;
  List<Property> properties;
  List<String> switches;

  Task(state, title, {description, dueDate, properties, switches}) {
    this.state = state;
    this.title = title;
    this.description = description;
    this.dueDate = dueDate;
    this.properties = properties;
    this.switches = switches;
  }

  bool operator ==(covariant other) {
    return other.hashCode == this.hashCode;
  }

  int _gethashcode() {
    int hash = this.title.hashCode;
    hash ^= this.description.hashCode;
    hash ^= this.dueDate.hashCode;
    for (var item in this.properties) {
      hash ^= item.hashCode;
    }
    for (var item in this.switches) {
      hash ^= item.hashCode;
    }
    return hash;
  }

  @override
  int get hashCode => _gethashcode();
}

bool isValidDate(String input) {
  final date = DateTime.parse(input);
  final originalFormatString = toOriginalFormatString(date);
  return input == originalFormatString;
}

String toOriginalFormatString(DateTime dateTime) {
  final y = dateTime.year.toString().padLeft(4, '0');
  final m = dateTime.month.toString().padLeft(2, '0');
  final d = dateTime.day.toString().padLeft(2, '0');
  return "$y$m$d";
}

Tuple2<states, String> parseTitle(String prefix, String title) {
  var state = prefToState[prefix] ??
      FormatException(
          'Attempted to parse {${title}}. Prefix {${prefix}} is not a valid prefix.');
  if (state is FormatException) throw state;

  var hasColon = title.contains(RegExp(r':')) ^ title.contains(RegExp(r'\\:'));
  if (hasColon)
    throw FormatException(
        'Attempted to parse {${title}}. unescaped \':\' was found.');
  title = title.replaceAll(new RegExp(r'\\:'), '@');
  title = title.replaceAll(new RegExp(r'\\@'), '@');
  title = title.replaceAll(new RegExp(r'\\\+'), '+');
  title = title.replaceAll(new RegExp(r'\\-'), '-');
  title = title.replaceAll(new RegExp(r'\\\[ \]'), '[ ]');
  title = title.replaceAll(new RegExp(r'\\\[x\]', caseSensitive: false), '[x]');

  return Tuple2(state, title);
}

DateTime parseDueDate(String date) {
  var segments = date.split(RegExp(r'(-|T|:)'));
  if (segments.any((element) => element.isEmpty) || segments.length != 5)
    throw FormatException("Missing information when parsing date {${date}}");
  if (!isValidDate(segments[0] + segments[1] + segments[2]))
    throw FormatException("Date {${date}} is not a valid date");
  List<int> numbers = [0, 0, 0, 0, 0];
  int numberPtr = 0;
  segments.forEach((e) => numbers[numberPtr++] = int.parse(e));
  return DateTime(numbers[0], numbers[1], numbers[2], numbers[3], numbers[4]);
}

Tuple2<List<String>, String> parseSwitches(String task) {
  throw UnimplementedError();
}

Property parseProperties(String label, String value) {
  if (label?.length == 0 ?? true) {
    throw FormatException("Property found with no label and value {${value}}");
  }
  if (value?.length == 0 ?? true) {
    throw FormatException("Property found with no label and value {${value}}");
  }
  return Property(label, value);
}

Task parseTask(String task) {
  var taskParser = ExpressionBuilder();

  // define primitive
  taskParser.group()
    ..primitive(digit().times(4) &
        char(r'\').not() &
        char('-') &
        digit().times(2) &
        char(r'\').not() &
        char('-') &
        digit().times(2) &
        char('T') &
        digit().times(2) &
        char(r'\').not() &
        char(':') &
        digit().times(2)) // 2020-02-01T12:34
    ..primitive(
        any().starLazy(char(r'\').not() & startString).flatten().trim());

  // Title parser
  taskParser.group()
    ..prefix(char(r'\').not() & char('-'), (op, val) => parseTitle(op, val))
    ..prefix(char(r'\').not() & string('[ ]'), (op, val) => parseTitle(op, val))
    ..prefix(char(r'\').not() & stringIgnoreCase('[x]'),
        (op, val) => parseTitle(op, val));

  taskParser.group()
    ..prefix(
        char(r'\').not() &
            char('@') &
            stringIgnoreCase('due') &
            char(' ').optional() &
            stringIgnoreCase('date') &
            char(r'\').not() &
            char(':'),
        (op, val) => parseDueDate(val));

  taskParser.group()
    ..prefix(
        char(r'\').not() &
            char('@') &
            any().starLazy(char(r'\').not() & char(':')).flatten() &
            char(r'\').not() &
            char(':'),
        (op, val) => parseProperties(op[2], task));

  final parser = taskParser.build().end();

  var result = parser.parse(task);
  return null;
}
