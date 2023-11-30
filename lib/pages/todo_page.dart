import 'package:flutter/material.dart';
import 'package:todo_app_project/mobile_storage/shared_pref.dart';
import 'package:todo_app_project/pages/addtodo_page.dart';
import 'package:todo_app_project/pages/one_todo.dart';

class ToDoPage extends StatefulWidget {
  const ToDoPage({Key? key}) : super(key: key);

  @override
  ToDoPageState createState() => ToDoPageState();
}

class ToDoPageState extends State<ToDoPage> {
  TodosManager todoManager = TodosManager();
  List<TodoItem> _savedTodoItems = [];

  @override
  void initState() {
    super.initState();
    loadTodos(); // Ernesto: Load tasks from SharedPreferences when the page initializes.
    print('loaded in init');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo Page'),
        centerTitle: true,
         actions: [
          Container(
            padding: const EdgeInsets.only(right: 16.0),
          child: IconButton(
            icon: const Icon(Icons.post_add,
            size: 38,
            color: Colors.blue,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const AddTodoPage(),
                ),
              );
            },
          ),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue, Color.fromARGB(255, 22, 9, 80)],
          ),
        ),
        child: ListView.builder(
          itemCount: _savedTodoItems.length,
          itemBuilder: (context, index) {
            TodoItem todoOnThisIdex = _savedTodoItems[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => ToDoDetailsPage(
                      todoItem: todoOnThisIdex, // Skicka hela todoItem-objektet
                    ),
                  ),
                );
              },
              child: Card(
                child: ListTile(
                  title: Text(todoOnThisIdex.title),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void loadTodos() async {
    try {
      List<TodoItem> loadedTodos = await todoManager.getTodos();
      setState(() {
        _savedTodoItems = loadedTodos;
        print(_savedTodoItems.length);
        debugPrint('load $_savedTodoItems');
      });
    } catch (e) {
      print('Error loading todos: $e');
    }
  }

  void removeTodos(List<TodoItem> todo) async {
    await todoManager.removeTodos(todo);
    loadTodos();
  }
}
