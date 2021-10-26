import 'dart:convert';

class ContactsResponse {
  List<ContactModel> contactList = <ContactModel>[];

  ContactsResponse(Map jsonContactsResponse) {
    for (int i = 0; i < jsonContactsResponse["contactList"].length; i++) {
      ContactModel cm = ContactModel(jsonContactsResponse["contactList"][i]);
      this.contactList.add(cm);
    }
  }
}

class ContactModel {
  String _id = "";
  String nombre = "";
  String apellidos = "";
  String email = "";
  String telefono = "";

  ContactModel(Map jsonContactsResponse) {
    this._id = jsonContactsResponse["_id"];
    this.nombre = jsonContactsResponse["nombre"];
    this.apellidos = jsonContactsResponse["apellidos"];
    this.email = jsonContactsResponse["email"];
    this.telefono = jsonContactsResponse["telefono"];
  }
}