import 'package:firebase_auth/firebase_auth.dart';

class Authservice {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> create(String username, String email, String password) async {
    try {
      print("$username $email $password");

      UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      user.user?.updateDisplayName(username);

      return null;
    } on FirebaseAuthException catch (error) {
      return _handlerFirebaseErrors(error);
    } catch (error) {
      return "Erro desconhecido: $error";
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  String _handlerFirebaseErrors(FirebaseAuthException error) {
    switch (error.code) {
      case 'email-already-in-use':
        return "O e-mail já está sendo usado por outra conta.";
      case 'weak-password':
        return "A senha é muito fraca. Escolha uma senha mais forte.";
      case 'invalid-email':
        return "O formato do e-mail é inválido.";
      case 'user-not-found':
        return "Nenhuma conta encontrada com este e-mail.";
      case 'wrong-password':
        return "A senha está incorreta.";
      default:
        return "Erro: ${error.message}";
    }
  }

  User? dataUser() {
    User? user = _auth.currentUser;

    return user;
  }
}
