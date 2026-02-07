import 'dart:convert';
import 'dart:typed_data';
import 'package:front_personne/models/personne.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:9000/api/personnes';

  // GET /personnes
  static Future<List<Personne>> getPersonnes() async {
    final resp = await http.get(Uri.parse(baseUrl));

    if (resp.statusCode == 200) {
      final json = jsonDecode(resp.body);
      return (json['data'] as List)
          .map((e) => Personne.fromJson(e))
          .toList();
    }

    throw Exception('Aucun backend disponible');
  }

  // POST /personnes
  static Future<void> addPersonne(
    String nom,
    String prenom,
    String age,
    Uint8List imageBytes,
    String filename,
  ) async {
    var request = http.MultipartRequest('POST', Uri.parse(baseUrl));
    request.fields.addAll({'nom': nom, 'prenom': prenom, 'age': age});
    request.files.add(http.MultipartFile.fromBytes('photo', imageBytes, filename: filename));

    final resp = await request.send();

    if (resp.statusCode != 200) {
      throw Exception('Aucun backend disponible pour créer une personne');
    }
  }

  // PUT /personnes/{id}
  static Future<void> updatePersonne(
    String id,
    String nom,
    String prenom,
    String age,
  ) async {
    final url = '$baseUrl/$id';
    final resp = await http.put(
      Uri.parse(url),
      body: jsonEncode({'nom': nom, 'prenom': prenom, 'age': int.parse(age), 'photo': null}),
      headers: {'Content-Type': 'application/json'},
    );

    if (resp.statusCode != 200) {
      throw Exception('Aucun backend disponible pour mettre à jour');
    }
  }

  // DELETE /personnes/{id}
  static Future<void> deletePersonne(String id) async {
    final url = '$baseUrl/$id';
    final resp = await http.delete(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

    if (resp.statusCode != 200) {
      throw Exception('Aucun backend disponible pour supprimer');
    }
  }
}
