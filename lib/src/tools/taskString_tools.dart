List<String> generateSegments(String task) {
  var result = List<String>();
  String placeholder = task[0];

  for (var i = 1; i < task.length; i++) {
    switch (task[i]) {
      case r'\':
        placeholder += task[i++];
        placeholder += task[i];
        break;
      case r'@':
        result.add(placeholder);
        placeholder = '';
        placeholder += task[i];
        break;
      case r'+':
        result.add(placeholder);
        placeholder = '';
        placeholder += task[i];
        break;
      case r'-':
        if (task[i + 1].contains(RegExp(r'\d'))) {
          placeholder += task[i];
          break;
        }
        result.add(placeholder);
        placeholder = '';
        placeholder += task[i];
        break;
      default:
        placeholder += task[i];
    }
  }
  if (placeholder.length != 0) result.add(placeholder);
  return result;
}
