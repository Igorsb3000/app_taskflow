import 'package:app_taskflow/domain/task.dart';
import 'package:flutter/material.dart';

import '../helpers/database.dart';
import '../widgets/custom_form_field.dart';


class EditTaskPage extends StatelessWidget {
  late int id;
  late String nome;
  late String descricao;
  late TaskStatus status;

  EditTaskPage(this.id, this.nome, this.descricao, this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Taskflow"),
      ),
      body: FormEditTaskBody(
          this.id, this.nome, this.descricao, this.status),
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}

class FormEditTaskBody extends StatefulWidget {
  late int id;
  late String nome;
  late String descricao;
  late TaskStatus status;

  FormEditTaskBody(this.id, this.nome, this.descricao, this.status, {super.key});

  @override
  State<FormEditTaskBody> createState() => _FormEditTaskBodyState();
}

class _FormEditTaskBodyState extends State<FormEditTaskBody> {
  final _formKey = GlobalKey<FormState>();
  late final AppDatabase database;

  late final int id;
  TextEditingController nomeController = TextEditingController();
  TextEditingController descricaoController = TextEditingController();
  TaskStatus? selectedStatus;


  @override
  void initState() {
    super.initState();
    id = widget.id;
    nomeController =  TextEditingController(text: widget.nome);
    descricaoController.text = widget.descricao;
    selectedStatus = widget.status;
    print('Abrindo conexão com BD');
    openDatabase();
  }

  @override
  void dispose() {
    nomeController.dispose();
    descricaoController.dispose();
    print('Fechando conexão com BD');
    closeDatabase();
    super.dispose();
  }

  Future<void> openDatabase() async {
    database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  }

  Future<void> closeDatabase() async {
    await database.close();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    Text(
                      "Editar Tarefa",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.inverseSurface,
                      ),
                    ),
                    const SizedBox(height: 30),
                    CustomFormField(
                      controller: nomeController,
                      labelText: "Nome",
                      validate_function: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Adicione um nome';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomFormField(
                      controller: descricaoController,
                      labelText: "Descrição",
                      validate_function: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Adicione uma descrição';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<TaskStatus>(
                        value: selectedStatus,
                        onChanged: (TaskStatus? newValue) {
                          setState(() {
                            selectedStatus = newValue;
                          });
                        },
                        items: TaskStatus.values.map((TaskStatus status) {
                          return DropdownMenuItem<TaskStatus>(
                            value: status,
                            child: Text(status
                                .toString()
                                .split('.')
                                .last), // Remove o prefixo enum
                          );
                        }).toList(),
                        decoration: InputDecoration(labelText: 'Status'),
                        validator: (value) {
                          if (value == null) {
                            return 'Selecione um status.';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          Task task = Task(
                            id: id,
                            nome: nomeController.text,
                            descricao: descricaoController.text,
                            status: selectedStatus!,
                          );
                          database.taskDao.updateTask(task);
                          Navigator.pop(context, 'listaAtualizada');
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      child: Text(
                        "Salvar",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
