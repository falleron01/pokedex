import 'package:flutter/material.dart';
import 'package:projeto_pokemon/providers/pokemon_service.dart';
import 'pokedex_screen.dart';
import 'items_screen.dart';
import 'settings_screen.dart';

class TelaHome extends StatefulWidget {
  @override
  _TelaHomeState createState() => _TelaHomeState();
}

class _TelaHomeState extends State<TelaHome> {
  late Future<Map<String, String>> _randomPokemon;

  @override
  void initState() {
    super.initState();
    _randomPokemon = PokemonService().fetchRandomPokemon();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Home', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TelaSettings()),
              );
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Texto de boas-vindas
          Text(
            'Bem-vindo ao gerenciador de Pokémon!',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),

          // Usando o FutureBuilder para exibir o Pokémon aleatório
          FutureBuilder<Map<String, String>>(
            future: _randomPokemon,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Mostra um indicador de carregamento
              } else if (snapshot.hasError) {
                return Text('Erro ao carregar Pokémon');
              } else if (snapshot.hasData) {
                final pokemon = snapshot.data!;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(pokemon['name']!, style: TextStyle(fontSize: 16)),
                    Image.network(pokemon['imageUrl']!,
                        height: 100, width: 100),
                  ],
                );
              } else {
                return Text('Nenhum Pokémon encontrado');
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        shape: CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.menu_book, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Pokedex()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.shopping_bag, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TelaItems()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
