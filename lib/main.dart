import 'package:flutter/material.dart';
import 'package:todo_list/pages/todo_list_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: TodoListPage());
  }
}

//--------- Essa é a pasta principal do projeto Flutter. 

//----------------- Aqui ficam os arquivos que controlam a lógica e interface do app.