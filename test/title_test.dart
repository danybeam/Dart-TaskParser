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

import 'package:task_parser/src/tools/elements_tools.dart';
import 'package:test/test.dart';
import 'package:task_parser/task_parser.dart' as parser;
import 'package:tuple/tuple.dart';

void main() {
  group('Title positive tests => ', () {
    test('parse title only with dash', () {
      Tuple2<parser.states, String> expected =
          Tuple2(parser.states.dash, "foo");
      expect(insertTitle(parser.BasicTask(), "-", "foo"), expected);
    });

    test('parse title with space', () {
      Tuple2<parser.states, String> expected =
          Tuple2(parser.states.dash, "foo bar");
      expect(insertTitle(parser.BasicTask(), "-", "foo bar"), expected);
    });

    test('parse title only with box', () {
      Tuple2<parser.states, String> expected = Tuple2(parser.states.box, "foo");
      expect(insertTitle(parser.BasicTask(), "[ ]", "foo"), expected);
    });

    test('parse title only with checked box (lower case)', () {
      Tuple2<parser.states, String> expected =
          Tuple2(parser.states.checked_box, "foo");
      expect(insertTitle(parser.BasicTask(), "[x]", "foo"), expected);
    });

    test('parse title only with checked box (upper case)', () {
      Tuple2<parser.states, String> expected =
          Tuple2(parser.states.checked_box, "foo");
      expect(insertTitle(parser.BasicTask(), "[X]", "foo"), expected);
    });

    test('parse title with text after (escaped)', () {
      Tuple2<parser.states, String> expected =
          Tuple2(parser.states.dash, "foo+bar");
      expect(insertTitle(parser.BasicTask(), '-', r'foo\+bar'), expected);
    });

    test('parse title with text after and space', () {
      Tuple2<parser.states, String> expected =
          Tuple2(parser.states.dash, "foo +bar");
      expect(insertTitle(parser.BasicTask(), '-', r'foo \+bar'), expected);
    });
  });

  group('Title negative tests => ', () {
    test('Raise error if the title is malformed', () {
      expect(() => insertTitle(parser.BasicTask(), '-', "Task:foo"),
          throwsFormatException);
    });

    test('Raise error if no prefix', () {
      expect(() => insertTitle(parser.BasicTask(), '', "foo"),
          throwsFormatException);
    });
  });
}
