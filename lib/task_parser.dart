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

import 'package:tuple/tuple.dart';

class Property {
  String label;
  String value;

  Property(label, value) {
    this.label = label;
    this.value = value;
  }

  bool operator ==(covariant other) {
    return other.hashCode == this.hashCode;
  }

  @override
  int get hashCode => label.hashCode ^ value.hashCode;
}

enum states { dash, box, checked_box }

class ITask {
  states state;
  String title;
  Property description;
  DateTime dueDate;
  List<Property> properties;
  List<String> switches;

  bool operator ==(covariant other) {}
  int get hashCode => 0;
}

class BasicTask implements ITask {
  states state;
  String title;
  Property description;
  DateTime dueDate;
  List<Property> properties;
  List<String> switches;

  BasicTask(state, title, {description, dueDate, properties, switches}) {
    this.state = state;
    this.title = title;
    this.description = description;
    this.dueDate = dueDate;
    this.properties = properties;
    this.switches = switches;
  }

  bool operator ==(covariant other) {
    return other.hashCode == this.hashCode;
  }

  int _gethashcode() {
    int hash = this.title.hashCode;
    hash ^= this.description.hashCode;
    hash ^= this.dueDate.hashCode;
    for (var item in this.properties) {
      hash ^= item.hashCode;
    }
    for (var item in this.switches) {
      hash ^= item.hashCode;
    }
    return hash;
  }

  @override
  int get hashCode => _gethashcode();
}

Tuple3<states, String, String> parseTitle(String task) {
  throw UnimplementedError();
}

Tuple2<DateTime, String> parseDueDate(String task) {
  throw UnimplementedError();
}

Tuple2<List<String>, String> parseSwitches(String task) {
  throw UnimplementedError();
}

Tuple2<List<String>, String> parseProperties(String task) {
  throw UnimplementedError();
}

BasicTask parseTask(String task) {
  Tuple2<dynamic, String> result;

  states state;
  String title;
  Property description;
  DateTime dueDate;
  List<Property> properties;
  List<String> switches;

  Tuple3 titleParse = parseTitle(task);
  state = titleParse.item1;
  title = titleParse.item2;

  result = parseDueDate(titleParse.item3);
  dueDate = result.item1;

  result = parseProperties(result.item2);
  var descIndex =
      result.item1.indexWhere((e) => e.label.toLowerCase() == "description");
  description = descIndex != -1 ? result.item1.removeAt(descIndex) : null;
  properties = result.item1;

  result = parseSwitches(result.item2);
  switches = result.item1;

  return new BasicTask(state, title,
      description: description,
      dueDate: dueDate,
      properties: properties,
      switches: switches);
}
