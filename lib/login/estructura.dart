import 'package:app_contactos/home/estructura.dart';
import 'package:app_contactos/login/model/authResponse.dart';
import 'package:app_contactos/login/provider/authProvider.dart';
import 'package:app_contactos/register/estructura.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyLoginPage extends StatefulWidget {
  static String ruta = "/";

  @override
  State<StatefulWidget> createState() {
    return _MyLoginPageState();
  }
}

class _MyLoginPageState extends State<MyLoginPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String emailIngresado = "";
  String contrasenaIngresada = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Iniciar Sesión"),
        ),
        body: Container(
            child: Form(
          key: formKey,
          child: Column(
            children: [
              obtenerCampoEmail(),
              obtenerCampoContrasena(),
              obtenerBotonIniciarSesion(),
              Container(
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Text("¿Eres nuevo?"),
                    GestureDetector(
                        child: Text(
                          "Regístrate",
                          style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, MyRegisterPage.ruta);
                        })
                  ],
                ),
              )
            ],
          ),
        )));
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

  TextFormField obtenerCampoContrasena() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(labelText: "Contraseña"),
      validator: (value) {
        if (value!.length > 5) {
          return null;
        } else {
          return "La contraseña no cumple requisitos mínimos de seguridad";
        }
      },
      onSaved: (value) {
        contrasenaIngresada = value!;
      },
    );
  }

  ElevatedButton obtenerBotonIniciarSesion() {
    return ElevatedButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
            validarToken(emailIngresado, contrasenaIngresada);
          }
        },
        child: Text("Iniciar Sesión"));
  }

  void validarToken(String email, String contrasena) async {
    AuthProvider ap = AuthProvider();
    AuthResponse ar =
        await ap.obtenerToken(emailIngresado, contrasenaIngresada);

    if (ar.message != "Usuario autenticado") {
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', ar.token!);

      formKey.currentState!.reset();

      Navigator.pushNamed(context, MyContactsPage.ruta);
    }
  }
}
