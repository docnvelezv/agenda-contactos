import 'package:app_contactos/home/model/contactsResponse.dart';
import 'package:app_contactos/home/provider/contactsProviderDB.dart';
import 'package:flutter/material.dart';

class CreateContactPage extends StatefulWidget {
  static String ruta = "/createcontact";

  @override
  State<StatefulWidget> createState() {
    return _CreateContactPage();
  }
}

class _CreateContactPage extends State<CreateContactPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String nombreIngresado = "";
  String apellidosIngresado = "";
  String telefonoIngresado = "";
  String emailIngresado = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Crear Contacto"),
        ),
        body: Container(
            child: Form(
          key: formKey,
          child: Column(
            children: [
              obtenerCampoNombre(),
              obtenerCampoApellidos(),
              obtenerCampoEmail(),
              obtenerCampoTelefono(),
              obtenerBotonCrearContacto()
            ],
          ),
        )));
  }

  TextFormField obtenerCampoNombre() {
    return TextFormField(
      keyboardType: TextInputType.name,
      decoration:
          InputDecoration(labelText: "Nombre del contacto", hintText: "Jhon"),
      validator: (value) {
        if (value!.length > 0) {
          return null;
        } else {
          return "El nombre de contacto no es válido";
        }
      },
      onSaved: (value) {
        nombreIngresado = value!;
      },
    );
  }

  TextFormField obtenerCampoApellidos() {
    return TextFormField(
      keyboardType: TextInputType.name,
      decoration:
          InputDecoration(labelText: "Apellidos del contacto", hintText: "Doe"),
      validator: (value) {
        if (value!.length > 0) {
          return null;
        } else {
          return "Los apellidos del contacto no son válidos";
        }
      },
      onSaved: (value) {
        apellidosIngresado = value!;
      },
    );
  }

  TextFormField obtenerCampoEmail() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          labelText: "Correo electrónico", hintText: "john.doe@mail.com"),
      validator: (value) {
        String patron = r'^[^@]+@[^@]+\.[^@]+$';
        RegExp regExp = new RegExp(patron);
        if (regExp.hasMatch(value!)) {
          return null;
        } else {
          return "El email no es válido";
        }
      },
      onSaved: (value) {
        emailIngresado = value!;
      },
    );
  }

  TextFormField obtenerCampoTelefono() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
          labelText: "Telefono del contacto", hintText: "300-000-0000"),
      validator: (value) {
        if (value!.length > 0) {
          return null;
        } else {
          return "El teléfono del contacto no es válido";
        }
      },
      onSaved: (value) {
        telefonoIngresado = value!;
      },
    );
  }

  ElevatedButton obtenerBotonCrearContacto() {
    return ElevatedButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
            crearContacto();
            Navigator.pop(context);
          }
        },
        child: Text("Crear Contacto"));
  }

  crearContacto() async {
    ContactModel cm = ContactModel.fromValues(
        nombreIngresado, apellidosIngresado, emailIngresado, telefonoIngresado);

    ContactsProviderDb cpdb = ContactsProviderDb();
    await cpdb.init();

    var nums = await cpdb.agregarContacto(cm);

    var result = await cpdb.obtenerContactos();
  }
}
