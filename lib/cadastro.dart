import 'package:chatbot_app/login.page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:chatbot_app/models/user.dart';

import 'authentication.dart';

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final databaseReference = FirebaseDatabase(
          databaseURL:
              'https://chat-firebase-b0622-default-rtdb.firebaseio.com/')
      .reference();

  TextEditingController nome = TextEditingController();
  TextEditingController idade = TextEditingController();
  TextEditingController sexo = TextEditingController();
  TextEditingController emailInput = TextEditingController();
  TextEditingController passwordInput = TextEditingController();
  TextEditingController cpf = TextEditingController();

  FirebaseDatabase database = new FirebaseDatabase();

  final _form = GlobalKey<FormState>();

  final Map<String, String> _formData = {};

  void _loadFormData(User user) {
    if (user != null) {
      _formData['id'] = user.id;
      _formData['nome'] = user.nome;
     _formData['idade'] = user.idade;
      _formData['sexo'] = user.sexo;
      _formData['email'] = user.email;
      _formData['senha'] = user.senha;
      _formData['cpf'] = user.cpf;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final User user = ModalRoute.of(context).settings.arguments;
    _loadFormData(user);
  }

  @override
  Widget build(BuildContext context) {
    final dailySpecialRef = databaseReference.child('/dailySpecial');

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(50),
        child: Form(
          key: _form,
          child: Column(
            children: <Widget>[
              SizedBox(
                width: 128,
                height: 128,
                child: Image.asset("assets/logo.png"),
              ),
              TextFormField(
                //autofocus: true,
                keyboardType: TextInputType.name,
                controller: nome,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: "Nome",
                  labelStyle: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                ),
                style: TextStyle(fontSize: 18),
              ),
              TextFormField(
                //autofocus: true,
                keyboardType: TextInputType.name,
                controller: cpf,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: "CPF",
                  labelStyle: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                ),
                style: TextStyle(fontSize: 18),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                controller: idade,
                decoration: InputDecoration(
                  labelText: "Idade",
                  labelStyle: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                ),
                style: TextStyle(fontSize: 18),
              ),
              TextFormField(
                // autofocus: true,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                controller: sexo,
                decoration: InputDecoration(
                  labelText: "Sexo",
                  labelStyle: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                ),
                style: TextStyle(fontSize: 18),
              ),
              TextFormField(
                // autofocus: true,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                controller: emailInput,
                decoration: InputDecoration(
                  labelText: "E-mail",
                  labelStyle: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                ),
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                //autofocus: true,
                keyboardType: TextInputType.text,
                obscureText: true,
                controller: passwordInput,
                decoration: InputDecoration(
                  labelText: "Senha",
                  labelStyle: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                ),
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              Color(0xFFF408b45),
                              Color(0XFFF2f98c7),
                            ],
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                        child: const Text('Salvar'),
                        style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(10.0),
                            primary: Colors.white,
                            textStyle: const TextStyle(fontSize: 20),
                            minimumSize: Size(500, 60)),
                        onPressed: () {
                          _doSingUp();
                          dailySpecialRef.child(cpf.text).set(
                            {
                              'Nome': nome.text,
                              'Idade': idade.text,
                              'Sexo': sexo.text,
                              'E-mail': emailInput.text,

                            },
                          );

                          Navigator.of(context).pop();
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _doSingUp() {
    if (_form.currentState.validate()) {
      AuthenticationHelper()
          .signUp(email: emailInput.text, password: passwordInput.text)
          .then((result) {
        if (result == null) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => LoginPage()));
        } else {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(

              result,
              style: TextStyle(fontSize: 16),
            ),
          ));
        }
      });
    } else {
      print("invalido");
    }
  }
}
