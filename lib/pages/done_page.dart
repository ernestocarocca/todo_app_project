import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_project/pages/edittodo_page.dart';
import 'package:todo_app_project/pages/todomodel_page.dart';

class DonePage extends StatelessWidget {
  const DonePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var doneModel = Provider.of<DoneModel>(context);

    // Sample data for testing
    var sampleData = [
      DoneItem(title: 'title', description: 'Description blal'),
      DoneItem(title: 'title plugga', description: 'Description blalan'),
      DoneItem(title: 'Completed hamster', description: 'Description ubcs'),
    ];

    // Add sample data to the DoneModel
    doneModel.addDoneItems(sampleData);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Done Page'),
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
          itemCount: doneModel.doneList.length,
          itemBuilder: (context, index) {
            var doneItem = doneModel.doneList[index];
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
}