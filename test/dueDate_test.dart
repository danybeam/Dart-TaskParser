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

import 'package:test/test.dart';
import 'package:task_parser/task_parser.dart' as parser;

void main() {
  group('Due Date positive tests => ', () {
    test('parse only due date no space', () {
      DateTime expected = new DateTime(2020, 02, 01, 12, 34);
      expect(parser.parseDueDate(parser.BasicTask(), "2020-02-01T12:34"),
          expected);
    });
  });

  group('Due Date negative tests => ', () {
    test('Raise error if the value is malformed (missing numbers)', () {
      expect(
          () =>
              parser.parseDueDate(parser.BasicTask(), "@DueDate:2020-01T12:34"),
          throwsFormatException);
    });

    test('Raise error if value is malformed (letters in the middle)', () {
      expect(() => parser.parseDueDate(parser.BasicTask(), "asdf-02-01T12:34"),
          throwsFormatException);
    });
  });
}
