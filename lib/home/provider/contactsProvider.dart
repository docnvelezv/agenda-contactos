import 'dart:convert';

import 'package:app_contactos/home/model/contactsResponse.dart';
import 'package:http/http.dart' as http;

class ContactsProvider {
  Future<ContactsResponse> obtenerListadoContactos(String token) async {
    var url = Uri.parse("http://10.0.2.2:8282/api/contacto/list");

    var responseHttp = await http.get(url, headers: {'Authorization': token});

    String rawResponse = utf8.decode(responseHttp.bodyBytes);

    var jsonResponse = jsonDecode(rawResponse);

    ContactsResponse contactsResponse = ContactsResponse(jsonResponse);

    return contactsResponse;
  }
}
