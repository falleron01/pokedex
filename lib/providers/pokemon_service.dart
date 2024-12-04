import 'dart:convert';
import 'package:http/http.dart' as http;

class PokemonService {
  Future<Map<String, String>> fetchRandomPokemon() async {
    // Gerar um número aleatório entre 1 e 898 (tamanho da Pokédex)
    final randomId = (1 +
        (1025 * (new DateTime.now().millisecondsSinceEpoch / 1000 % 1))
            .floor());
    final response = await http
        .get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$randomId'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final name = data['name'];
      final imageUrl = data['sprites']['front_default'];

      return {'name': name, 'imageUrl': imageUrl};
    } else {
      throw Exception('Falha ao carregar Pokémon aleatório');
    }
  }
}
