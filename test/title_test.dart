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
import 'package:tuple/tuple.dart';

void main() {
  group('Title positive tests => ', () {
    test('parse title only with dash', () {
      Tuple3<parser.states, String, String> expected =
          Tuple3(parser.states.dash, "foo", "");
      expect(parser.parseTitle("-foo"), expected);
    });

    test('parse title with space', () {
      Tuple3<parser.states, String, String> expected =
          Tuple3(parser.states.dash, "foo bar", "");
      expect(parser.parseTitle("-foo bar"), expected);
    });

    test('parse title only with box', () {
      Tuple3<parser.states, String, String> expected =
          Tuple3(parser.states.box, "foo", "");
      expect(parser.parseTitle("[ ]foo"), expected);
    });

    test('parse title only with checked box (lower case)', () {
      Tuple3<parser.states, String, String> expected =
          Tuple3(parser.states.checked_box, "foo", "");
      expect(parser.parseTitle("[x]foo"), expected);
    });

    test('parse title only with checked box (upper case)', () {
      Tuple3<parser.states, String, String> expected =
          Tuple3(parser.states.checked_box, "foo", "");
      expect(parser.parseTitle("[X]foo"), expected);
    });

    test('parse title with text after no space', () {
      Tuple3<parser.states, String, String> expected =
          Tuple3(parser.states.dash, "foo", "+bar");
      expect(parser.parseTitle("-foo+bar"), expected);
    });

    test('parse title with text after and space', () {
      Tuple3<parser.states, String, String> expected =
          Tuple3(parser.states.dash, "foo", "+bar");
      expect(parser.parseTitle("-foo +bar"), expected);
    });

    test('parse title with text before no space', () {
      Tuple3<parser.states, String, String> expected =
          Tuple3(parser.states.dash, "foo", "+bar");
      expect(parser.parseTitle("+bar-foo"), expected);
    });

    test('parse title with text berfore and space', () {
      Tuple3<parser.states, String, String> expected =
          Tuple3(parser.states.dash, "foo", "+bar");
      expect(parser.parseTitle("+bar -foo"), expected);
    });
  });

  group('Title negative tests => ', () {
    test('Raise error if the title is malformed', () {
      expect(() => parser.parseTitle("-Task:foo"), throwsFormatException);
    });

    test('Raise error if there are 2 titles', () {
      expect(() => parser.parseTitle("-foo -bar"), throwsFormatException);
    });

    test('Raise error if no prefix', () {
      expect(() => parser.parseTitle("foo"), throwsFormatException);
    });
  });
}
