import 'package:app_contactos/home/contactCard.dart';
import 'package:app_contactos/home/model/contactsResponse.dart';
import 'package:app_contactos/home/provider/contactsProvider.dart';
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

  List<Widget> listadoContactosWidgets = <Widget>[];

  @override
  Widget build(BuildContext context) {
    obtenerListadoContactos();

    return Scaffold(
        appBar: AppBar(
          title: Text("Listado de contactos"),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: this.listadoContactosWidgets,
          ),
        ));
  }

  void obtenerListadoContactos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = await prefs.getString('token');

    ContactsProvider cp = ContactsProvider();
    ContactsResponse cr = await cp.obtenerListadoContactos(token.toString());

    List<Widget> contactosCargados = <Widget>[];

    for (int i = 0; i < cr.contactList.length; i++) {
      Widget wd = ContactCard(
          cr.contactList[i].nombre + " " + cr.contactList[i].apellidos,
          cr.contactList[i].telefono,
          cr.contactList[i].email);

      contactosCargados.add(wd);
    }

    setState(() {
      this.listadoContactosWidgets = contactosCargados;
    });
  }
}
