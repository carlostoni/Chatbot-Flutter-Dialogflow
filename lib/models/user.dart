import 'package:flutter/material.dart';



class User {
  final String id;
  final String nome;
  final String idade;
  final String sexo;
  final String email;
  final String senha;
  final String cpf;
  final String avatarUrl;

  const User({
    this.id,
    @required this.nome,
    @required this.idade,
    @required this.sexo,
    @required this.email,
    @required this.senha,
    @required this.cpf,
    @required this.avatarUrl,
  });
}