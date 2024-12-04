class Pokemon {
  final int id;
  String idUser;
  String name;
  String game;
  String imageUrl;

  Pokemon({
    required this.id,
    required this.idUser,
    required this.name,
    required this.game,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idUser': idUser,
      'name': name,
      'game': game,
      'imageUrl': imageUrl,
    };
  }

  factory Pokemon.fromMap(Map<String, dynamic> map) {
    return Pokemon(
      id: map['id'],
      idUser: map['idUser'],
      name: map['name'],
      game: map['game'],
      imageUrl: map['imageUrl'],
    );
  }
}
