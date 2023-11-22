import 'package:app_taskflow/domain/task.dart';
import 'package:flutter/material.dart';

import '../helpers/implementacao_task_repository.dart';
import '../widgets/custom_form_field.dart';

class EditTaskPage extends StatelessWidget {
  late int id;
  late String nome;
  late String descricao;
  late String status;
  final ImplementacaoTaskRepository repository;

  EditTaskPage(this.id, this.nome, this.descricao, this.status, this.repository, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Editar Tarefa"),
      ),
      body: FormEditTaskBody(
          id, nome, descricao, status, repository),
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}

class FormEditTaskBody extends StatefulWidget {
  late int id;
  late String nome;
  late String descricao;
  late String status;
  final ImplementacaoTaskRepository repository;

  FormEditTaskBody(this.id, this.nome, this.descricao, this.status, this.repository, {super.key});

  @override
  State<FormEditTaskBody> createState() => _FormEditTaskBodyState();
}

class _FormEditTaskBodyState extends State<FormEditTaskBody> {
  final _formKey = GlobalKey<FormState>();

  late final int id;
  TextEditingController nomeController = TextEditingController();
  TextEditingController descricaoController = TextEditingController();
  TextEditingController statusController = TextEditingController();


  @override
  void initState() {
    super.initState();
    id = widget.id;
    nomeController =  TextEditingController(text: widget.nome);
    descricaoController.text = widget.descricao;
    statusController.text = widget.status;
  }

  @override
  void dispose() {
    nomeController.dispose();
    descricaoController.dispose();
    statusController.dispose();
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
              padding: const EdgeInsets.all(8.0),
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
                            id: id,
                            nome: nomeController.text,
                            descricao: descricaoController.text,
                            status: statusController.text,
                          );
                          widget.repository.updateTask(task);
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
