import 'package:app_taskflow/helpers/implementacao_task_repository.dart';
import 'package:flutter/material.dart';
import 'package:app_taskflow/widgets/custom_form_field.dart';

import 'package:app_taskflow/domain/task.dart';

class RegisterTaskPage extends StatelessWidget {
  final ImplementacaoTaskRepository repository;
  const RegisterTaskPage({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("Taskflow"),
          ),
      body: FormTaskBody(repository: repository,),
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}

class FormTaskBody extends StatefulWidget {
  final ImplementacaoTaskRepository repository;
  const FormTaskBody({super.key, required this.repository});

  @override
  State<FormTaskBody> createState() => _FormTaskBodyState();
}

class _FormTaskBodyState extends State<FormTaskBody> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nomeController = TextEditingController();
  TextEditingController descricaoController = TextEditingController();
  TextEditingController statusController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nomeController.dispose();
    descricaoController.dispose();
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
                    CustomFormField(
                      controller: statusController,
                      labelText: "Status",
                      validate_function: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Adicione um status';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          Task task = Task(
                            id: null,
                            nome: nomeController.text,
                            descricao: descricaoController.text,
                            status: statusController.text,
                          );
                          widget.repository.insertTask(task);
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
