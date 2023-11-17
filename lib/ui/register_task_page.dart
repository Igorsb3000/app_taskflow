import 'package:app_taskflow/helpers/task_dao.dart';
import 'package:flutter/material.dart';
import 'package:app_taskflow/widgets/custom_form_field.dart';

import 'package:app_taskflow/domain/task.dart';

import '../helpers/database.dart';

class RegisterTaskPage extends StatelessWidget {
  const RegisterTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("Taskflow"),
          ),
      body: FormTaskBody(),
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}

class FormTaskBody extends StatefulWidget {
  FormTaskBody({super.key});

  @override
  State<FormTaskBody> createState() => _FormTaskBodyState();
}

class _FormTaskBodyState extends State<FormTaskBody> {
  final _formKey = GlobalKey<FormState>();
  late final AppDatabase database;
  TaskStatus? selectedStatus;

  TextEditingController nomeController = TextEditingController();
  TextEditingController descricaoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print('Abrindo conexão com BD');
    openDatabase();
  }

  Future<void> openDatabase() async {
    database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  }

  Future<void> closeDatabase() async {
    await database.close();
  }

  @override
  void dispose() {
    nomeController.dispose();
    descricaoController.dispose();
    print('Fechando conexão com BD');
    closeDatabase();
    super.dispose();
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
                      "Cadastrar Tarefa",
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
                            id: null,
                            nome: nomeController.text,
                            descricao: descricaoController.text,
                            status: selectedStatus!,
                          );
                          //livroHelper.saveLivro(l);
                          database.taskDao.insertTask(task);
                          Navigator.pop(context);
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      child: Text(
                        "Cadastrar",
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
