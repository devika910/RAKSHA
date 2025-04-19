import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:raksha/accounts.dart';
import 'package:raksha/contact_list_page.dart';
import 'package:raksha/custom_contacts.dart';
import 'package:raksha/emergency_button.dart';
import 'package:raksha/methods.dart';
import 'package:sensors_plus/sensors_plus.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  StreamSubscription<AccelerometerEvent>? accelSub;
  bool crashDetected = false;
  bool isDialogVisible = false;
  int countdown = 10;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await listenToAccelerometer();
    });
  }

  Future<void> listenToAccelerometer() async {
    accelSub = accelerometerEventStream().listen((
      AccelerometerEvent event,
    ) async {
      double magnitude = math.sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z,
      );

      if (magnitude > 20) {
        await callEmergencyContact();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            GestureDetector(
              onTap: () async {
                await showModalBottomSheet(
                  enableDrag: true,
                  showDragHandle: true,
                  isScrollControlled: true,
                  context: context,
                  builder: (ctx) {
                    return AccountsPage();
                  },
                );
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.person),
              ),
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              var permissionGranted = await FlutterContacts.requestPermission(
                readonly: true,
              );

              if (!permissionGranted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Allow permissions for reading contacts to proceed",
                    ),
                  ),
                );
                return;
              }
              List<Contact> contacts = await FlutterContacts.getContacts(
                withProperties: true,
              );
              List<CustomContacts> contactList = [];

              for (var i = 0; i < contacts.length; i++) {
                contactList.add(
                  CustomContacts(contact: contacts[i], isSelected: false),
                );
              }

              await showModalBottomSheet(
                enableDrag: true,
                showDragHandle: true,
                isScrollControlled: true,
                context: context,
                builder: (ctx) {
                  return ContactListPage(contacts: contactList);
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Icon(Icons.person_add_alt_outlined),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Column(
              children: [
                Text("Need Help ?", style: TextStyle(fontSize: 52)),
                Text("Just hold the button to call"),
              ],
            ),
          ),
          Expanded(
            child: EmergencyButton3D(
              onPressed: () async {
                await callEmergencyContact();
              },
            ),
          ),
        ],
      ),
    );
  }
}
