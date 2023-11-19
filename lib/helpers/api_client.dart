import 'dart:convert';

import 'package:app_taskflow/helpers/task_mapper.dart';
import 'package:http/http.dart' as http;

import '../domain/task.dart';

class ApiClient {
  final String baseUrl = 'http://179.234.133.106:8081/api/tarefas'; // trocar localhost por IP 179.234.133.106
  final String accessToken = 'eyJhbGciOiJSUzI1NiJ9.eyJpc3MiOiJzZWxmIiwic3ViIjoiaWdvci5iZW50byIsImV4cCI6MTcwMDQxOTAzNCwiaWF0IjoxNzAwNDE1NDM0LCJzY29wZSI6InVzZXIgIGFkbWluIn0.eRpfbXruxBbVRPkiMTUClgaX1ZonUjxkQ4rgc7F2OLFYqx-zt_86xTcVOHphc3jGwPcvT-PpaIByDDfD71nOJQMt7KAejRJaKm00YHZNGDdfCEmuB8WnyHfj-BtTm50UM6Q-QmQaLf-yNPeDCyheJnfvTBPfo4Yj5MPLedJ-4gbp0dJa1Xzcp02qEjswh7fPuWb-P7GyWMP7-HUEx3YMSEij-AlxnNcJ6lT7VWm8ZCpWQcwf2z5zrxJSGRVxgU07VGY81VhaYlZukuRJUARqznUaAgNcxAmUqrjrZiBbl4MAOgEhQnzlCqKmzblVdAE_cQ1aQz7YIEgrDq98j957IQ';

  Future<List<Task>> getTasksFromApi() async {
    final response = await http.get(
      Uri.parse('$baseUrl'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );
    if(response.statusCode == 200){
      List<Task> tasks = (response.body as List).map((e) => TaskMapper().fromJson(e)).toList();
      return tasks;
    } else {
      throw Exception('Falha ao carregar tarefas: ${response.statusCode}');
    }
  }

  Future<Task> salvarTaskNaApi(Task task) async {
    final response = await http.post(
        Uri.parse('$baseUrl'),
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json; charset=UTF-8'
        },
      body: jsonEncode(TaskMapper().toJson(task)),
    );

    if (response.statusCode == 201) {
      // Retorne o livro criado a partir da resposta
      Task novaTask = TaskMapper().fromJson((json.decode(response.body)));
      return novaTask;
    } else {
      throw Exception('Falha ao salvar task: ${response.statusCode}');
    }
  }

  Future<void> atualizarTaskNaApi(int? taskId, Map<String, dynamic> novaTask) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$taskId'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(novaTask),
    );

    if (response.statusCode != 204) {
      throw Exception('Falha ao atualizar Tarefa');
    }
  }

  Future<void> deletarTaskNaApi(int? taskId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$taskId'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Falha ao deletar Tarefa');
    }
  }



}