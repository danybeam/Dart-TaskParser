import 'package:test/test.dart';
import 'package:task_parser/task_parser.dart' as task;

void main() {
  test("first test", () {
    task.main([]);
    expect(true, true);
  });
}
