import 'dart:convert';

import 'package:app_contactos/home/model/contactsResponse.dart';
import 'package:http/http.dart' as http;

class ContactsProviderApi {
  Future<ContactsResponse> obtenerListadoContactos(String token) async {
    try {
      var url = Uri.parse("http://10.0.2.2:8282/api/contacto/list");

      var responseHttp = await http.get(url, headers: {'Authorization': token});

      String rawResponse = utf8.decode(responseHttp.bodyBytes);

      var jsonResponse = jsonDecode(rawResponse);

      ContactsResponse contactsResponse =
          ContactsResponse.fromAPI(jsonResponse);

      return contactsResponse;
    } catch (ex) {
      return ContactsResponse.vacio();
    }
  }

  Future<void> crearContacto(String token, ContactModel contact) async {
    try {
      var url = Uri.parse("http://10.0.2.2:8282/api/contacto/create");

      var responseHttp = await http.post(url, headers: {
        'Authorization': token
      }, body: {
        'nombre': contact.nombre,
        'apellidos': contact.apellidos,
        'telefono': contact.telefono,
        'email': contact.email
      });

      String rawResponse = utf8.decode(responseHttp.bodyBytes);
      print(rawResponse);
    } catch (ex) {}
  }
}
