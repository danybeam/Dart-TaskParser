bool isValidDate(String input) {
  final date = DateTime.parse(input);
  final originalFormatString = toOriginalFormatString(date);
  return input == originalFormatString;
}

String toOriginalFormatString(DateTime dateTime) {
  final y = dateTime.year.toString().padLeft(4, '0');
  final m = dateTime.month.toString().padLeft(2, '0');
  final d = dateTime.day.toString().padLeft(2, '0');
  return "$y$m$d";
}
