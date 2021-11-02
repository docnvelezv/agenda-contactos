import 'dart:io';

import 'package:app_contactos/home/model/contactsResponse.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ContactsProviderDb {
  Database? db;

  ContactsProviderDb();

  init() async {
    Directory applicationDirectory = await getApplicationDocumentsDirectory();
    var fullPath = join(applicationDirectory.path, "Contacts.db");
    this.db =
        await openDatabase(fullPath, onCreate: (Database newDb, int version) {
      return newDb.execute("""
          CREATE TABLE Contactos(
            _id TEXT,
            nombre TEXT,
            apellidos TEXT,
            email TEXT,
            telefono TEXT
          );
            """);
    }, version: 1);
  }

  agregarContactos() async {
    await this.db!.rawInsert("""
    INSERT INTO Contactos (_id, nombre, apellidos, email, telefono)
    VALUES (?,?,?,?,?)
    """, ['1', 'juan', 'perez', 'juanperez@hotmail.com', '300123123']);

    await this.db!.insert("Contactos", {
      "_id": "2",
      "nombre": "ana",
      "apellidos": "lopez",
      "email": "ana@gmail.com",
      "telefono": "23421236",
    });
  }

  eliminarContactos() async {
    await this.db!.delete("Contactos", where: "_id", whereArgs: ["1"]);
    await this.db!.rawDelete("""DELETE FROM Contactos WHERE _id = ?""", ["2"]);
  }

  Future<ContactsResponse> obtenerContactos() async {
    var results = await this.db!.rawQuery("SELECT* FROM Contactos");
    // var results = await this.db!.query("Contactos", where: "_id", whereArgs: ["1"] );

    ContactsResponse response = ContactsResponse.fromDB(results);

    return response;
  }
}
