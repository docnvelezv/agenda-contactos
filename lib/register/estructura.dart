import 'package:flutter/material.dart';

class MyRegisterPage extends StatefulWidget {
  static String ruta = "/register";

  @override
  State<StatefulWidget> createState() {
    return _MyRegisterPageState();
  }
}

class _MyRegisterPageState extends State<MyRegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Registrarse"),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Text(
                'Pantalla de Registro',
              ),
            ],
          ),
        ));
  }
}
