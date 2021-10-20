import 'dart:convert';

import 'package:app_contactos/login/model/authResponse.dart';
import 'package:http/http.dart' as http;

class AuthProvider {
  Future<AuthResponse> obtenerToken(String email, String password) async {
    var url = Uri.parse("http://10.0.2.2:8282/api/usuario/login");

    var responseHttp =
        await http.post(url, body: {'email': email, 'password': password});

    String rawResponse = utf8.decode(responseHttp.bodyBytes);

    var jsonResponse = jsonDecode(rawResponse);

    AuthResponse authResponse = AuthResponse(jsonResponse);

    return authResponse;
  }
}
