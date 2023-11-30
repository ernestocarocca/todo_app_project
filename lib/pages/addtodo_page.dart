import 'dart:io';

import 'package:flutter/material.dart';
import 'package:todo_app_project/mobile_storage/camera_imagepicker.dart';

import 'package:todo_app_project/mobile_storage/shared_pref.dart';

//Ernesto: moved TodoItem class to Shae_pref file

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({Key? key}) : super(key: key);

  @override
  _AddTodoPageState createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TodosManager todoManager = TodosManager();

  List<TodoItem> _savedTodoItems = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<TodoItem> todoList = [];
  List<String> newTodoDescriptions = [];
  @override
  void initState() {
    super.initState();
    _loadTodos(); // Ernesto: Load tasks from SharedPreferences when the page initializes.
  }

  void _onButtonPressed() {
    addDescription();

    print('Button pressed!');
  }

  final CameraService _cameraService = CameraService();

  Future<void> _captureAndSaveImage() async {
    File? imageFile = await _cameraService.takePhoto();
    if (imageFile != null) {
      await _cameraService.saveImageToDevice(imageFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              // Rensa listan när delete-ikonen trycks
              removeTodos(_savedTodoItems);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            IconButton(
                onPressed: _captureAndSaveImage,
                tooltip: 'Take Photo',
                icon: const Icon(Icons.camera_alt_rounded)),

            const Text('Title:'),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: 'Enter title',
              ),
            ),
            //  const SizedBox(height: 16.0),
            const Text('Description:'),

            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                  hintText: 'Enter description',
                  suffixIcon: IconButton(
                    onPressed: _onButtonPressed,
                    icon: const Icon(Icons.add),
                  )),
            ),

            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _savedTodoItems.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(_savedTodoItems[index].title),
                      subtitle:
                          Text(_savedTodoItems[index].todoList.toString()),
                      trailing: GestureDetector(
                        onTap: () {
                          _toggleTodo(index);
                        },
                        child: Icon(
                          _savedTodoItems[index].isCrossed
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: _savedTodoItems[index].isCrossed
                              ? Colors.green
                              : null,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  addNewItem();

                  //_saveTodos(_savedTodoItems);
                },
                child: const Text('Add Todo'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _loadTodos() async {
    try {
      List<TodoItem> loadedTodos = await todoManager.getTodos();
      //  debugPrint(loadedTodos[index].todoList.toString());
      setState(() {
        _savedTodoItems = loadedTodos;
      });
    } catch (e) {
      print('Error loading todos: $e');
    }
  }

  void removeTodos(List<TodoItem> todo) async {
    await todoManager.removeTodos(todo);
    _loadTodos();
  }
/*
  Future<void> addNewItem() async {
    String newTodoItem = titleController.text.trim();
    String description = descriptionController.text.trim();
    if (newTodoItem.isNotEmpty) {
      List<String> todoDescriptions =
          description.isNotEmpty ? description.split(" ") : [];
      TodoItem newItem =
          TodoItem(newTodoItem, todoDescriptions, false, description);
      _savedTodoItems.add(newItem);
      await _saveTodos(_savedTodoItems);
      titleController.clear();
      descriptionController.clear();
    }
    for (dynamic p in _savedTodoItems) {
      debugPrint(p.toString());
    }
  }*/

/*
  void addDescription() {
    String newDescription = descriptionController.text.trim();
    if (newDescription.isNotEmpty) {
      setState(() {
        newTodoDescriptions.add(newDescription);
        _savedTodoItems.forEach((e) {
          newTodoDescriptions.addAll(e.todoList);
        });
        descriptionController.clear();
      });
    }
  } */

  void addDescription() {
    String newDescription = descriptionController.text.trim();
    if (newDescription.isNotEmpty) {
      setState(() {
        newTodoDescriptions.add(newDescription);
        descriptionController.clear();
      });
    }
  }

  Future<void> addNewItem() async {
    String newTodoItem = titleController.text.trim();
    if (newTodoItem.isNotEmpty) {
      TodoItem newItem = TodoItem(
          newTodoItem,
          List.from(newTodoDescriptions),
          false,
          ''); // Kopiera newTodoDescriptions för att undvika direkt referens till listan
      _savedTodoItems.add(newItem);

      // Spara den uppdaterade listan av todo-items
      await _saveTodos(_savedTodoItems);

      // Rensa input-fält och beskrivningslistan
      setState(() {
        titleController.clear();
        newTodoDescriptions.clear();
      });
    }
  }

  void saveTodoItem() async {
    // Funktionen för att spara TodoItem har integrerats i addNewItem()
  }

  Future<void> _saveTodos(List<TodoItem> todoItems) async {
    await todoManager.addTodoList(todoItems);
  }




  void _toggleTodo(int index) {
    setState(() {
      _savedTodoItems[index].isCrossed = !_savedTodoItems[index].isCrossed;
    });
  }
}
