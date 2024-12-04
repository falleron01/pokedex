class Item {
  final String nome;
  final String idUser;
  final int quantidade;
  final String game;
  final int id;

  Item({
    required this.nome,
    required this.idUser,
    required this.quantidade,
    required this.game,
    required this.id,
  });

  // Calcula a URL da imagem dinamicamente
  String get imageUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/$id.png';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idUser': idUser,
      'nome': nome,
      'game': game,
      'quantidade': quantidade,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      idUser: map['idUser'],
      nome: map['nome'],
      quantidade: map['quantidade'],
      game: map['game'],
    );
  }
}
