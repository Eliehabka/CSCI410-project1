import 'package:flutter/material.dart';

class User {
  final String _name;
  final String _email;
  final String _password;
  final int _age;
  final String _gender;

  User(this._name, this._email, this._password, this._age,this._gender);

  String get email => _email;
  String get password => _password;

}

List<User> Users = [
  User("Elie", "elie@gmail.com", "1234", 20, "Male")

];