class Personne {
  final String id;
  final String nom;
  final String prenom;
  final String age;
  final String photo;

  Personne({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.age,
    required this.photo
  });

  factory Personne.fromJson(Map<String, dynamic> json) {
    return Personne(
      id: json['id'].toString(),
      nom: json['nom'],
      prenom: json['prenom'],
      age: json['age'].toString(),
      photo: json['photo'],
    );
  }
}