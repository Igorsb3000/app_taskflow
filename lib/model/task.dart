import 'package:floor/floor.dart';

@entity
class Task {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String nome;

  final String descricao;

  final String status;

  Task({required this.id, required this.nome, required this.descricao, required this.status});

  @override
  String toString() {
    return 'Task{nome: $nome, descricao: $descricao, status: $status}';
  }
}