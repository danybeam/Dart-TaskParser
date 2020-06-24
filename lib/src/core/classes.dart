library task_parser.core.classes;

import 'constants.dart';

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
  int get hashCode => label.hashCode;

  @override
  String toString() {
    return '@' + label.toLowerCase() + ':' + value.toLowerCase();
  }
}

class ITask {
  states state;
  String title;
  Property description;
  DateTime dueDate;
  List<Property> properties;
  List<String> switches;

  // ignore: missing_return
  bool operator ==(covariant other) {}
  int get hashCode => 0;
  // ignore: unused_element, missing_return
  int _gethashcode() {}
  // ignore: missing_return
  bool hasTitle() {}
}

class BasicTask implements ITask {
  states state;
  String title;
  Property description;
  DateTime dueDate;
  List<Property> properties;
  List<String> switches;

  BasicTask({state, title, description, dueDate, properties, switches}) {
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
    int hash = this.title?.hashCode ?? 1;
    hash ^= this.description?.hashCode ?? 1;
    hash ^= this.dueDate?.hashCode ?? 1;
    if (this.properties != null && this.properties.length != 0) {
      for (var item in this.properties) {
        hash ^= item?.hashCode ?? 1;
      }
    } else {
      hash ^= 1;
    }
    if (this.switches != null && this.switches.length != 0) {
      for (var item in this.switches) {
        hash ^= item?.hashCode ?? 1;
      }
    } else {
      hash ^= 1;
    }
    return hash;
  }

  bool hasTitle() {
    return (this.state != null ||
        (this.title != null && this.title.length != 0));
  }

  @override
  int get hashCode => _gethashcode();

  @override
  String toString() {
    String result = '';
    if (this.state != null) {
      switch (this.state) {
        case states.dash:
          result += '-';
          break;
        case states.box:
          result += '[ ]';
          break;
        default:
          result += '[x]';
      }
    }

    if (this.title != null) {
      result += title;
    }

    if (this.description != null) {
      result += this.description.toString();
    }

    if (this.dueDate != null) {
      result += '@duedate:' +
          this
              .dueDate
              .toString()
              .replaceFirst(RegExp(r' '), 'T')
              .substring(0, 16);
    }

    if (this.properties != null && this.properties.length != 0) {
      for (var item in this.properties) {
        result += item.toString();
      }
    }
    if (this.switches != null && this.switches.length != 0) {
      for (var item in this.switches) {
        result += '+' + item.toString();
      }
    }
    return result;
  }
}
