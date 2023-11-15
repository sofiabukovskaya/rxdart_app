import 'dart:convert';
import 'dart:io';

import 'package:rxdart_app/models/animal.dart';
import 'package:rxdart_app/models/person.dart';
import 'package:rxdart_app/models/thing.dart';

typedef SearchTerm = String;

class Api {
  Api();
  List<Animal>? _animals;
  List<Person>? _persons;

  Future<List<Thing>> search(SearchTerm searchTerm) {
    final term = searchTerm.trim().toLowerCase();

    final cachedResult = _extractThingsUsingSearchTerm(term);
    if (cachedResult != null) {
      return cachedResult;
    }
  }

  List<Thing>? _extractThingsUsingSearchTerm(SearchTerm term) {
    final cachedAnimals = _animals;
    final cachedPersons = _persons;
    if (cachedAnimals != null && cachedPersons != null) {
      List<Thing> result = [];
      for (final animal in cachedAnimals) {
        if (animal.name.trimmedContains(term) ||
            animal.type.name.trimmedContains(term)) {
          result.add(animal);
        }
      }
      for (final person in cachedPersons) {
        if (person.name.trimmedContains(term) ||
            person.age.toString().trimmedContains(term)) {
          result.add(person);
        }
      }
      return result;
    } else {
      return null;
    }
  }

  Future<List<dynamic>> _getJson(String url) => HttpClient()
      .getUrl(
        Uri.parse(url),
      )
      .then(
        (req) => req.close(),
      )
      .then(
        (response) => response
            .transform(
              utf8.decoder,
            )
            .join(),
      )
      .then(
        (jsonString) => json.decode(jsonString) as List<dynamic>,
      );
}

extension TrimmedCaseInsensitiveContain on String {
  bool trimmedContains(String other) => trim().toLowerCase().contains(
        other.trim().toLowerCase(),
      );
}
