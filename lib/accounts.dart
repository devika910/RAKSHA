import 'package:flutter/material.dart';
import 'package:raksha/methods.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({super.key});

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      users = List.from(await getContacts());
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Emergency Contacts",
            style: TextStyle(fontSize: 28),
            textAlign: TextAlign.center,
          ),
          SizedBox(width: double.infinity),
          ...users.map((u) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                tileColor: Colors.lightGreenAccent,
                title: Text(u['name']),
                subtitle: Text(u['phone'], style: TextStyle(fontSize: 10)),
                trailing: IconButton(
                  onPressed: () async {
                    await deleteContactById(u['id']);
                    users = List.from(await getContacts());
                    setState(() {});
                  },
                  icon: Icon(Icons.delete),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
