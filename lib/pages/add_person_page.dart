import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';

class AddPersonPage extends StatefulWidget {
  const AddPersonPage({super.key});

  @override
  State<AddPersonPage> createState() => _AddPersonPageState();
}

class _AddPersonPageState extends State<AddPersonPage> {
  final nomCtrl = TextEditingController();
  final prenomCtrl = TextEditingController();
  final ageCtrl = TextEditingController();

  //Uint8List est une liste d'octets non signés, utilisée pour stocker des données binaires comme des images.
  Uint8List? imageBytes;
  String? imageName;

  Future pickImage() async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked == null) return;

    imageBytes = await picked.readAsBytes();
    imageName = picked.name;

    setState(() {});
  }

  Future save() async {
    if (imageBytes == null || imageName == null) return;

    await ApiService.addPersonne(
      nomCtrl.text,
      prenomCtrl.text,
      ageCtrl.text,
      imageBytes!,
      imageName!,
    );

    Navigator.pop(context);
  }

  Widget imagePreview() {
    if (imageBytes != null) {
      return Image.memory(imageBytes!, height: 120);
    }
    return const Text("Aucune image sélectionnée");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ajouter une personne")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nomCtrl,
              decoration: const InputDecoration(labelText: "Nom"),
            ),
            TextField(
              controller: prenomCtrl,
              decoration: const InputDecoration(labelText: "Prénom"),
            ),
            TextField(
              controller: ageCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Âge"),
            ),
            const SizedBox(height: 15),
            imagePreview(),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.photo),
              label: const Text("Choisir une photo"),
              onPressed: pickImage,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: save,
              child: const Text("Enregistrer"),
            ),
          ],
        ),
      ),
    );
  }
}
