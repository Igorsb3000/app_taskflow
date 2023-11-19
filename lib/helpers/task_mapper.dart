import '../domain/task.dart';

class TaskMapper {
  Task fromJson(Map<String, dynamic> json){
    return Task(
      id: json['id'] as int,
      nome: json['nome'] as String,
      descricao: json['descricao'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson(Task task){
    return {
      'id': task.id,
      'nome': task.nome,
      'descricao': task.nome,
      'status': task.status,
    };
  }
}