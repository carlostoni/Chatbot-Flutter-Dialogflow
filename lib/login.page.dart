import 'package:chatbot_app/cadastro.dart';
import 'package:chatbot_app/views/home_page.dart';
import 'package:flutter/material.dart';

import 'authentication.dart';

class LoginPage extends StatelessWidget {
  TextEditingController emailInput = TextEditingController();
  TextEditingController passwordInput = TextEditingController();

  // var authHandler = new LoginService();
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // final Users users = Provider.of(context);

    return Scaffold(

      body: Container(
        padding: EdgeInsets.only(
          top: 60,
          left: 40,
          right: 40,
        ),
        color: Colors.white,
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              SizedBox(
                width: 128,
                height: 128,
                child: Image.asset("assets/logo.png"),
              ),
              SizedBox(
                height: 40,
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
                    fontSize: 20,
                  ),
                ),
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                // autofocus: true,
                keyboardType: TextInputType.text,
                obscureText: true,
                controller: passwordInput,
                decoration: InputDecoration(
                  labelText: "Senha",
                  labelStyle: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                ),
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 60,
              ),
              Container(
                height: 60,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.3, 2],
                    colors: [
                      Color(0xFFF408b45),
                      Color(0XFFF2f98c7),
                    ],
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                child: SizedBox.expand(
                  child: FlatButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Entrar",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    onPressed: () {
                      AuthenticationHelper()
                          .signIn(
                              email: emailInput.text,
                              password: passwordInput.text)
                          .then((result) {
                        if (result == null) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TextFieldAlertDialog ()));
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    content:
                                        Text(" E-mail ou Senha invalido "),
                                  ));
                        }
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 40,
                child: FlatButton(
                  child: Text(
                    "Cadastre-se",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Cadastro(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
