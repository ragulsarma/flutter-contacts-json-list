import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';


class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {

  Iterable<Contact> _contacts;

  List<Map> lisJson = new List();

  @override
  void initState() {
    getContacts();
    super.initState();
  }

  Future<void> getContacts() async {
    //We already have permissions for contact when we get to this page, so we
    // are now just retrieving it
    final Iterable<Contact> contacts = await ContactsService.getContacts();
    setState(() {
      _contacts = contacts;
    });
    createJson();
  }


  createJson(){

    for(int index = 0; index < _contacts.length; index++){

      Contact contact = _contacts?.elementAt(index);
      List<Item> numbersList = contact.phones.toList();
      ContactName contactList = new ContactName();

      for(int i = 0; i < numbersList.length; i++ ){

        contactList.listChild.add(numbersList[i].value);

      }

      contactList.name = contact.displayName;

      lisJson.add(contactList.toJson());

    }

    var data = {
      "data" : lisJson
    };

    var body = json.encode(data);
    print("$body");

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (Text('Contacts')),
      ),
      body: _contacts != null
      //Build a list view of all contacts, displaying their avatar and
      // display name
          ? ListView.builder(
        itemCount: _contacts?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          Contact contact = _contacts?.elementAt(index);
          List phoneNumbersList = contact.phones.toList();

          return Padding(padding: EdgeInsets.all(26),child: Column(
            children: <Widget>[
            Text(contact.displayName ?? ''),
             ListView.builder(
               shrinkWrap: true,
                 itemCount: phoneNumbersList.length ?? 0,
                 itemBuilder: (BuildContext con, int index){
                   return Text(phoneNumbersList[index].value.toString());
              })
              ],)
          );
        }) : Center(child: const CircularProgressIndicator()),
    );
  }
}


class ContactName extends Object {

  String name;
  List<String> listChild = new List<String>();

  Map toJson() => {"name":name, "phone":listChild};
}
