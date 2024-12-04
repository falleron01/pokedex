import 'package:cloud_firestore/cloud_firestore.dart';
import '../modelos/pokemon.dart';
import '../modelos/item.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> savePokemon(String userId, Pokemon pokemon) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('pokemons')
        .doc(pokemon.id as String?)
        .set(pokemon.toMap());
  }

  Future<void> saveItem(String userId, Item item) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('items')
        .doc(item.id as String?)
        .set(item.toMap());
  }

  Future<List<Pokemon>> getPokemons(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('pokemons')
        .get();

    return snapshot.docs.map((doc) => Pokemon.fromMap(doc.data())).toList();
  }

  Future<List<Item>> getItems(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('items')
        .get();

    return snapshot.docs.map((doc) => Item.fromMap(doc.data())).toList();
  }
}
