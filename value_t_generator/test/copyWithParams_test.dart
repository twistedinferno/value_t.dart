import 'package:test/test.dart';
import 'package:value_t_generator/src/ElementForValueT.dart';
import 'package:value_t_generator/src/genValueT.dart';

void main() {
  group("copyWithParams", () {
    void exp_copyWithParams(List<ElementAccessor> fields,
        List<Property> properties, String expected) {
      var result = copyWithParams(fields, properties);
      expect(result, expected);
    }

    test("1", () {
      exp_copyWithParams([
        ElementAccessor("id", "int"),
        ElementAccessor("name", "String")
      ], [
        Property("id", "int", false),
        Property("name", "String", false),
      ], """int id,
String name,
""");
    });

    test("2", () {
      exp_copyWithParams([
        ElementAccessor("name", "String"),
        ElementAccessor("pet", "Pet"),
      ], [
        Property("name", "String", false),
        Property("pet", "Pet", true, [
          Property("type", "String", false),
          Property("colour", "String", false),
        ]),
      ], """String name,
Pet pet,
String pet_type,
String pet_colour,
""");
    });

    test("3", () {
      exp_copyWithParams([
        ElementAccessor("name", "String"),
        ElementAccessor("pet", "Pet"),
      ], [
        Property("name", "String", false),
        Property("pet", "Pet", true, [
          Property("type", "String", false),
          Property("colour", "String", false),
          Property("collar", "Collar", true, [
            Property("id", "int", false),
            Property("size", "String", false),
          ]),
        ]),
      ], """String name,
Pet pet,
String pet_type,
String pet_colour,
Collar pet_collar,
int pet_collar_id,
String pet_collar_size,
""");
    });
  });
}