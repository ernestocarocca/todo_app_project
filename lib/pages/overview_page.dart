import 'package:flutter/material.dart';
import 'package:todo_app_project/pages/addtodo_page.dart';
import 'package:todo_app_project/pages/todo_page.dart';
import 'package:todo_app_project/pages/inprogress_page.dart';
import 'package:todo_app_project/pages/done_page.dart';


// The main class representing the Overview Page
class OverviewPage extends StatefulWidget {
  const OverviewPage({Key? key}) : super(key: key);

  @override
  _OverviewPageState createState() => _OverviewPageState();
}

// The state class for the Overview Page
class _OverviewPageState extends State<OverviewPage> {

  // Variable to control the font size of text
  double _fontSize = 18;

  @override
  Widget build(BuildContext context) {
    // App bar at the top of the screen
    return Scaffold(
      appBar: AppBar(
        title: const Text('Overview Page'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Button to navigate to ToDo Page
          _buildButton(context, 'ToDo', Icons.checklist, const ToDoPage()),
          // Button to navigate to In Progress Page
          _buildButton(context, 'In Progress', Icons.hourglass_bottom, const InProgressPage()),
          // Button to navigate to Done Page
          _buildButton(context, 'Done', Icons.check_circle, DonePage()),

          const SizedBox(
            height: 10,
          ),
          Slider(
            value: _fontSize,
            min: 10,
            max: 30,
            onChanged: (double value) {
              setState(() {
                _fontSize = value;
              });
            },
          ),
        ],
      ),

      // Floating Action Button for adding new todos navigates to addtodopage
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 20.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const AddTodoPage(capturedImagePath: ''),
              ),
            );
          },
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.blue,
          elevation: 0,
          child: const Icon(
            Icons.post_add,
            size: 60,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  // Function to build buttons used for navigation
  Widget _buildButton(
      BuildContext context, String title, IconData icon, Widget destination) {
    return Padding(
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
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
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
                style: TextStyle(fontSize: _fontSize, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}