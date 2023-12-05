import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app_project/mobile_storage/camera_imagepicker.dart';
import 'package:todo_app_project/mobile_storage/shared_pref.dart';

//Ernesto: moved TodoItem class to Shae_pref file

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({Key? key, required this.capturedImagePath})
      : super(key: key);

  final String? capturedImagePath;

  @override
  _AddTodoPageState createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
//variable that saves the path to the image taken or choosen from gallery
  String? _selectedImagePath;
  String getImage = '';

  TodosManager todoManager = TodosManager();

  List<TodoItem> _savedTodoItems = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<TodoTask> todoList = [];

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
            //  const SizedBox(height: 16.0),
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

            //shows the image by using the variable  _selectedImagePath where the path is stored to the choosen image
            const SizedBox(height: 16.0),
            _selectedImagePath != null
                ? Image.file(
                    File(_selectedImagePath!),
                    height: 150,
                    width: 150,
                  )
                : SizedBox.shrink(),
            const SizedBox(height: 20),
            /*      Text(
              _selectedImagePath != null
                  ? 'Selected Image: $_selectedImagePath'
                  : 'Please select an image',
              style: Theme.of(context).textTheme.titleLarge,
            ),*/

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
                    print('Captured Image Path: ${widget.capturedImagePath}');
                  }

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

  void removeTodos() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    // await todoManager.removeTodos(todo);

    setState(() {
      pref.setStringList('Todo', []);
      _savedTodoItems.clear();
      todoList.clear();
    });
  }

  Future<void> addNewTodo() async {
    String todoTitle = titleController.text.trim();
    // String newDescription = descriptionController.text.trim();

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
    });

    // Spara den tagna bilden i galleriet
    GallerySaver.saveImage(returnedImage.path).then((bool? success) {
      getImage = _selectedImagePath ?? "";
      if (success != null) {
        print('Bilden sparades i galleriet');
      } else {
        print('Det uppstod ett fel vid sparandet av bilden i galleriet');
      }

      // Spara den tagna bilden i galleriet
    });
  }

  Future _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedImage == null) return;

    setState(() {
      _selectedImagePath = returnedImage.path;
    });
  }
/*
// funktion to take a image
  Future _pickImageFromCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (returnedImage == null) return;
    setState(() {
      _selectedImagePath = returnedImage.path;
    });
  } */
}
