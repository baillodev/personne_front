import 'package:flutter/material.dart';
import 'package:front_personne/models/personne.dart';
import 'package:front_personne/pages/add_person_page.dart';
import 'package:front_personne/pages/edit_personne_page.dart';
import 'package:front_personne/services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Personne>> person;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    person = ApiService.getPersonnes();
  }

  void refresh() {
    setState(() {
      person = ApiService.getPersonnes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Liste personnes"),
        backgroundColor: Colors.green,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddPersonPage()),
          );
        },
      ),
      body: FutureBuilder(
        future: person,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No data !"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, i) {
              final p = snapshot.data![i];

              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      "http://localhost/personne-backend/api/${p.photo}",
                    ),
                  ),
                  title: Text("${p.nom} ${p.prenom}"),
                  subtitle: Text("Age: ${p.age}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditPersonnePage(personne: p),
                            ),
                          );
                        },
                        icon: Icon(Icons.edit, color: Colors.orange),
                      ),
                      IconButton(
                        onPressed: () async {
                          await ApiService.deletePersonne(p.id);
                          refresh();
                        },
                        icon: Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
