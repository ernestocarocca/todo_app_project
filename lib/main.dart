import 'package:flutter/material.dart';
import 'package:todo_app_project/mobile_storage/shared_pref.dart';
import 'package:todo_app_project/pages/addtodo_page.dart';
import 'package:todo_app_project/pages/overview_page.dart';
import 'package:todo_app_project/pages/edittodo_page.dart';

Future<void> main() async {
  runApp(
    const MyApp(),
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
      home: const MyHomePage(
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
      const AddTodoPage(
        capturedImagePath: '',
      ),
      const EditTodoPage(),
    ];

    return Scaffold(
      body: pages[currentPage],
    );
  }
}
