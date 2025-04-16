import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("hello susan"),
        backgroundColor: const Color.fromARGB(255, 207, 251, 64),
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
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: CircleAvatar(
                backgroundColor: Colors.red,
                child: Icon(Icons.sos, color: Colors.white, size: 300),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
