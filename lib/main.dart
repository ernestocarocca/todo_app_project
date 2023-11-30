import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_project/pages/addtodo_page.dart';
import 'package:todo_app_project/pages/overview_page.dart';
import 'package:todo_app_project/pages/todomodel_page.dart';
import 'package:todo_app_project/pages/edittodo_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
 




class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool isDarkModeEnabled = false;



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      title: 'Flutter Demo',
      theme: isDarkModeEnabled ? ThemeData.dark() : ThemeData.light(),
       
       
      //colorScheme: const ColorScheme.dark(),
      
     
      
      
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
  bool isDarkModeEnabled = false;

     void toggleTheme() {
    setState(() {
      isDarkModeEnabled = !isDarkModeEnabled;
    });
  }



  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      OverviewPage(
        

        isDarkModeEnabled: isDarkModeEnabled,
        toggleTheme:toggleTheme,
      ),
      const AddTodoPage(),
      EditTodoPage(),
    ];

    return Scaffold(
      body: pages[currentPage],
     
    );
  }
}
