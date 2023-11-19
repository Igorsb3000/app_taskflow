import 'package:app_taskflow/domain/task.dart';
import 'package:app_taskflow/helpers/task_dao.dart';
import 'package:app_taskflow/ui/edit_task_page.dart';
import 'package:flutter/material.dart';

import '../helpers/database.dart';
import '../helpers/implementacao_task_repository.dart';

class ListTaskPage extends StatelessWidget {
  final ImplementacaoTaskRepository repository;
  const ListTaskPage({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Taskflow"),
      ),
      body: ListBody(repository: repository,),
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}


class ListBody extends StatefulWidget {
  final ImplementacaoTaskRepository repository;
  const ListBody({super.key, required this.repository});

  @override
  State<ListBody> createState() => _ListBodyState();
}

class _ListBodyState extends State<ListBody> {
  Future<List<Task>> tasks = Future.value([]);
  //late final AppDatabase database;

  @override
  void initState() {
    super.initState();
    print('Abrindo conexão com BD');
    //openDatabase();
  }

  @override
  void dispose() {
    print('Fechando conexão com BD');
    //closeDatabase();
    super.dispose();
  }
/*
  Future<void> openDatabase() async {
    database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    _loadLivros();
  }

  Future<void> closeDatabase() async {
    await database.close();
  }
*/
  Future<void> _loadLivros() async {
    final loadedTasks = await widget.repository.findAllTasks();
    setState(() {
      tasks = Future.value(loadedTasks);
    });
  }

  void onUpdateList(){
   // openDatabase();
    _loadLivros();
  }


  @override
  Widget build(BuildContext context) {
    return
      FutureBuilder(
        future: tasks,
        builder: (context, snapshot) {
          return snapshot.hasData  ? ListView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, i) {
              return ListItem(task: snapshot.data![i], onUpdateList: onUpdateList, repository: widget.repository,);
            },
          )
              : const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
  }
}

class ListItem extends StatelessWidget {
  final ImplementacaoTaskRepository repository;
  final Task task;
  final Function onUpdateList;
  const ListItem({super.key, required this.task, required this.onUpdateList, required this.repository,});

  @override
  Widget build(BuildContext context) {
    return
      GestureDetector(
        onTap: () {
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
                  task.status
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
        onLongPress: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("${task.nome} foi excluído!"),
          ));
          print("ID da task = ${task.id}");
          repository.deleteTask(task);
          //livroHelper.deleteLivro(livro.id);
          onUpdateList();
        },
        child: ListTile(
          title: Text(task.nome),
        ),
      );
  }
}

