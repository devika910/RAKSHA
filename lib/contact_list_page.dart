import 'package:flutter/material.dart';
import 'package:raksha/custom_contacts.dart';
import 'package:raksha/methods.dart';

class ContactListPage extends StatefulWidget {
  const ContactListPage({super.key, required this.contacts});

  final List<CustomContacts> contacts;

  @override
  State<ContactListPage> createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  List<CustomContacts> searchResults = [];

  @override
  void initState() {
    searchResults = List.from(widget.contacts);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.8,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'contact name',
                prefixIcon: Icon(Icons.search_rounded),
                border: OutlineInputBorder(),
              ),
              onChanged: (text) {
                setState(() {
                  if (text.isEmpty) {
                    searchResults = List.from(widget.contacts);
                  } else {
                    searchResults =
                        widget.contacts.where((element) {
                          return element.contact.displayName
                              .toLowerCase()
                              .contains(text.toLowerCase());
                        }).toList();
                  }
                });
              },
            ),
          ),
          if (searchResults.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (ctx, index) {
                  return CheckboxListTile(
                    value: searchResults[index].isSelected,
                    title: Text(searchResults[index].contact.displayName),
                    onChanged: (value) {
                      setState(() {
                        searchResults[index].isSelected =
                            !searchResults[index].isSelected;
                      });
                    },
                  );
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  List<Map<String, dynamic>> users = List.from(
                    await getContacts(),
                  );

                  for (var element in searchResults) {
                    if (element.isSelected) {
                      try {
                        var alreadyThere = users.firstWhere((u) {
                          return u['phone'].toString() ==
                              element.contact.phones.first.number;
                        });

                        if (alreadyThere.isNotEmpty) {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Contact was added eralier"),
                            ),
                          );
                          return;
                        }
                      } catch (e) {}

                      await saveContact(
                        element.contact.displayName,
                        element.contact.phones.first.number,
                      );
                    }
                  }
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Updated emergency contacts..")),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.lightBlue),
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
