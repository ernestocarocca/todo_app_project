import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_project/mobile_storage/shared_pref.dart';
import 'package:todo_app_project/pages/addtodo_page.dart';
import 'package:todo_app_project/pages/overview_page.dart';
import 'package:todo_app_project/pages/todomodel_page.dart';

import 'package:todo_app_project/pages/edittodo_page.dart';

//hej
Future<void> main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ToDoModel()),
        ChangeNotifierProvider(create: (context) => InProgressModel()),
        ChangeNotifierProvider(create: (context) => DoneModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: MyHomePage(
        title: 'main',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPage = 0;
  @override
  void initState() {
    super.initState();
    initShareprefs();
  }

  Future<void> initShareprefs() async {
    WidgetsFlutterBinding.ensureInitialized();
    await TodosManager.init();
    setState(() {
      print('inintprefs run in start');
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      const OverviewPage(),
      const AddTodoPage(),
      EditTodoPage(),
    ];

    return Scaffold(
      body: pages[currentPage],
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.horizontal_split_rounded),
            label: 'Overview',
          ),
          NavigationDestination(
            icon: Icon(Icons.note_add),
            label: 'Add todo',
          ),
          NavigationDestination(
            icon: Icon(Icons.edit),
            label: 'Edit todo',
          ),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            currentPage = index;
          });
        },
        selectedIndex: currentPage,
      ),
    );
  }
}
