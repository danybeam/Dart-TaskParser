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
