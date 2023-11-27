import 'package:flutter/material.dart';
import 'package:todo_app_project/mobile_storage/shared_pref.dart';
import 'package:todo_app_project/pages/addtodo_page.dart';
import 'package:todo_app_project/pages/overview_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await SharedPreferencesManager.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: 'Flutter Demo',
        home: MyHomePage(
          title: 'main',
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currenntPage = 0;
  List<Widget> pages = [OverviewPage(), AddTodoPage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currenntPage],
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.horizontal_split_rounded), label: 'Overview'),
          NavigationDestination(icon: Icon(Icons.note_add), label: 'Add todo'),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            currenntPage = index;
          });
        },
        selectedIndex: currenntPage,
      ),
    );
  }
}
