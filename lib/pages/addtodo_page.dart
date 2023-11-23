// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

import 'package:todo_app_project/mobile_storage/shared_pref.dart';

class AddTodoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: const Text('Addtodos'),
      ),
      body: TaskList(),
    );
  }
}

class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  late TextEditingController textEditingController;
  List<String> getTodoList = [];
  late final String label;
  String name = '';
  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    getTodoList = SharedPreferencesManager.getTodos(getTodoList) ??
        []; // Ernesto: init when page renders
  }

  Widget buildTextField() {
    return TextField(
      controller: textEditingController,
      decoration: const InputDecoration(
        hintText: 'Write something...',
        // Other decoration properties if needed
      ),
    );
  }

  void setTodoText() {}

  generateTodos() {
    for (String todos in getTodoList) {
      String todo = todos;
      return todo;
    }
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
        buildTextField(),
          buttonGetFromSherePref(getTodoList, textEditingController.text)
        ],
      ),
    );
  }
}

// Ernesto: add todos in a list
Widget buttonGetFromSherePref(
        List<String> getTodoList, String textEditingController) =>
    ButtonWidget(
      InputTodoText: textEditingController,
      text: 'save',
      onClicked: () async {
        getTodoList.add(textEditingController);
        await SharedPreferencesManager.setTodos(getTodoList);
        print(getTodoList[5]);
      },
    );

/*
// Ernesto: Forlop that gets each string in a list
Widget createTextList(String todo) {
  //List<String> textWidgets = [];
  String names = '';
  for (String todos in getTodoList) {
    names = todos;
  }

  return Text(names);
}
*/
//Ernesto button class that is the bluprint for buttonGetFromSherePref
class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;
  final String InputTodoText;
  const ButtonWidget({
    Key? key,
    required this.text,
    required this.onClicked,
    required this.InputTodoText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size.fromHeight(52),
            backgroundColor: Colors.black,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          onPressed: onClicked,
          child: Text(
            text,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      );
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
