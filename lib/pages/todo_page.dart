import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_project/pages/todomodel_page.dart';

class ToDoPage extends StatelessWidget {
  const ToDoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var toDoModel = Provider.of<ToDoModel>(context);

    // Sample data for testing
    var sampleData = [
      ToDoItem(title: 'Handla', description: 'mjölk'),
      ToDoItem(title: 'träna', description: 'knäböj'),
      ToDoItem(title: 'städa', description: 'sopa'),
    ];

    // Add sample data to the ToDoModel
    toDoModel.addTodoItems(sampleData);

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
            colors: [Colors.blue, Color.fromARGB(255, 51, 167, 159)], 
          ),
        ),
        child: ListView.builder(
          itemCount: toDoModel.toDoList.length,
          itemBuilder: (context, index) {
            var todoItem = toDoModel.toDoList[index];
            return Card(
              color: Colors.white70, // Customize card color
              elevation: 5.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text(
                  todoItem.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                subtitle: Text(
                  todoItem.description,
                  style: const TextStyle(fontSize: 14.0),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}