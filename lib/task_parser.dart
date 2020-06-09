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

Parser startString = (char('-', '\'-\' was not found as start string') |
    string('[ ]', '\'-\' was not found as start string') |
    stringIgnoreCase('[x]', '\'[x]\' was not found as start string') |
    char('@', '\'@\' was not found as start string') |
    char('+', '\'+\' was not found as start string') |
    endOfInput('end of input was not found as start string'));

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

  // TODO implemnt to string
}

class Task {
  states state;
  String title;
  Property description;
  DateTime dueDate;
  List<Property> properties;
  List<String> switches;

  Task({state, title, description, dueDate, properties, switches}) {
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
    int hash = this.title?.hashCode ?? 1;
    hash ^= this.description?.hashCode ?? 1;
    hash ^= this.dueDate?.hashCode ?? 1;
    for (var item in this.properties) {
      hash ^= item?.hashCode ?? 1;
    }
    for (var item in this.switches) {
      hash ^= item?.hashCode ?? 1;
    }
    return hash;
  }

  bool hasTitle() {
    return (this.state != null ||
        (this.title != null && this.title.length != 0));
  }

  @override
  int get hashCode => _gethashcode();

  // TODO implement to string
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

List<String> generateSegments(String task) {
  var result = List<String>();
  String placeholder = task[0];

  for (var i = 1; i < task.length; i++) {
    switch (task[i]) {
      case r'\':
        placeholder += task[i++];
        placeholder += task[i];
        break;
      case r'@':
        result.add(placeholder);
        placeholder = '';
        placeholder += task[i];
        break;
      case r'+':
        result.add(placeholder);
        placeholder = '';
        placeholder += task[i];
        break;
      case r'-':
        if (task[i + 1].contains(RegExp(r'\d'))) {
          placeholder += task[i];
          break;
        }
        result.add(placeholder);
        placeholder = '';
        placeholder += task[i];
        break;
      default:
        placeholder += task[i];
    }
  }
  if (placeholder.length != 0) result.add(placeholder);
  return result;
}

Tuple2<states, String> parseTitle(Task task, String prefix, String title) {
  if (task.hasTitle())
    throw FormatException('Task {${task}} already has a title');
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

DateTime parseDueDate(Task task, String date) {
  if (task.dueDate != null) {
    throw FormatException(
        "Task {${task}} already contains the due date {${task.dueDate}}");
  }
  var segments = date.split(RegExp(r'(-|T|:)'));
  if (segments.any((element) => element.isEmpty) || segments.length != 5)
    throw FormatException("Missing information when parsing date {${date}}");
  if (!isValidDate(segments[0] + segments[1] + segments[2]))
    throw FormatException("Date {${date}} is not a valid date");
  List<int> numbers = [0, 0, 0, 0, 0];
  int numberPtr = 0;
  segments.forEach((e) => numbers[numberPtr++] = int.parse(e));
  var result =
      DateTime(numbers[0], numbers[1], numbers[2], numbers[3], numbers[4]);
  task.dueDate = result;
  return result;
}

String parseSwitches(Task task, String taskSwitch) {
  if (taskSwitch?.length == 0 ?? true)
    throw FormatException("Empty switch found in task");
  if (taskSwitch.contains(RegExp(r':')) ^ taskSwitch.contains(RegExp(r'\\:')))
    throw FormatException(
        'Attempted to parse {${taskSwitch}}. unescaped \':\' was found.');
  if (task.switches == null) {
    task.switches = [taskSwitch];
  } else {
    task.switches.add(taskSwitch);
  }
  return taskSwitch;
}

Property parseProperties(Task task, String label, String value) {
  if (label?.length == 0 ?? true) {
    throw FormatException("Property found with no label and value {${value}}");
  }
  if (value?.length == 0 ?? true) {
    throw FormatException("Property found with no label and value {${value}}");
  }
  var result = Property(label, value);
  if (task.properties == null) {
    task.properties = [result];
  } else {
    task.properties.add(result);
  }
  return result;
}

Task parseTask(String task) {
  var result = Task();
  var taskParser = ExpressionBuilder();
  // build task on primitives (input task to function and returning the property)
  // define primitives
  taskParser.group()
    ..primitive((digit().times(4) &
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
            digit().times(2))
        .flatten()) // 2020-02-01T12:34
    ..primitive(
        any().starLazy(char(r'\').not() & startString).flatten().trim());

  // Title parser
  taskParser.group()
    ..prefix((char(r'\').not() & char(r'-')).flatten(),
        (op, val) => parseTitle(result, op, val))
    ..prefix((char(r'\').not() & string('[ ]')).flatten(),
        (op, val) => parseTitle(result, op, val))
    ..prefix((char(r'\').not() & stringIgnoreCase('[x]')).flatten(),
        (op, val) => parseTitle(result, op, val));

  // Property parser
  taskParser.group()
    ..prefix(
        char(r'\').not() &
            char(r'@') &
            any().starLazy(char(r'\').not() & char(r':')).flatten() &
            char(r'\').not() &
            char(r':'),
        (op, val) => parseProperties(result, op[2], val));

  // Due date parser
  taskParser.group()
    ..prefix(
        char(r'\').not() &
            char(r'@') &
            stringIgnoreCase('due') &
            char(r' ').optional() &
            stringIgnoreCase('date') &
            char(r'\').not() &
            char(r':'),
        (op, val) => parseDueDate(result, val));

  // switch parser
  taskParser.group()
    ..prefix(
        char(r'\').not() & char(r'+'), (op, val) => parseSwitches(result, val));
  final parser = taskParser.build().end();

  var segments = generateSegments(task);
  for (var segment in segments) {
    parser.parse(segment);
  }

  return result;
}
