import 'dart:async';

import 'package:app_taskflow/data/repository/implementacao_task_repository.dart';
import 'package:app_taskflow/ui/home_page.dart';
import 'package:flutter/material.dart';

import 'data/api/api_client.dart';
import 'data/api/connectivity_service.dart';
import 'data/database/database.dart';
import 'controller/task_controller.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final ConnectivityService connectivityService = ConnectivityService();
  connectivityService.initConnectivity();
  connectivityService.startListening();

  runApp(MyAppWrapper(connectivityService: connectivityService,));
}

class MyAppWrapper extends StatefulWidget {
  final ConnectivityService connectivityService;
  const MyAppWrapper({super.key, required this.connectivityService});

  @override
  _MyAppWrapperState createState() => _MyAppWrapperState();
}

class _MyAppWrapperState extends State<MyAppWrapper> {
  ImplementacaoTaskRepository? repository;
  TaskController? taskController;

  @override
  void initState() {
    super.initState();
    initializeDatabase();
  }

  @override
  void dispose(){
    super.dispose();
  }
  Future<void> initializeDatabase() async {
    final AppDatabase database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final ImplementacaoTaskRepository repository = ImplementacaoTaskRepository(
      taskDao: database.taskDao,
      apiClient: ApiClient(),
      connectivityService: widget.connectivityService,
    );

    taskController = TaskController(repository: repository);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (taskController == null) {
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
        home: HomePage(taskController: taskController!),
      );
    }
  }
}
