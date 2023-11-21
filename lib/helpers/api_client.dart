import 'dart:convert';

import 'package:app_taskflow/helpers/task_mapper.dart';
import 'package:http/http.dart' as http;

import '../domain/task.dart';

class ApiClient {
  final String baseUrl = 'http://5.161.191.148:8081/api/tarefas';

  Future<List<Task>> getTasksFromApi() async {
    final response = await http.get(
      Uri.parse('$baseUrl'),
    );
    if(response.statusCode == 200){
      Map<String, dynamic> jsonMap = json.decode(response.body);
      List<Map<String, dynamic>> listaContent = List<Map<String, dynamic>>.from(jsonMap['content']);
      List<Task> listaDeTasks = listaContent.map((task) => TaskMapper().fromJson(task)).toList();
      print("Lista de Tasks RECARREGADA com sucesso!");
      return listaDeTasks;
    } else {
      throw Exception('Falha ao carregar tarefas: ${response.statusCode}');
    }
  }

  Future<void> salvarTaskNaApi(Task task) async {
    final response = await http.post(
        Uri.parse('$baseUrl'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      body: jsonEncode(TaskMapper().toJson(task)),
    );

    if (response.statusCode == 201) {
      print("Task CADASTRADA na API com sucesso!");
    } else {
      throw Exception('Falha ao salvar task: ${response.statusCode}');
    }
  }

  Future<void> atualizarTaskNaApi(int? taskId, Map<String, dynamic> novaTask) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$taskId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(novaTask),
    );
    print("${jsonEncode(novaTask)}");
    if (response.statusCode == 204) {
      print("Task ATUALIZADA na API com sucesso!");
    } else {
      throw Exception('Falha ao atualizar Tarefa');
    }
  }

  Future<void> deletarTaskNaApi(int? taskId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$taskId'),
    );
    print("STATUS CODE DELETAR TASK = ${response.statusCode}");
    if (response.statusCode == 204) {
      print("Task REMOVIDA da API com sucesso!");
    } else {
      throw Exception('Falha ao deletar Tarefa');
    }
  }



}