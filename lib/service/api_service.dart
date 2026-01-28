import 'dart:convert';
import 'dart:typed_data';
import 'package:front_personne/model/personne.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const backends = [
    'http://localhost/personne-backend/personnes', // PHP
    'http://localhost:8000/personnes', // FastAPI
    'http://localhost:8001/personnes', // Go
  ];
  
  // Méthode générique pour GET
  static Future<List<Personne>> getPersonnes() async {
    for (var baseUrl in backends) {
      try {
        final rest = await http.get(Uri.parse(baseUrl));
        if (rest.statusCode == 200) {
          final List data = jsonDecode(rest.body);
          return data.map((e) => Personne.fromJson(e)).toList();
        }
      } catch (_) {
        // fallback silencieux vers le backend suivant
        continue;
      }
    }
    throw Exception('Aucun backend disponible');
  }

  // POST / CREATE
  static Future<void> addPersonne(
    String nom,
    String prenom,
    String age,
    Uint8List imageBite,
    String filename,
  ) async {
    for (var baseUrl in backends) {
      try {
        var request = http.MultipartRequest('POST', Uri.parse(baseUrl));
        request.fields.addAll({'nom': nom, 'prenom': prenom, 'age': age});
        request.files.add(http.MultipartFile.fromBytes('photo', imageBite, filename: filename));
        final resp = await request.send();
        if (resp.statusCode == 200) return;
      } catch (_) {
        continue;
      }
    }
    throw Exception('Aucun backend disponible pour créer une personne');
  }

  // PUT / UPDATE
  static Future<void> updatePersonne(
    String id,
    String nom,
    String prenom,
    String age,
  ) async {
    for (var baseUrl in backends) {
      try {
        final resp = await http.put(
          Uri.parse('$baseUrl/$id'),
          body: jsonEncode({'nom': nom, 'prenom': prenom, 'age': int.parse(age), 'photo': null}),
          headers: {'Content-Type': 'application/json'},
        );
        if (resp.statusCode == 200) return;
      } catch (_) {
        continue;
      }
    }
    throw Exception('Aucun backend disponible pour mettre à jour');
  }

  // POST / DELETE
  static Future<void> deletePersonne(String id) async {
    for (var baseUrl in backends) {
      try {
        final resp = await http.post(
          Uri.parse('$baseUrl/delete'),
          body: jsonEncode({'id': int.parse(id)}),
          headers: {'Content-Type': 'application/json'},
        );
        if (resp.statusCode == 200) return;
      } catch (_) {
        continue;
      }
    }
    throw Exception('Aucun backend disponible pour supprimer');
  }
}