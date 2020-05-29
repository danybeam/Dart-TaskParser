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

class Property {
  String label;
  String value;

  bool operator ==(covariant other) {
    return other.hashCode == this.hashCode;
  }

  @override
  int get hashCode => label.hashCode ^ value.hashCode;
}

class Task {
  String title;
  Property description;
  DateTime dueDate;
  List<Property> properties;
  List<String> switches;

  Task(title, {description, dueDate, properties, switches}) {
    this.title = title;
    this.description = description;
    this.dueDate = dueDate;
    this.properties = properties;
    this.switches = switches;
  }

  bool operator ==(covariant other) {
    return other.hashCode == this.hashCode;
  }

  int gethashcode() {
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
  int get hashCode => gethashcode();
}

void main(List<String> args) {
  print("object");
}

/// test for documentation
void foo() {}
