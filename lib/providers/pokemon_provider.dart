import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../modelos/pokemon.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PokemonProvider extends ChangeNotifier {
  List<Pokemon> _pokemons = [];

  List<Pokemon> get pokemons => _pokemons;

  Future<void> addPokemon(Pokemon pokemon) async {
    try {
      final pokemonRef = FirebaseFirestore.instance
          .collection('pokemons')
          .doc(pokemon.id.toString());
      await pokemonRef.set({
        'idUser': pokemon.idUser,
        'name': pokemon.name,
        'game': pokemon.game,
        'imageUrl': pokemon.imageUrl,
        'id': pokemon.id,
      });
      _pokemons.add(pokemon);
      notifyListeners();
    } catch (error) {
      print('Erro ao salvar Pokémon');
    }
  }

  Future<void> fetchPokemons(String idUser) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('pokemons')
          .where('idUser', isEqualTo: idUser)
          .get();
      final List<Pokemon> loadedPokemons = [];
      for (var doc in snapshot.docs) {
        loadedPokemons.add(Pokemon(
          id: doc['id'],
          idUser: doc['idUser'],
          name: doc['name'],
          game: doc['game'],
          imageUrl: doc['imageUrl'],
        ));
      }
      _pokemons = loadedPokemons;
      notifyListeners();
    } catch (error) {
      print('Erro ao carregar Pokémon');
    }
  }

  Future<void> updatePokemon(int index, Pokemon updatePokemon) async {
    try {
      final pokemonRef = FirebaseFirestore.instance
          .collection('pokemons')
          .doc(updatePokemon.id.toString());
      await pokemonRef.update({
        'name': updatePokemon.name,
        'game': updatePokemon.game,
        'imageUrl': updatePokemon.imageUrl,
        'id': updatePokemon.id,
      });
      _pokemons[index] = updatePokemon;
      notifyListeners();
    } catch (error) {
      print('Erro ao atualizar Pokémon');
    }
  }

  Future<void> deletePokemon(int index) async {
    try {
      final pokemonId = _pokemons[index].id.toString();
      await FirebaseFirestore.instance
          .collection('pokemons')
          .doc(pokemonId)
          .delete();
      _pokemons.removeAt(index);
      notifyListeners();
    } catch (error) {
      print('Erro ao deletar Pokémon');
    }
  }

  Future<String?> fetchPokemonImage(int id) async {
    final url = Uri.parse('https://pokeapi.co/api/v2/pokemon/$id');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['sprites']['front_default']; // URL da imagem
      }
    } catch (e) {
      print('Erro ao buscar Pokémon: $e');
    }
    return null;
  }
}
