import 'package:app_contactos/createcontact/estructura.dart';
import 'package:app_contactos/home/contactCard.dart';
import 'package:app_contactos/home/model/contactsResponse.dart';
import 'package:app_contactos/home/provider/contactsProviderAPI.dart';
import 'package:app_contactos/home/provider/contactsProviderDB.dart';
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
            child: ListView(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: this.listadoContactosWidgets,
          ),
        ])),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.pushNamed(context, CreateContactPage.ruta);
            },
            label: Text("Crear Contacto"),
            icon: Icon(Icons.add)));
  }

  void obtenerListadoContactos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = await prefs.getString('token');

    ContactsProviderApi cpapi = ContactsProviderApi();
    ContactsProviderDb cpdb = ContactsProviderDb();
    await cpdb.init();

    //// TODO: PENDIENTE HACER VALIDACIÓN CONECTIVIDAD
    ContactsResponse crapi =
        await cpapi.obtenerListadoContactos(token.toString());

    for (int i = 0; i < crapi.contactList.length; i++) {
      ContactsResponse temp =
          await cpdb.obtenerContactosPorId(crapi.contactList[i].id);
      if (temp.contactList.length == 0) {
        cpdb.agregarContacto(crapi.contactList[i]);
      }
    }

    ////

    ContactsResponse crbd = await cpdb.obtenerContactos();

    List<Widget> contactosCargados = <Widget>[];

    for (int i = 0; i < crbd.contactList.length; i++) {
      Widget wd = ContactCard(
          crbd.contactList[i].nombre + " " + crbd.contactList[i].apellidos,
          crbd.contactList[i].telefono,
          crbd.contactList[i].email);

      contactosCargados.add(wd);
    }

    setState(() {
      this.listadoContactosWidgets = contactosCargados;
    });
  }
}
