import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projeto_pokemon/service/auth_service.dart';
import 'package:provider/provider.dart';
import '../modelos/pokemon.dart';
import '../providers/pokemon_provider.dart';

class Pokedex extends StatefulWidget {
  @override
  State<Pokedex> createState() => _PokedexState();
}

class _PokedexState extends State<Pokedex> {
  final Authservice authservice = Authservice();

  @override
  Widget build(BuildContext context) {
    final pokemonProvider = Provider.of<PokemonProvider>(context);
    User? user = authservice.dataUser();

    pokemonProvider.fetchPokemons(user!.uid);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Pokédex', style: TextStyle(color: Colors.white)),
      ),
      body: ListView.builder(
        itemCount: pokemonProvider.pokemons.length,
        itemBuilder: (context, index) {
          final pokemon = pokemonProvider.pokemons[index];
          return ListTile(
            leading: Image.network(pokemon.imageUrl,
                height: 50, width: 50, fit: BoxFit.cover),
            title: Text(pokemon.name),
            subtitle: Text('Game: ${pokemon.game}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _showPokemonForm(
                      context, pokemonProvider, index, pokemon),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => pokemonProvider.deletePokemon(index),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPokemonForm(context, pokemonProvider),
        backgroundColor: Colors.red,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showPokemonForm(
    BuildContext context,
    PokemonProvider pokemonProvider, [
    int? index,
    Pokemon? existingPokemon,
  ]) {
    final TextEditingController nameController = TextEditingController(
      text: existingPokemon?.name ?? '',
    );
    final TextEditingController gameController = TextEditingController(
      text: existingPokemon?.game ?? '',
    );
    final TextEditingController idController = TextEditingController();

    String? imageUrl = existingPokemon?.imageUrl;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: Colors.redAccent[100],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
              existingPokemon == null ? 'Adicionar Pokémon' : 'Editar Pokémon'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  filled: true,
                  fillColor: Colors.white, // Cor de fundo do campo de texto
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              TextField(
                controller: gameController,
                decoration: InputDecoration(
                  labelText: 'Game',
                  filled: true,
                  fillColor: Colors.white, // Cor de fundo do campo de texto
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              TextField(
                controller: idController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'ID (Pokédex)',
                  filled: true,
                  fillColor: Colors.white, // Cor de fundo do campo de texto
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              if (imageUrl != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(imageUrl!, height: 100),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (idController.text.isNotEmpty) {
                    final id = int.parse(idController.text);
                    final fetchedImage =
                        await pokemonProvider.fetchPokemonImage(id);
                    if (fetchedImage != null) {
                      setState(() {
                        imageUrl = fetchedImage;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('Pokémon não encontrado ou sem imagem!')),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                child: Text('Buscar Imagem'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text;
                final game = gameController.text;
                final idText = idController.text;
                User? user = authservice.dataUser();

                if (name.isNotEmpty &&
                    game.isNotEmpty &&
                    idText.isNotEmpty &&
                    imageUrl != null) {
                  final id = int.parse(idText);
                  final pokemon = Pokemon(
                    idUser: user!.uid,
                    name: name,
                    game: game,
                    imageUrl: imageUrl!,
                    id: id,
                  );
                  if (existingPokemon == null) {
                    pokemonProvider.addPokemon(pokemon);
                  } else {
                    pokemonProvider.updatePokemon(index!, pokemon);
                  }
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Preencha todos os campos!')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
