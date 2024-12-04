import 'package:flutter/material.dart';
import '../modelos/item.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemProvider extends ChangeNotifier {
  final List<Item> _items = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Item> get items => _items;

  Future<void> addItem(Item item) async {
    try {
      print(item.idUser);

      final pokemonRef = FirebaseFirestore.instance
          .collection('items')
          .doc(item.id.toString());
      await pokemonRef.set({
        'idUser': item.idUser,
        'id': item.id,
        'nome': item.nome,
        'game': item.game,
        'quantidade': item.quantidade
      });
      _items.add(item);
      notifyListeners();
    } catch (error) {
      print('Erro ao salvar Pokémon');
    }
  }

  Future<void> updateItem(int index, Item item) async {
    try {
      _items[index] = item;
      notifyListeners();
      await _firestore
          .collection('items')
          .doc(item.id.toString())
          .update(item.toMap());
    } catch (e) {
      print('Erro ao atualizar Item no Firestore: $e');
    }
  }

  void deleteItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  Future<String?> fetchItemImage(int id) async {
    final url = Uri.parse('https://pokeapi.co/api/v2/item/$id');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['sprites']['default']; // URL da imagem
      }
    } catch (e) {
      print('Erro ao buscar Item: ');
    }
    return null;
  }
}
