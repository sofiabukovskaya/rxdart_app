import 'package:flutter/foundation.dart' show immutable;
import 'package:rxdart_app/models/thing.dart';

@immutable
class Person extends Thing {
  final int age;

  const Person({
    required String name,
    required this.age,
  }) : super(name: name);

  @override
  String toString() => 'Animal, name: $name, age: $age';

  Person.fromJson(Map<String, dynamic> json)
      : age = json['age'] as int,
        super(
          name: json['name'] as String,
        );
}
