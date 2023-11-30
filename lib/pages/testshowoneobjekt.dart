
/*
// Sample TodoItem class
class TodoItem {
  final String title;
  final List<String> todoList;
  bool isCompleted;

  TodoItem(this.title, this.todoList, this.isCompleted);
}

class TodoDetailsPage extends StatelessWidget {
  final TodoItem todoItem;

  TodoDetailsPage(this.todoItem);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              todoItem.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Text(
              'Todo List:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
   
          ],
        ),
      ),
    );
  }
}

void main() {
  TodoItem todo = TodoItem('Sample Todo', ['Task 1', 'Task 2', 'Task 3'], false);
  runApp(MaterialApp(
    home: TodoDetailsPage(todo),
  ));
}

 */