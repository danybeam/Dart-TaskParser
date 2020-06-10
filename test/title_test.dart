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
      Tuple2<parser.states, String> expected =
          Tuple2(parser.states.dash, "foo");
      expect(parser.parseTitle(parser.Task(), "-", "foo"), expected);
    });

    test('parse title with space', () {
      Tuple2<parser.states, String> expected =
          Tuple2(parser.states.dash, "foo bar");
      expect(parser.parseTitle(parser.Task(), "-", "foo bar"), expected);
    });

    test('parse title only with box', () {
      Tuple2<parser.states, String> expected = Tuple2(parser.states.box, "foo");
      expect(parser.parseTitle(parser.Task(), "[ ]", "foo"), expected);
    });

    test('parse title only with checked box (lower case)', () {
      Tuple2<parser.states, String> expected =
          Tuple2(parser.states.checked_box, "foo");
      expect(parser.parseTitle(parser.Task(), "[x]", "foo"), expected);
    });

    test('parse title only with checked box (upper case)', () {
      Tuple2<parser.states, String> expected =
          Tuple2(parser.states.checked_box, "foo");
      expect(parser.parseTitle(parser.Task(), "[X]", "foo"), expected);
    });

    test('parse title with text after (escaped)', () {
      Tuple2<parser.states, String> expected =
          Tuple2(parser.states.dash, "foo+bar");
      expect(parser.parseTitle(parser.Task(), '-', r'foo\+bar'), expected);
    });

    test('parse title with text after and space', () {
      Tuple2<parser.states, String> expected =
          Tuple2(parser.states.dash, "foo +bar");
      expect(parser.parseTitle(parser.Task(), '-', r'foo \+bar'), expected);
    });
  });

  group('Title negative tests => ', () {
    test('Raise error if the title is malformed', () {
      expect(() => parser.parseTitle(parser.Task(), '-', "Task:foo"),
          throwsFormatException);
    });

    test('Raise error if no prefix', () {
      expect(() => parser.parseTitle(parser.Task(), '', "foo"),
          throwsFormatException);
    });
  });
}
