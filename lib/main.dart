import 'package:app_taskflow/helpers/implementacao_task_repository.dart';
import 'package:app_taskflow/ui/home_page.dart';
import 'package:floor/floor.dart';
import 'package:flutter/material.dart';

import 'helpers/api_client.dart';
import 'helpers/database.dart';
import 'helpers/task_dao.dart';

/*
Future<void> main()  async {
  //TestWidgetsFlutterBinding.ensureInitialized();
  final AppDatabase database =  await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  final ImplementacaoTaskRepository repository = ImplementacaoTaskRepository(taskDao: database.taskDao, apiClient: ApiClient());

  runApp(MyApp(repository: repository,));
}

class MyApp extends StatelessWidget {
  final ImplementacaoTaskRepository repository;

  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
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
      home: HomePage(repository: repository,),
    );
  }
}
*/
void main() {
  runApp(MyAppWrapper());
}

class MyAppWrapper extends StatefulWidget {
  @override
  _MyAppWrapperState createState() => _MyAppWrapperState();
}

class _MyAppWrapperState extends State<MyAppWrapper> {
  late final ImplementacaoTaskRepository repository;

  @override
  void initState() {
    super.initState();
    initializeDatabase();
  }

  Future<void> initializeDatabase() async {
    final AppDatabase database =
    await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    repository = ImplementacaoTaskRepository(
        taskDao: database.taskDao, apiClient: ApiClient());

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
        home: HomePage(repository: repository),
      );
    }
  }
}
