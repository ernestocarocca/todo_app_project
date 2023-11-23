import 'package:flutter/material.dart';


class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _nameState();
}

class _nameState extends State<TodoPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('ToDo Page'),);
  }
}