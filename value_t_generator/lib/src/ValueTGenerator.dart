import 'dart:async';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:source_gen/source_gen.dart';
import 'package:value_t_annotation/value_t_annotation.dart';
import 'package:value_t_generator/src/ElementForValueT.dart';
import 'package:value_t_generator/src/extractGetterBody.dart';
import 'package:value_t_generator/src/genValueT.dart';

Future<CompilationUnit> getUnit(Element accessor) => accessor.session
        .getResolvedLibraryByElement(accessor.library)
        .then((resolvedLibrary) {
      var declaration = resolvedLibrary.getElementDeclaration(accessor);
      return declaration.resolvedUnit.unit;
    });

List<Property> createSubListProperties(List<ElementAnnotation> metadata,
    List<PropertyAccessorElement> accessors, List<Property> properties) {
  accessors.where((x) => x.isGetter).forEach((x) {
    if (x.returnType.element is ClassElement) {
      var element = x.returnType.element as ClassElement;

      if (metadata.length > 0 &&
          metadata.first.toSource().indexOf(x.name) > 0) {
        var accessorsForProperty = element.accessors.toList();
        // element.interfaces.forEach((x) {
        //   if (x.name != "Object") {
        //     accessorsForProperty.addAll(x.accessors);
        //   }
        // });
        element.allSupertypes.forEach((x) {
          if (x.name != "Object") {
            accessorsForProperty.addAll(x.accessors);
          }
        });

        properties.add(Property(
            x.name,
            x.returnType.toString().replaceFirst("\$", ""),
            true,
            createSubListProperties(
                element.metadata, accessorsForProperty, List<Property>())));
      } else {
        properties.add(Property(x.name,
            x.returnType.toString().replaceFirst("\$", ""), false, null));
      }
    }
  });

  return properties;
}

Future<List<ElementAccessor>> createAccessors(
    List<PropertyAccessorElement> accessors) async {
  var blah = accessors.where((x) => x.isGetter).map((x) async {
    var unit = await getUnit(x);

    return ElementAccessor(x.name, x.returnType.toString(),
        defaultValue:
            extractGetterBody(x.name, x.returnType.toString(), unit.toString()),
        extra: x.returnType.element is ClassElement
            ? "//" +
                ((x.returnType.element as ClassElement).metadata.length > 0
                    ? (x.returnType.element as ClassElement)
                        .metadata
                        .first
                        .toSource()
                    : "")

            // ?.firstWhere(
            //     (x) => x.toSource()?.contains("@ValueT") ?? false)
            // ?.toSource() ??
            // ""
            : "//${x.name} - NOT a");
  }).toList();

  return Future.wait(blah);
}

Future<ElementSuperType> createElementSuperType(
    ClassElement classElement) async {
  if (classElement.supertype.name == "Object") {
    return ElementSuperType(
        null,
        await createAccessors(classElement.accessors.toList()),
        await Future.wait(
          classElement.interfaces
              .map((x) async => await createInterface(x))
              .toList(),
        ),
        createSubListProperties(classElement.metadata,
            classElement.accessors.toList(), List<Property>()),
        null);
  }

  return ElementSuperType(
      await createElementSuperType(classElement.supertype.element),
      await createAccessors(classElement.accessors),
      await Future.wait(
        classElement.interfaces
            .map((x) async => await createInterface(x))
            .toList(),
      ),
      createSubListProperties(classElement.metadata,
          classElement.accessors.toList(), List<Property>()),
      classElement.supertype?.name ?? "");
}

Future<Interface> createInterface(InterfaceType interfaceType) async {
  if (interfaceType.superclass.name == "Object") {
    return Interface(
        null,
        await createAccessors(interfaceType.accessors.toList()),
        await Future.wait(
          interfaceType.interfaces
              .map((x) async => await createInterface(x))
              .toList(),
        ),
        [], //TODO:add properties here
        interfaceType.name);
  }

  return Interface(
      await createElementSuperType(interfaceType.superclass.element),
      await createAccessors(interfaceType.accessors.toList()),
      await Future.wait(
        interfaceType.interfaces
            .map((x) async => await createInterface(x))
            .toList(),
      ),
      [], //TODO:add properties here
      interfaceType.name);
}

class ValueTGenerator extends GeneratorForAnnotation<ValueT> {
  FutureOr<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) async {
    var sb = StringBuffer();
    if (element is ClassElement) {
      bool isAbstract = annotation.read('isAbstract')?.boolValue ?? false;
      sb.writeln(genValueT(isAbstract, await createElementSuperType(element),
          element.displayName));
    }

    return sb.toString();
  }
}
