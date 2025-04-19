import 'dart:convert';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

Future<void> saveContact(String name, String phone) async {
  final prefs = await SharedPreferences.getInstance();

  // Get existing data
  String? contactsJson = prefs.getString('contacts');
  List<dynamic> contactList =
      contactsJson != null ? jsonDecode(contactsJson) : [];

  // Create new contact with unique ID
  var uuid = Uuid();
  Map<String, String> newContact = {
    'id': uuid.v4(),
    'name': name,
    'phone': phone,
  };

  contactList.add(newContact);

  // Save updated list
  prefs.setString('contacts', jsonEncode(contactList));
}

Future<List<Map<String, dynamic>>> getContacts() async {
  final prefs = await SharedPreferences.getInstance();
  String? contactsJson = prefs.getString('contacts');

  if (contactsJson != null) {
    List<dynamic> decodedList = jsonDecode(contactsJson);
    return decodedList.map((e) => Map<String, dynamic>.from(e)).toList();
  }
  return [];
}

Future<void> deleteContactById(String id) async {
  final prefs = await SharedPreferences.getInstance();
  String? contactsJson = prefs.getString('contacts');

  if (contactsJson != null) {
    List<dynamic> contactList = jsonDecode(contactsJson);
    contactList.removeWhere((contact) => contact['id'] == id);
    prefs.setString('contacts', jsonEncode(contactList));
  }
}

Future<void> callEmergencyContact() async {
  List<Map<String, dynamic>> users = List.from(await getContacts());

  if (users.isEmpty) {
    return;
  }

  FlutterPhoneDirectCaller.callNumber(users.first['phone']);
}
