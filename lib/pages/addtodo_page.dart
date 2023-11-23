// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'package:flutter/material.dart';

import 'package:todo_app_project/mobile_storage/shared_pref.dart';

class AddTodoPage extends StatelessWidget {
   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Addtodos'),
      ),
      body: Column(
        children: [
          TaskList(),
        ],
      ),
    );
  }
}

class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  List<String> getTodoList = [];
  late final String label;
  String name = '';
  @override
  void initState() {
    super.initState();

      getTodoList = SharedPreferencesManager.getTodos() ?? [];

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [buttonGetFromSherePref(getTodoList),
                createTextList(getTodoList)],
    );
  }
}
// Ernesto: add todos in a list
Widget buttonGetFromSherePref(List<String>getTodoList) => ButtonWidget(
text: 'save',
  onClicked: () async{ 
    await SharedPreferencesManager.setTodos(getTodoList);
    },


);


// Ernesto: Forlop that gets each string in a list
Widget createTextList(List<String> getNameList) {
  //List<String> textWidgets = [];
  String names = '';
  for (String todos in getNameList) {
    names = todos;
  }

  return ListTile(title: Text(names));
}


//Ernesto button class that is the bluprint for buttonGetFromSherePref
class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    Key? key,
    required this.onClicked,
    required this.text,
    
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size.fromHeight(52), backgroundColor: Colors.white,
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
