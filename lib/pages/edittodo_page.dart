
import 'package:flutter/material.dart';

class EditToDo extends StatelessWidget {
  const EditToDo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit ToDo'),
      ),
      body: const Center(
        child: Text("Edit todos and show them"),
      ),
    );
  }
}