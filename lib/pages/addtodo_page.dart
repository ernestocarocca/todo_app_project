import 'package:flutter/material.dart';
import 'package:todo_app_project/mobile_storage/shared_pref.dart';

class AddTodoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Addtodos'),
      ),
      body: Column(
        children: [
          TaskList(),
        ],
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  TaskList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TaskItem(label: "1"),
     
      ],
    );
  }
}

class TaskItem extends StatelessWidget {
  final List<String>? getNameList = SharedPreferencesManager.getTodos();
  final String label;

  TaskItem({
    Key? key,
    required this.label,
  }) : super(key: key);

  void addString() async {
    Future add = SharedPreferencesManager.setTodos(getNameList!);

    print(add);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
      
        Text(label),
        FloatingActionButton(onPressed: addString),
      ],
    );
  }
}




/*




class AddTodoPage extends StatelessWidget {
  const AddTodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Add ToDo Page'),);
  }
}
*/