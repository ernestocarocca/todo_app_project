// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:todo_app_project/mobile_storage/shared_pref.dart';

class AddTodoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
  SharedPreferences prefs = SharedPreferencesManager.preferences;
  late TextEditingController textEditingController;
  List<String> getTodoList = [];
  late final String label;
  String todo = '';
  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();

    getTodoList = SharedPreferencesManager.getTodos() ??
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

  // void setTodoText() {}

  void cleartodos() {
    //SharedPreferences prefs = SharedPreferencesManager.preferences;
    prefs.setStringList('todos', []);
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
          const SizedBox(height: 32),
          buildName(),
          // buildTextField(),
          const SizedBox(height: 32),
          buildButtonSharePrev(),
        ],
      ),
    );
  }

// textfield that takes in a value and sets it for saving in Shpref uses BuildTitelWigget
  Widget buildName() => buildTitle(
        title: 'your Todos',
        child: TextFormField(
          initialValue: todo,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Your Name',
          ),
          onChanged: (todo) => setState(() => this.todo = todo),
        ),
      );

// Ernesto: add todos in a list
  Widget buildButtonSharePrev() => ButtonWidget(
      text: 'save',
      onClicked: () async {
        String inputTodoText = todo;
        if (inputTodoText.isNotEmpty) {
          getTodoList.add(inputTodoText);
          SharedPreferencesManager.setTodos(getTodoList);
          SharedPreferencesManager.getTodos();
          for (String todos in getTodoList) {
            print(todos);
          }
     
//gettime in future put it here
        }
      });

  Widget buildTitle({
    required String title,
    required Widget child,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          child,
        ],
      );
}

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    Key? key,
    required this.text,
    required this.onClicked,
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
