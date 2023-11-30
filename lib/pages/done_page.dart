import 'package:flutter/material.dart';
import 'package:todo_app_project/mobile_storage/shared_pref.dart';
import 'package:todo_app_project/pages/edittodo_page.dart';


class DonePage extends StatefulWidget {
  @override
  _DonePageState createState() => _DonePageState();
}



class _DonePageState extends State<DonePage> {
    TodosManager todoManager = TodosManager();
    List<TodoItem> _savedTodoItems = [];
  

  @override
  Widget build(BuildContext context) {

   // var doneModel = [1]; //Provider.of<DoneModel>(context);
/*
    // Sample data for testing
    var sampleData = [
      DoneItem(title: 'title', description: 'Description blal'),
      DoneItem(title: 'title plugga', description: 'Description blalan'),
      DoneItem(title: 'Completed hamster', description: 'Description ubcs'),
    ]; */

    // Add sample data to the DoneModel
    //  doneModel.addDoneItems(sampleData);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Done Page'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.green, Color.fromARGB(255, 13, 82, 13)],
          ),
        ),
        child: ListView.builder(
          itemCount: _savedTodoItems.length,
          itemBuilder: (context, index) {
            var doneItem =  _savedTodoItems[index];
            return Card(
              color: Colors.white70, // Customize card color
              elevation: 5.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text(
                  doneItem.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                subtitle: Text(
                  doneItem.description,
                  style: const TextStyle(fontSize: 14.0),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => EditTodoPage(),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
  void _loadTodos() async {
    try {
      List<TodoItem> loadedTodos = await todoManager.getTodos();
      debugPrint(loadedTodos.toString());
      setState(() {
        _savedTodoItems = loadedTodos;
      });
    } catch (e) {
      print('Error loading todos: $e');
    }
  }


}
