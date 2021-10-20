import 'package:app_contactos/home/estructura.dart';
import 'package:app_contactos/login/estructura.dart';
import 'package:app_contactos/register/estructura.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(routes: {
    MyLoginPage.ruta: (BuildContext context) => MyLoginPage(),
    MyRegisterPage.ruta: (BuildContext context) => MyRegisterPage(),
    MyContactsPage.ruta: (BuildContext context) => MyContactsPage(),
  }));
}
