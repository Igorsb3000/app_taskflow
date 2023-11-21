import 'package:app_taskflow/helpers/implementacao_task_repository.dart';
import 'package:app_taskflow/ui/home_page.dart';
import 'package:flutter/material.dart';

import 'helpers/api_client.dart';
import 'helpers/database.dart';


void main() {
  runApp(const MyAppWrapper());
}

class MyAppWrapper extends StatefulWidget {
  const MyAppWrapper({super.key});

  @override
  _MyAppWrapperState createState() => _MyAppWrapperState();
}

class _MyAppWrapperState extends State<MyAppWrapper> {
  ImplementacaoTaskRepository? repository;

  @override
  void initState() {
    super.initState();
    initializeDatabase();
  }

  Future<void> initializeDatabase() async {
    final AppDatabase database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    repository = ImplementacaoTaskRepository(taskDao: database.taskDao, apiClient: ApiClient());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (repository == null) {
      return CircularProgressIndicator(); // ou um loading
    } else {
      return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          useMaterial3: true,
          textTheme: TextTheme(
            displayLarge: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w300,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            labelLarge: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
        home: repository != null ? HomePage(repository: repository!) : Container(),
      );
    }
  }
}
