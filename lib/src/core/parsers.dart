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
library task_parser.core.parsers;

import 'package:petitparser/petitparser.dart';

import 'classes.dart';
import 'constants.dart';
import '../tools/elements_tools.dart';
import '../tools/taskString_tools.dart';

ITask parseTask(String task) {
  var result = BasicTask();
  var taskParser = ExpressionBuilder();
  int segmentsLength;
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
    ..prefix((char(r'\').not() & char(r'-')).flatten(), (op, val) {
      segmentsLength--;
      return insertTitle(result, op, val.trim());
    })
    ..prefix((char(r'\').not() & string('[ ]')).flatten(), (op, val) {
      segmentsLength--;
      return insertTitle(result, op, val.trim());
    })
    ..prefix((char(r'\').not() & stringIgnoreCase('[x]')).flatten(), (op, val) {
      segmentsLength--;
      return insertTitle(result, op, val.trim());
    });

  // Property parser
  taskParser.group()
    ..prefix(
        char(r'\').not() &
            char(r'@') &
            any().starLazy(char(r'\').not() & char(r':')).flatten() &
            char(r'\').not() &
            char(r':'), (op, val) {
      segmentsLength--;
      return insertProperties(result, op[2], val.trim());
    });

  // Due date parser
  taskParser.group()
    ..prefix(
        char(r'\').not() &
            char(r'@') &
            stringIgnoreCase('due') &
            char(r' ').optional() &
            stringIgnoreCase('date') &
            char(r'\').not() &
            char(r':'), (op, val) {
      segmentsLength--;
      return insertDueDate(result, val.trim());
    });

  // Description parser
  taskParser.group()
    ..prefix(
        char(r'\').not() &
            char(r'@') &
            stringIgnoreCase('description') &
            char(r'\').not() &
            char(r':'), (op, val) {
      segmentsLength--;
      return insertDescription(result, val.trim());
    });

  // switch parser
  taskParser.group()
    ..prefix(char(r'\').not() & char(r'+'), (op, val) {
      segmentsLength--;
      return insertSwitches(result, val.trim());
    });
  final parser = taskParser.build().end();

  // TODO convert snippet into left associative apoeration that returns a task object
  var segments = generateSegments(task);
  segmentsLength = segments.length;
  for (var segment in segments) {
    parser.parse(segment);
  }

  if (segmentsLength != 0) {
    throw FormatException("error while parsing the task {${task}}");
  }

  return result;
}
