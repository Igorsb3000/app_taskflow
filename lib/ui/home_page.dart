import 'package:app_taskflow/ui/catalog_task_page.dart';
import 'package:app_taskflow/ui/list_task_page.dart';
import 'package:app_taskflow/ui/register_task_page.dart';
import 'package:flutter/material.dart';

import '../controller/task_controller.dart';

class HomePage extends StatelessWidget {
  final TaskController taskController;
  const HomePage({super.key, required this.taskController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Center(child: Text("Taskflow"),),
      ),
      body: HomeBody(taskController: taskController,),
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}

class HomeBody extends StatelessWidget {
  final TaskController taskController;
  const HomeBody({super.key, required this.taskController});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterTaskPage(taskController: taskController,))
              ),
              style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  minimumSize: const Size(150, 50)),
              child: const Text("Cadastrar Tarefa"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListTaskPage(taskController: taskController,),)
              ),
              style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  minimumSize: const Size(150, 50)),
              child: const Text("Lista de Tarefas"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CatalogTaskPage(taskController: taskController,),)
              ),
              style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  minimumSize: const Size(150, 50)),
              child: const Text("Catálogo de Tarefas"),
            ),
          ),

        ],
      ),
    );
  }
}
