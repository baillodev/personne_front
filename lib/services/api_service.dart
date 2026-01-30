import 'dart:convert';
import 'dart:typed_data';
import 'package:front_personne/models/backend.dart';
import 'package:front_personne/models/personne.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static final backends = [
    // PHP
    Backend(
      getUrl: 'http://localhost/backend-personne/get_personnes.php',
      createUrl: 'http://localhost/backend-personne/add_personne.php',
      updateUrl: 'http://localhost/backend-personne/update_personne.php',
      deleteUrl: 'http://localhost/backend-personne/delete_personne.php',
    ),
    // FastAPI
    Backend(
      getUrl: 'http://localhost:8000/personnes',
      createUrl: 'http://localhost:8000/personnes',
      updateUrl: 'http://localhost:8000/personnes',
      deleteUrl: 'http://localhost:8000/personnes/delete',
    ),
    // Go
    Backend(
      getUrl: 'http://localhost:8001/personnes',
      createUrl: 'http://localhost:8001/personnes',
      updateUrl: 'http://localhost:8001/personnes',
      deleteUrl: 'http://localhost:8001/personnes/delete',
    ),
  ];

  // Méthode générique pour GET
  static Future<List<Personne>> getPersonnes() async {
    for (var backend in backends) {
      try {
        final rest = await http.get(Uri.parse(backend.getUrl));
        if (rest.statusCode == 200) {
          final data = jsonDecode(rest.body);
          return (data as List).map((e) => Personne.fromJson(e)).toList();
        }
      } catch (_) {
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
    for (var backend in backends) {
      try {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse(backend.createUrl),
        );
        request.fields.addAll({'nom': nom, 'prenom': prenom, 'age': age});
        request.files.add(
          http.MultipartFile.fromBytes('photo', imageBite, filename: filename),
        );
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
    for (var backend in backends) {
      try {
        final url = backend.updateUrl.contains('.php')
            ? backend
                  .updateUrl // PHP attend POST + form-data
            : '${backend.updateUrl}/$id'; // FastAPI/Go attend PUT /personnes/{id}

        if (backend.updateUrl.contains('.php')) {
          await http.post(
            Uri.parse(url),
            body: {'id': id, 'nom': nom, 'prenom': prenom, 'age': age},
          );
        } else {
          await http.put(
            Uri.parse(url),
            body: jsonEncode({
              'nom': nom,
              'prenom': prenom,
              'age': int.parse(age),
              'photo': null,
            }),
            headers: {'Content-Type': 'application/json'},
          );
        }
        return;
      } catch (_) {
        continue;
      }
    }
    throw Exception('Aucun backend disponible pour mettre à jour');
  }

  // POST / DELETE
  static Future<void> deletePersonne(String id) async {
    for (var backend in backends) {
      try {
        if (backend.deleteUrl.contains('.php')) {
          await http.post(Uri.parse(backend.deleteUrl), body: {'id': id});
        } else {
          await http.post(
            Uri.parse(backend.deleteUrl),
            body: jsonEncode({'id': int.parse(id)}),
            headers: {'Content-Type': 'application/json'},
          );
        }
        return;
      } catch (_) {
        continue;
      }
    }
    throw Exception('Aucun backend disponible pour supprimer');
  }
}
