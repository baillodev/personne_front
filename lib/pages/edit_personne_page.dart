import 'package:flutter/material.dart';
import 'package:front_personne/models/personne.dart';
import 'package:front_personne/services/api_service.dart';

class EditPersonnePage extends StatefulWidget {
  final Personne personne;
  const EditPersonnePage({super.key, required this.personne});

  @override
  State<EditPersonnePage> createState() => _EditPersonnePageState();
}

class _EditPersonnePageState extends State<EditPersonnePage> {
  
  late TextEditingController nomCtl;
  late TextEditingController prenomCtl;
  late TextEditingController ageCtl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nomCtl = TextEditingController(text: widget.personne.nom);
    prenomCtl = TextEditingController(text: widget.personne.prenom);
    ageCtl = TextEditingController(text: widget.personne.age);
  }

  update() async {
    await ApiService.updatePersonne(widget.personne.id, nomCtl.text, prenomCtl.text, ageCtl.text);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Personne"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nomCtl,
              decoration: const InputDecoration(
                labelText: "Nom",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: prenomCtl,
              decoration: const InputDecoration(
                labelText: "Prénom",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: ageCtl,
              decoration: const InputDecoration(
                labelText: "Âge",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: update,
              child: const Text("Mettre à jour"),
            ),
          ],
        ),
      ),
    );
  }
}