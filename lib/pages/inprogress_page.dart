import 'package:flutter/material.dart';
import 'package:todo_app_project/mobile_storage/shared_pref.dart';
import 'package:todo_app_project/pages/one_progress_page.dart';

class InProgressPage extends StatefulWidget {
  const InProgressPage({Key? key}) : super(key: key);

  @override
  InProgressPageState createState() => InProgressPageState();
}

class InProgressPageState extends State<InProgressPage> {
  TodosManager todoManager = TodosManager();
  List<TodoItem> _savedTodoItemsInProgres = [];

  @override
  void initState() {
    super.initState();
    loadTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('In Progress Page'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(  //background
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
              var inProgressTodoIndex = _savedTodoItemsInProgres[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => OnePrgressPage(
                        todoItem: inProgressTodoIndex,
                        // Skicka hela todoItem-objektet
                      ),
                    ),
                  );
                },
                child: Card(
                  color: Colors.white70, // Customize your card color
                  elevation: 5.0,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(
                      inProgressTodoIndex.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    subtitle: Text(
                      inProgressTodoIndex.title,
                      style: const TextStyle(fontSize: 14.0),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }

  void loadTodos() async {
    try {
      List<TodoItem> loadedTodos = await todoManager.getTodos();
      print(loadedTodos);
      List<TodoItem> todosToShow = [];
      setState(() {
        for (TodoItem todo in loadedTodos) {
          List<TodoTask> tasks = todo.todoList;
          List<bool> isDoneList = tasks.map((task) => task.isDone).toList();
          if (todo.isCrossed != true && isDoneList.contains(true)) {
            todosToShow.add(todo);
          }
        }
        setState(() {
          _savedTodoItemsInProgres = List.from(todosToShow);
          todosToShow.clear();
        });
      });
    } catch (e) {
      print('Error loading todos: $e');
    }
  }
}
