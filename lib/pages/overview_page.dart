import 'package:flutter/material.dart';


class OverviewPage extends StatelessWidget {
  const OverviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Overview Page'),
      ),
      body: ListView(
        children: const [
          ListTile(
            title: Text('ToDo'),
          ),
          ListTile(
            title: Text('In Progress'),
          ),
          ListTile(
            title: Text('Done'),
          ),
        ],
      ),
    );
  }
}