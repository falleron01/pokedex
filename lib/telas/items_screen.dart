import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projeto_pokemon/service/auth_service.dart';
import 'package:provider/provider.dart';
import '../providers/item_provider.dart';
import '../modelos/item.dart';

class TelaItems extends StatefulWidget {
  @override
  State<TelaItems> createState() => _TelaItemsState();
}

class _TelaItemsState extends State<TelaItems> {
  final Authservice authservice = Authservice();

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemProvider>(context);

    void adicionarItem(BuildContext ctx) {
      showDialog(
        context: ctx,
        builder: (ctx) {
          final nomeController = TextEditingController();
          final quantidadeController = TextEditingController();
          final gameController = TextEditingController();
          final idController = TextEditingController();

          return AlertDialog(
            title: Text('Adicionar Novo Item'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: nomeController,
                    decoration: InputDecoration(
                      labelText: 'Nome do Item',
                      filled: true,
                      fillColor: Colors.white, // Cor de fundo do campo de texto
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  TextField(
                    controller: quantidadeController,
                    decoration: InputDecoration(
                      labelText: 'Quantidade',
                      filled: true,
                      fillColor: Colors.white, // Cor de fundo do campo de texto
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: gameController,
                    decoration: InputDecoration(
                      labelText: 'Game', filled: true,
                      fillColor: Colors.white, // Cor de fundo do campo de texto
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  TextField(
                    controller: idController,
                    decoration: InputDecoration(
                      labelText: 'ID do Item', filled: true,
                      fillColor: Colors.white, // Cor de fundo do campo de texto
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  User? user = authservice.dataUser();

                  if (nomeController.text.isEmpty ||
                      quantidadeController.text.isEmpty ||
                      gameController.text.isEmpty ||
                      idController.text.isEmpty) {
                    return;
                  }

                  final newItem = Item(
                    idUser: user!.uid,
                    nome: nomeController.text,
                    quantidade: int.parse(quantidadeController.text),
                    game: gameController.text,
                    id: int.parse(idController.text),
                  );

                  itemProvider.addItem(newItem);
                  Navigator.of(ctx).pop();
                },
                child: Text('Adicionar'),
              ),
            ],
          );
        },
      );
    }

    void editarItem(BuildContext ctx, int index, Item item) {
      final nomeController = TextEditingController(text: item.nome);
      final quantidadeController =
          TextEditingController(text: item.quantidade.toString());
      final gameController = TextEditingController(text: item.game);

      showDialog(
        context: ctx,
        builder: (ctx) {
          return AlertDialog(
            title: Text('Editar Item'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: nomeController,
                    decoration: InputDecoration(labelText: 'Nome do Item'),
                  ),
                  TextField(
                    controller: quantidadeController,
                    decoration: InputDecoration(labelText: 'Quantidade'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: gameController,
                    decoration: InputDecoration(labelText: 'Game'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  User? user = authservice.dataUser();

                  if (nomeController.text.isEmpty ||
                      quantidadeController.text.isEmpty ||
                      gameController.text.isEmpty) {
                    return;
                  }

                  final updatedItem = Item(
                    idUser: user!.uid,
                    nome: nomeController.text,
                    quantidade: int.parse(quantidadeController.text),
                    game: gameController.text,
                    id: item.id, // Mantém o mesmo ID
                  );

                  itemProvider.updateItem(index, updatedItem);
                  Navigator.of(ctx).pop();
                },
                child: Text('Salvar'),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text('Itens Coletados', style: TextStyle(color: Colors.white)),
      ),
      body: itemProvider.items.isEmpty
          ? Center(
              child: Text(
                'Nenhum item adicionado ainda!',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            )
          : ListView.builder(
              itemCount: itemProvider.items.length,
              itemBuilder: (ctx, index) {
                final item = itemProvider.items[index];
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    leading: FutureBuilder<String?>(
                      future: itemProvider.fetchItemImage(item.id),
                      builder: (ctx, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        if (snapshot.hasError || snapshot.data == null) {
                          return Icon(Icons.error, color: Colors.lightBlue);
                        }
                        return Image.network(
                          snapshot.data!,
                          width: 50,
                          height: 50,
                          errorBuilder: (ctx, error, stackTrace) =>
                              Icon(Icons.error, color: Colors.lightBlue),
                        );
                      },
                    ),
                    title: Text(item.nome),
                    subtitle: Text(
                      'Game: ${item.game} - Quantidade: ${item.quantidade}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            editarItem(ctx, index, item);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.lightBlue),
                          onPressed: () {
                            itemProvider.deleteItem(index);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => adicionarItem(context),
        backgroundColor: Colors.lightBlue,
        child: Icon(Icons.add),
      ),
    );
  }
}
