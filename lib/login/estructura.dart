import 'package:app_contactos/login/provider/authProvider.dart';
import 'package:flutter/material.dart';

class MyLoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyLoginPageState();
  }
}

class _MyLoginPageState extends State<MyLoginPage> {
  @override
  Widget build(BuildContext context) {
    AuthProvider ap = AuthProvider();
    ap.obtenerToken('davidr@hotmail.com', 'holamundo123.');

    return Scaffold(
        appBar: AppBar(
          title: Text("Iniciar Sesión"),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Text(
                'Hola',
              ),
            ],
          ),
        ));
  }
}
