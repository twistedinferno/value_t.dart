import 'package:meta/meta.dart';

// @ValueT(true)
abstract class $Person {
  String get name;

  const $Person();
}

// @ValueT(true)
abstract class $Employee extends $Person {
  int get employeeId;
}

// @ValueT()
abstract class $WindowCleaner extends $Employee {
  String get windowMaxSize => "big";
}

// @ValueT()
abstract class $Manager extends $Person {
  String get bosses;
}

//*****generated code********//
abstract class Person extends $Person {
  String get name;

  const Person();

  Person copyWith({int name});
}

//if is abstract
//  add abstract
//  ; instead of body of copyWith
//  no constructor
//  no final

abstract class Employee extends Person {
  String get name;
  String get employeeId;

  const Employee();

  Employee copyWith({
    int name,
    String employeeId,
  });
}

class WindowCleaner extends Employee {
  final String name;
  final String employeeId;
  final String windowMaxSize;

  const WindowCleaner({
    @required this.name,
    @required this.employeeId,
    this.windowMaxSize = "big",
  });

  WindowCleaner copyWith({
    int name,
    String employeeId,
    String windowMaxSize,
  }) =>
      WindowCleaner(
        name: name == null ? this.name : name,
        employeeId: employeeId == null ? this.employeeId : employeeId,
        windowMaxSize:
            windowMaxSize == null ? this.windowMaxSize : windowMaxSize,
      );
}

main() {
  Person a = WindowCleaner(name: "Bob", employeeId: "window cleaner");
  a.copyWith(name: 7);

  if (a is Employee) {
    print('I am an employee');
    print(a.employeeId);
  }

  if (a is Person) {
    print('I am an employee');
    print(a.name);
  }
}
