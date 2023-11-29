import 'package:flutter/material.dart';
import 'package:todo_app_project/mobile_storage/shared_pref.dart';
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
    // var toDoModel = Provider.of<ToDoModel>(context);

    // Sample data for testings
    /*
    var sampleData = [
      ToDoItemModel(
          title: 'Handla',
          description: 'mjölk',
          imageUrl: ('images/testimage.jpg')),
      ToDoItemModel(
          title: 'träna',
          description: 'knäböj',
          imageUrl:
              'https://lomma.se/images/18.1f169aa2173042d75c4cfd65/1594737211499/hund%20-%20puff.jpg'),
      ToDoItemModel(
          title: 'städa',
          description: 'sopa',
          imageUrl:
              'https://lomma.se/images/18.1f169aa2173042d75c4cfd65/1594737211499/hund%20-%20puff.jpg'),
    ];
*/
    // Add sample data to the ToDoModel
    // toDoModel.addTodoItems(sampleData);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo Page'),
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
                // Anpassa din Card-widget
                child: ListTile(
                  title: Text(todoOnThisIdex.title),

                  // Här kan du lägga till annat innehåll för ListTile
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
}
