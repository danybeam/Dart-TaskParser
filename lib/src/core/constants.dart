library task_parser.core.constants;

import 'package:petitparser/petitparser.dart';

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
