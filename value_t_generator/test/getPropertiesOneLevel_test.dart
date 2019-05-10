import 'package:test/test.dart';
import 'package:value_t_generator/src/ElementForValueT.dart';
import 'package:value_t_generator/src/genValueT.dart';

void main() {
  group("getPropertiesOneLevel", () {
    void exp_getPropertiesOneLevel(
        List<Property> properties, List<Property> expected) {
      var result = getPropertiesOneLevel(properties);
      expect(result.toString(), expected.toString());
    }

    test("1", () {
      exp_getPropertiesOneLevel([
        Property("name", "String", hasSub: false),
        Property("pet", "Pet", hasSub: true, properties: [
          Property("type", "String", hasSub: false),
          Property("colour", "String", hasSub: false),
        ])
      ], [
        Property("name", "String", nameHierarchy: "name"),
        Property("pet", "Pet", nameHierarchy: "pet", properties: [
          Property("type", "String", nameHierarchy: "pet_type"),
          Property("colour", "String", nameHierarchy: "pet_colour")
        ]),
      ]);
    });

    test("2", () {
      exp_getPropertiesOneLevel([
        Property("name", "String", hasSub: false),
        Property("pet", "Pet", hasSub: true, properties: [
          Property("type", "String", hasSub: false),
          Property("colour", "String", hasSub: false),
          Property("collar", "Collar", hasSub: true, properties: [
            Property("id", "int", hasSub: false),
            Property("size", "String", hasSub: false),
          ])
        ]),
        Property("friend", "Friend", hasSub: true, properties: [
          Property("name", "String", hasSub: false),
          Property("height", "String", hasSub: false),
        ])
      ], [
        Property("name", "String", nameHierarchy: "name"),
        Property("pet", "Pet", nameHierarchy: "pet", properties: [
          Property("type", "String", nameHierarchy: "pet_type"),
          Property("colour", "String", nameHierarchy: "pet_colour"),
          Property("collar", "Collar", nameHierarchy: "pet_collar"),
          Property("collar_id", "int", nameHierarchy: "pet_collar_id"),
          Property("collar_size", "String", nameHierarchy: "pet_collar_size"),
        ]),
        Property("friend", "Friend", nameHierarchy: "friend", properties: [
          Property("name", "String", nameHierarchy: "friend_name"),
          Property("height", "String", nameHierarchy: "friend_height"),
        ])
      ]);
    });
  });
}