import 'dart:math';
import 'package:flutter/material.dart';
import 'package:chatbot_app/data/dummy_users.dart';
import 'package:chatbot_app/models/user.dart';

import 'package:firebase_database/firebase_database.dart';


class Users with ChangeNotifier {
  final Map<String, User> _items = {...DUMMY_USERS};

  List<User> get all {
    return [..._items.values];
  }

  int get count {
    return _items.length;
  }

  void put(User user) {
    if (user == null) {
      return;
    }
    if (user.id != null &&
        user.id.trim().isNotEmpty &&
        _items.containsKey(user.id)) {
      _items.update(
        user.id,
        (_) => User(
          id: user.id,
          nome: user.nome,
          idade: user.idade,
          sexo: user.sexo,
          email: user.email,
          senha: user.senha,
        ),
      );
    } else {






      final id = Random().nextDouble().toString();
      _items.putIfAbsent(
        id,
        () => User(
          id: user.id,
          nome: user.nome,
          idade: user.idade,
          sexo: user.sexo,
          email: user.email,
          senha: user.senha,
        ),
      );
    }
    notifyListeners();
  }

  void remove(User user) {
    if (user != null && user.id != null) {
      _items.remove(user.id);
      notifyListeners();
    }
  }

  User byIndex(int i) {
    return _items.values.elementAt(i);
  }
}
