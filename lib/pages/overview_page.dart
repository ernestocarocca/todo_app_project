import 'package:flutter/material.dart';
import 'package:todo_app_project/main.dart';
import 'package:todo_app_project/pages/addtodo_page.dart';
import 'package:todo_app_project/pages/todo_page.dart';
import 'package:todo_app_project/pages/inprogress_page.dart';
import 'package:todo_app_project/pages/done_page.dart';

class OverviewPage extends StatefulWidget {
final bool isDarkModeEnabled;
final VoidCallback toggleTheme;


  const OverviewPage({Key? key, required this.isDarkModeEnabled, required this.toggleTheme}) : super(key: key);



  @override
  _OverviewPageState createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  String dropdownValue = 'All Tasks'; // Justera standardvärdet
 

 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      

      home: Scaffold(
       

        appBar: AppBar(
          
          title: const Text('Overview Page'),
          centerTitle: true,
          actions: [
           Switch(
  value: widget.isDarkModeEnabled,
  onChanged: (value) {
    setState(() {
      widget.toggleTheme(); // Fix this line
    });
  },
),
            // Andra åtgärder kan läggas till här
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildButton(context, 'ToDo', Icons.checklist, const ToDoPage()),
            _buildButton(context, 'In Progress', Icons.hourglass_bottom, const InProgressPage()),
            _buildButton(context, 'Done', Icons.check_circle, const DonePage()),
          ],
        ),
        floatingActionButton: Container(
          margin: const EdgeInsets.only(bottom: 20.0),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const AddTodoPage(),
                ),
              );
            },
            child: const Icon(
              Icons.post_add,
              size: 30,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      ),
    );
  }

  Widget _buildButton(
      BuildContext context, String title, IconData icon, Widget destination) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => destination,
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white70,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 3),
              ),
            ],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(icon, color: Colors.blue),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}