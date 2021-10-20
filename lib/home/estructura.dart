import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyContactsPage extends StatefulWidget {
  static String ruta = "/home";

  @override
  State<StatefulWidget> createState() {
    return _MyContactsPageState();
  }
}

class _MyContactsPageState extends State<MyContactsPage> {
  String miToken = "";

  @override
  Widget build(BuildContext context) {
    obtenerTokenSesion();

    return Scaffold(
        appBar: AppBar(
          title: Text("Listado de contactos"),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Text(
                'Pantalla de Visualización de contactos',
              ),
              Text(
                'Usuario Logueado = ' + miToken,
              ),
            ],
          ),
        ));
  }

  void obtenerTokenSesion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = await prefs.getString('token');
    print(token);

    setState(() {
      miToken = token!;
    });
  }
}
