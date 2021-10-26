import 'package:flutter/material.dart';

class ContactCard extends StatelessWidget {
  String contactName = "";
  String contactPhone = "";
  String contactEmail = "";

  ContactCard(this.contactName, this.contactPhone, this.contactEmail);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      children: [
        Text(this.contactName,
            style: TextStyle(
                color: Colors.black54,
                fontSize: 32.0,
                fontWeight: FontWeight.bold)),
        Text(this.contactPhone,
            style: TextStyle(
              color: Colors.black26,
              fontSize: 22.0,
            )),
        Text(this.contactEmail,
            style: TextStyle(
              color: Colors.black26,
              fontSize: 22.0,
            )),
      ],
    ));
  }
}
