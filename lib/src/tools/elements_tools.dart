import 'package:tuple/tuple.dart';

import '../core/classes.dart';
import '../core/constants.dart';
import 'date_tools.dart';

Tuple2<states, String> insertTitle(ITask task, String prefix, String title) {
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

  task.state = state;
  task.title = title;

  return Tuple2(state, title);
}

DateTime insertDueDate(ITask task, String date) {
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

String insertSwitches(ITask task, String taskSwitch) {
  if (taskSwitch?.length == 0 ?? true)
    throw FormatException("Empty switch found in task");
  if (taskSwitch.contains(RegExp(r':')) ^ taskSwitch.contains(RegExp(r'\\:')))
    throw FormatException(
        'Attempted to parse {${taskSwitch}}. unescaped \':\' was found.');
  if (task.switches != null && task.switches.indexOf(taskSwitch) != -1) {
    throw FormatException(
        'Task {${task}} already contains switch {${taskSwitch}}');
  }
  if (task.switches == null) {
    task.switches = [taskSwitch];
  } else {
    task.switches.add(taskSwitch);
  }
  return taskSwitch;
}

Property insertProperties(ITask task, String label, String value) {
  if (label?.length == 0 ?? true) {
    throw FormatException("Property found with no label and value {${value}}");
  }
  if (value?.length == 0 ?? true) {
    throw FormatException("Property found with no label and value {${value}}");
  }
  var result = Property(label, value);
  if (task.properties != null && task.properties.indexOf(result) != -1) {
    throw FormatException(
        'Task {${task}} already contains property {${result}}');
  }
  if (task.properties == null) {
    task.properties = [result];
  } else {
    task.properties.add(result);
  }
  return result;
}

Property insertDescription(ITask task, String value) {
  if (task.description != null)
    throw FormatException("Task already contained a description");
  var result = Property('description', value);
  task.description = result;
  return result;
}
