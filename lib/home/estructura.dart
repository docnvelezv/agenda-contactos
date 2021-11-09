import 'dart:async';

import 'package:app_contactos/createcontact/estructura.dart';
import 'package:app_contactos/home/contactCard.dart';
import 'package:app_contactos/home/model/contactsResponse.dart';
import 'package:app_contactos/home/provider/contactsProviderAPI.dart';
import 'package:app_contactos/home/provider/contactsProviderDB.dart';
import 'package:app_contactos/login/estructura.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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
  Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  List<Widget> listadoContactosWidgets = <Widget>[];

  @override
  void initState() {
    super.initState();

    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        sincronizarContactosBackend();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    obtenerListadoContactos();

    return Scaffold(
        appBar: AppBar(
          title: Text("Listado de contactos"),
          automaticallyImplyLeading: false,
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 20),
                child: GestureDetector(
                  onTap: () {
                    cerrarSesion();
                  },
                  child: Icon(Icons.logout, size: 26),
                ))
          ],
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

    ConnectivityResult connectiivityResult =
        await _connectivity.checkConnectivity();

    if (connectiivityResult != ConnectivityResult.none) {
      ContactsResponse crapi =
          await cpapi.obtenerListadoContactos(token.toString());

      for (int i = 0; i < crapi.contactList.length; i++) {
        ContactsResponse temp =
            await cpdb.obtenerContactosPorId(crapi.contactList[i].id);
        if (temp.contactList.length == 0) {
          cpdb.agregarContacto(crapi.contactList[i]);
        }
      }
    }

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

  void cerrarSesion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.pushNamed(context, MyLoginPage.ruta);
  }

  void sincronizarContactosBackend() async {
    print("Se inicia la sincronizacion");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = await prefs.getString('token');

    ContactsProviderDb cpdb = ContactsProviderDb();
    await cpdb.init();

    ContactsResponse cr = await cpdb.obtenerContactosPendientesPorSincronizar();

    ContactsProviderApi cpapi = ContactsProviderApi();

    for (int i = 0; i < cr.contactList.length; i++) {
      await cpapi.crearContacto(token!, cr.contactList[i]);
    }

    await cpdb.eliminarContactosSincronizados();

    print("Se termina la sincronizacion");
  }
}
