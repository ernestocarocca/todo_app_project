import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_project/mobile_storage/shared_pref.dart';
import 'package:todo_app_project/pages/todomodel_page.dart';

class InProgressPage extends StatefulWidget {
  const InProgressPage({Key? key}) : super(key: key);

  @override
  _InProgressPageState createState() => _InProgressPageState();
}

class _InProgressPageState extends State<InProgressPage> {
  TodosManager todoManager = TodosManager();
  List<TodoItem> _savedTodoItemsInProgres = [];

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  @override
  Widget build(BuildContext context) {
 //   var inProgressModel = Provider.of<InProgressModel>(context);
/*
    // Sample data for testing
    var sampleDatas = [
      InProgressItem(title: 'titel', description: 'Description '),
      InProgressItem(title: 'titel', description: 'Description '),
      InProgressItem(title: 'titel', description: 'Description '),
    ]; */

    // Add sample data to the InProgressModel
  //  inProgressModel.addInProgressItems(sampleDatas);

    return Scaffold(
      appBar: AppBar(
        title: const Text('In Progress Page'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.orange,
              Color.fromARGB(255, 103, 62, 9)
            ], // Customize your gradient colors
          ),
        ),
        child: ListView.builder(
          itemCount: _savedTodoItemsInProgres.length,
          itemBuilder: (context, index) {
            var inProgressTodo = _savedTodoItemsInProgres[index];
            return Card(
              color: Colors.white70, // Customize your card color
              elevation: 5.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text(
                  inProgressTodo.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                subtitle: Text(
                  inProgressTodo.description,
                  style: const TextStyle(fontSize: 14.0),
                ),
                /*   onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => EditTodoPage(),
                    ),
                  );
                },*/
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _loadTodos() async {
    try {
      List<TodoItem> loadedTodos = await todoManager.getTodos();
      setState(() {
        _savedTodoItemsInProgres = loadedTodos;
      });
    } catch (e) {
      print('Error loading todos: $e');
    }
  }
}
