import 'package:app_taskflow/helpers/implementacao_task_repository.dart';
import 'package:flutter/material.dart';

import '../domain/task.dart';



class CatalogTaskPage extends StatelessWidget {
  final ImplementacaoTaskRepository repository;
  const CatalogTaskPage({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Catálogo dos livros"),
      ),
      body: CatalogBody(repository: repository,),
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}
class CatalogBody extends StatefulWidget {
  final ImplementacaoTaskRepository repository;
  const CatalogBody({super.key, required this.repository});

  @override
  State<CatalogBody> createState() => _CatalogBodyState();
}

class _CatalogBodyState extends State<CatalogBody> {
  Future<List<Task>> tasks = Future.value([]);
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

  bool isButtonAnteriorEnabled(){
    if(indiceAtual == 0){
      return false;
    } else {
      return true;
    }
  }

  bool isButtonProximoEnabled(){
    if(indiceAtual == listaDeTasks.length - 1){
      return false;
    } else {
      return true;
    }

  }

  Future<void> _loadTasks() async {
    final loadedTasks = await widget.repository.findAllTasks();
    setState(() {
      tasks = Future.value(loadedTasks);
    });
  }

  obterAnterior(){
    if (indiceAtual > 0) {
      setState(() {
        indiceAtual--;
      });
    }
  }

  obterProximo(){
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
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const CircularProgressIndicator();
          } else if (snapshot.hasError){
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty){
            return const Text('Sem dados');
          } else {
            listaDeTasks = snapshot.data as List<Task>;


            return ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  task = listaDeTasks[indiceAtual];

                  return Column(
                    children: [
                      const SizedBox(height: 80),
                      const Text(
                        'ID:',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 28,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        task.id.toString(),
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
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 28,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        task.nome,
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
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 28,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        task.descricao,
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
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 28,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        task.status,
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
                                  onPressed: isButtonAnteriorEnabled() ? obterAnterior : null,
                                  style: TextButton.styleFrom(
                                      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
                                  onPressed: isButtonProximoEnabled() ? obterProximo : null,
                                  style: TextButton.styleFrom(
                                      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
                }
            );
          }
        });
  }
}