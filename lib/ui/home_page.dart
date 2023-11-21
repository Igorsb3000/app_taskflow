import 'package:app_taskflow/ui/catalog_task_page.dart';
import 'package:app_taskflow/ui/list_task_page.dart';
import 'package:app_taskflow/ui/register_task_page.dart';
import 'package:flutter/material.dart';

import '../helpers/implementacao_task_repository.dart';

class HomePage extends StatelessWidget {
  final ImplementacaoTaskRepository repository;
  const HomePage({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Taskflow"),
      ),
      body: HomeBody(repository: repository,),
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}

class HomeBody extends StatelessWidget {
  final ImplementacaoTaskRepository repository;
  const HomeBody({super.key, required this.repository});

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
                MaterialPageRoute(builder: (context) => RegisterTaskPage(repository: repository,))
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
                  MaterialPageRoute(builder: (context) => ListTaskPage(repository: repository,),)
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
                  MaterialPageRoute(builder: (context) => CatalogTaskPage(repository: repository,),)
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
