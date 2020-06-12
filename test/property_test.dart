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

import 'package:task_parser/task_parser.dart' as parser;
import 'package:test/test.dart';

void main() {
  group('Property positive tests => ', () {
    test('parse 1 property alone', () {
      parser.Property expected = parser.Property("foo", "bar");
      expect(
          parser.parseProperties(parser.BasicTask(), "foo", "bar"), expected);
    });
  });

  group('Property negative tests => ', () {
    test('raise exception if property is not properly formated (prefix)', () {
      expect(() => parser.parseProperties(parser.BasicTask(), "", "bar"),
          throwsFormatException);
    });

    test('raise exception if property is not properly formated (value)', () {
      expect(() => parser.parseProperties(parser.BasicTask(), "foo", ""),
          throwsFormatException);
    });
  });
}
