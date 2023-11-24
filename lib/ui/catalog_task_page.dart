import 'package:flutter/material.dart';

import '../model/task.dart';
import '../controller/task_controller.dart';

class CatalogTaskPage extends StatelessWidget {
  final TaskController taskController;
  const CatalogTaskPage({super.key, required this.taskController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Catálogo de Tarefas"),
      ),
      body: CatalogBody(
        taskController: taskController,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}

class CatalogBody extends StatefulWidget {
  final TaskController taskController;
  const CatalogBody({super.key, required this.taskController});

  @override
  State<CatalogBody> createState() => _CatalogBodyState();
}

class _CatalogBodyState extends State<CatalogBody> {
  late Future<List<Task>> tasks = Future.value([]);
  late List<Task> listaDeTasks;
  int indiceAtual = 0;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isButtonAnteriorEnabled() {
    if (indiceAtual == 0) {
      return false;
    } else {
      return true;
    }
  }

  bool isButtonProximoEnabled() {
    if (indiceAtual == listaDeTasks.length - 1) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> _loadTasks() async {
    final loadedTasks = await widget.taskController.getAllTasks();
    setState(() {
      tasks = Future.value(loadedTasks);
    });
  }

  obterAnterior() {
    if (indiceAtual > 0) {
      setState(() {
        indiceAtual--;
      });
    }
  }

  obterProximo() {
    if (indiceAtual < listaDeTasks.length - 1) {
      setState(() {
        indiceAtual++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Task task;

    return FutureBuilder(
        future: tasks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            listaDeTasks = snapshot.data as List<Task>;

            if (listaDeTasks.isEmpty) {
              return FutureBuilder(
                future: Future.delayed(const Duration(
                    milliseconds: 500)), // Delay de 500 milissegundos
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return const Center(
                      child: Text('Sem dados', style: TextStyle(fontSize: 26)),
                    );
                  }
                },
              );
            } else {
              return ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    task = listaDeTasks[indiceAtual];

                    return Column(
                      children: [
                        const SizedBox(height: 80),
                        const Text(
                          'ID:',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 28,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Text(
                          task.id.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 26,
                            color: Theme.of(context).colorScheme.surfaceTint,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Nome:',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 28,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Text(
                          task.nome,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 26,
                            color: Theme.of(context).colorScheme.surfaceTint,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Descrição:',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 28,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Text(
                          task.descricao,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 26,
                            color: Theme.of(context).colorScheme.surfaceTint,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Status:',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 28,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Text(
                          task.status,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 26,
                            color: Theme.of(context).colorScheme.surfaceTint,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 80),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextButton(
                                    onPressed: isButtonAnteriorEnabled()
                                        ? obterAnterior
                                        : null,
                                    style: TextButton.styleFrom(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary,
                                        minimumSize: const Size(150, 50)),
                                    child: const Text("Anterior"),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextButton(
                                    onPressed: isButtonProximoEnabled()
                                        ? obterProximo
                                        : null,
                                    style: TextButton.styleFrom(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary,
                                        minimumSize: const Size(150, 50)),
                                    child: const Text("Próximo"),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    );
                  });
            }
          }
        });
  }
}
