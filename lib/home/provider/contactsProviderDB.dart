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

  agregarContacto(ContactModel cm) async {
    await this.db!.rawInsert("""
      INSERT INTO Contactos (_id, nombre, apellidos, email, telefono)
      VALUES (?,?,?,?,?)
      """, [cm.id, cm.nombre, cm.apellidos, cm.email, cm.telefono]);
  }

  eliminarContactos() async {
    await this.db!.rawDelete("""DELETE FROM Contactos""");
  }

  Future<ContactsResponse> obtenerContactos() async {
    var results = await this
        .db!
        .rawQuery("SELECT * FROM Contactos ORDER BY nombre, apellidos");
    // var results = await this.db!.query("Contactos", where: "_id", whereArgs: ["1"] );

    ContactsResponse response = ContactsResponse.fromDB(results);

    return response;
  }

  Future<ContactsResponse> obtenerContactosPorId(String id) async {
    var results =
        await this.db!.rawQuery("SELECT * FROM Contactos WHERE _id = ? ", [id]);
    ContactsResponse response = ContactsResponse.fromDB(results);
    return response;
  }
}
