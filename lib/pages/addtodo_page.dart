import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:todo_app_project/mobile_storage/shared_pref.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({Key? key, required this.capturedImagePath})
      : super(key: key);
  final String? capturedImagePath;
  @override
  AddTodoPageState createState() => AddTodoPageState();
}

class AddTodoPageState extends State<AddTodoPage> {
//variable that saves the path to the image taken or choosen from gallery
  String? _selectedImagePath;
  String getImage = '';
  TodosManager todoManager = TodosManager();
  List<TodoItem> _savedTodoItems = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<TodoTask> todoList = [];
  late XFile imageFile;
  @override
  void initState() {
    super.initState();
    _loadTodos(); // Ernesto: Load tasks from SharedPreferences when the page initializes.
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
              removeTodos();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _pickImageFromCamera, //opens camera
                  tooltip: 'Take Photo',
                  icon: const Icon(Icons.camera_alt_rounded),
                ),
                IconButton(
                  onPressed: _pickImageFromGallery, //opens gallery
                  tooltip: 'Open Gallery',
                  icon: const Icon(Icons.photo_library),
                ),
              ],
            ),
            const Text('Title:'),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: 'Enter title',
              ),
            ),
            const Text('Description:'),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                hintText: 'Enter description',
                suffixIcon: IconButton(
                  onPressed: addTask,
                  icon: const Icon(Icons.add),
                ),
              ),
            ),
            const SizedBox(height: 14.0),
            _selectedImagePath != null
                ? Image.file(
                    File(_selectedImagePath!),
                    height: 150,
                    width: 150,
                  )
                : const SizedBox.shrink(),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _savedTodoItems.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(_savedTodoItems[index].title),
                      subtitle: Text(_savedTodoItems[index].showTodoList()),
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
                  addNewTodo();
                  if (widget.capturedImagePath != null) {
                    //    print('Captured Image Path: ${widget.capturedImagePath}');
                  }
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
      setState(() {
        _savedTodoItems = loadedTodos;
      });
    } catch (e) {
      print('Error loading todos: $e');
    }
  }

  void removeTodos() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      pref.setStringList('Todo', []);
      _savedTodoItems.clear();
      todoList.clear();
    });
  }

  Future<void> addNewTodo() async {
    String todoTitle = titleController.text.trim();
    getImage = _selectedImagePath ?? "";
    getlocalfile(getImage);

    TodoItem todoItem = TodoItem(
      title: todoTitle,
      todoList: List.from(todoList),
      isCrossed: false,
      image: getImage,
    );
    _savedTodoItems.add(todoItem);
    setState(() {
      print(_savedTodoItems);
      _saveTodos(List.from(_savedTodoItems));
      todoList.clear();
      titleController.clear();
      descriptionController.clear();
    });
  }

  void addTask() async {
    String newDescription = descriptionController.text.trim();
    TodoTask task = TodoTask(taskName: newDescription, isDone: false);

    todoList.add(task);
    setState(() {
      descriptionController.clear();
    });
  }

  Future<void> _saveTodos(List<TodoItem> todoItems) async {
    await todoManager.addTodoList(todoItems);
  }

  void _toggleTodo(int index) {
    setState(() {
      _savedTodoItems[index].isCrossed = !_savedTodoItems[index].isCrossed;
    });
  }

  // funktion to choose a image from gallery

  Future _pickImageFromCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (returnedImage == null) return;

    setState(() {
      _selectedImagePath = returnedImage.path;
      print('här skriv path ut när man addar $_selectedImagePath');
    });

 
    GallerySaver.saveImage(returnedImage.path).then((bool? success) {
      if (success != null) {
        print('Bilden sparades i galleriet');
      } else {
        print('Det uppstod ett fel vid sparandet av bilden i galleriet');
      }

  
    });
  }

  Future<File> getlocalfile(String pathFile) async {
    final root = await getApplicationDocumentsDirectory();
    final path = join(root.path, pathFile);
    return File(path).create(recursive: true);
  }

  Future _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedImage == null) return;

    setState(() {
      _selectedImagePath = returnedImage.path;
    });
  }
}
