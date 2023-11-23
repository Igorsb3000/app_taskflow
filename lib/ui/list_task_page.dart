import 'package:app_taskflow/model/task.dart';
import 'package:app_taskflow/ui/edit_task_page.dart';
import 'package:flutter/material.dart';

import '../controller/task_controller.dart';

class ListTaskPage extends StatelessWidget {
  final TaskController taskController;
  const ListTaskPage({super.key, required this.taskController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Lista de Tarefas"),
      ),
      body: ListBody(taskController: taskController,),
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}


class ListBody extends StatefulWidget {
  final TaskController taskController;
  const ListBody({super.key, required this.taskController});
  static const maxLength = 15;

  @override
  State<ListBody> createState() => _ListBodyState();
}

class _ListBodyState extends State<ListBody> {
  Future<List<Task>> tasks = Future.value([]);

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadTasks() async {
    final loadedTasks = await widget.taskController.getAllTasks();
    setState(() {
      tasks = Future.value(loadedTasks);
    });
  }

  void onUpdateList(){
    _loadTasks();
  }


  @override
  Widget build(BuildContext context) {
    return
      FutureBuilder(
        future: tasks,
        builder: (context, snapshot) {
          return snapshot.hasData  ? ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(10.0),
            children: [
              DataTable(
                columns: _createTaskTableColumns(),
                rows: _createTaskTableRows(snapshot.data ?? []),
              ),
            ],
          )
              : const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
  }
  List<DataColumn> _createTaskTableColumns() {
    return const [
      DataColumn(label: Text('ID')),
      DataColumn(label: Text('Nome')),
      DataColumn(label: Text('Ações')),
    ];
  }

  List<DataRow> _createTaskTableRows(List<Task> tasks) {
    return tasks
        .map((task) => DataRow(cells: [
      DataCell(Text('#${task.id}'),),
      DataCell(
        Text(task.nome.length > ListBody.maxLength
              ? '${task.nome.substring(0, ListBody.maxLength)}...' // Limitando a quantidade de caracteres
              : task.nome,),
      ),
    DataCell(
      Row(children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Editar tarefa!"),
              ));
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditTaskPage(
                      task.id!,
                      task.nome,
                      task.descricao,
                      task.status,
                      widget.taskController
                  ),
                ),
              ).then((result) {
                // Esta função será chamada após o Navigator.pop na tela de destino
                if (result != null && result is String && result == 'listaAtualizada') {
                  // Atualize sua lista aqui chamando a função de callback
                  onUpdateList();
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("${task.nome} foi excluído!"),
              ));
              await widget.taskController.deleteTask(task);
              onUpdateList();
            },
          ),
        ],
        ),

    ),
    ]))
        .toList();
  }
}


