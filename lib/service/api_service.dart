import 'dart:convert';
import 'dart:typed_data';
import 'package:front_personne/model/personne.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost/personne-backend/api';

  // Get Personnes
  static Future<List<Personne>> getPersonnes() async {
    final rest = await http.get(Uri.parse('$baseUrl/get_personnes.php'));

    final List data = jsonDecode(rest.body);

    return data.map((e) => Personne.fromJson(e)).toList();
  }

  // Add personne
  static Future<void> addPersonne(
    String nom,
    String prenom,
    String age,
    Uint8List imageBite,
    String filename,
  ) async {

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/add_personne.php'),
    );

    request.fields.addAll({
      'nom': nom,
      'prenom': prenom,
      'age': age,
    });

    request.files.add(
      http.MultipartFile.fromBytes('photo', imageBite, filename: filename),
    );

    await request.send();
  }

  // Update personne
  static Future<void> updatePersonne(
    String id,
    String nom,
    String prenom,
    String age,
  ) async {
    await http.post(
      Uri.parse('$baseUrl/update_personne.php'),
      body: {
        'id': id,
        'nom': nom,
        'prenom': prenom,
        'age': age,
      },
    );
  }

  // Delete personne
  static Future<void> deletePersonne(String id) async {
    await http.post(
      Uri.parse('$baseUrl/delete_personne.php'),
      body: {'id': id},
    );
  }
}