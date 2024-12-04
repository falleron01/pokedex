import 'package:flutter/material.dart';
import 'package:projeto_pokemon/service/auth_service.dart';
import 'package:projeto_pokemon/telas/settings_screen.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  final Authservice authservice = Authservice();

  newUser() async {
    if (_formKey.currentState!.validate()) {
      var username = emailController.text;
      var email = emailController.text;
      var password = passwordController.text;

      await authservice.create(username, email, password);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TelaSettings(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cadastrar")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email"),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: "Senha"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: newUser,
                child: Text("Cadastrar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
