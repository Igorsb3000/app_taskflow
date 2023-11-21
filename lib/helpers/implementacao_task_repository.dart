import 'package:app_taskflow/domain/task.dart';
import 'package:app_taskflow/helpers/interface_task_repository.dart';
import 'package:app_taskflow/helpers/task_dao.dart';
import 'package:app_taskflow/helpers/task_mapper.dart';

import 'api_client.dart';

class ImplementacaoTaskRepository implements InterfaceTaskRepository {
  final TaskDao taskDao;
  final ApiClient apiClient;

  ImplementacaoTaskRepository({required this.taskDao, required this.apiClient,});

  @override
  Future<List<Task>> findAllTasks() async {
    try {
      final List<Task> tasksLocal = await taskDao.findAllTasks();
      List<Task> tasksApi;
      try{
         tasksApi = await apiClient.getTasksFromApi();
      } catch(e){
        print("Erro ao obter dados da API: $e");
        tasksApi = [];
      }
      List<int?> listaIdsLocal = tasksLocal.map((task) => task.id).toList();
      tasksApi.removeWhere((task) => listaIdsLocal.contains(task.id));
      if(tasksApi.isNotEmpty){
        taskDao.insertAllTasks(tasksApi);
      }
      return await taskDao.findAllTasks();
    } catch (e) {
      throw Exception('Erro ao obter tarefas: $e');
    }
  }

  @override
  Future<Task?> findTaskById(int id) async {
    return taskDao.findTaskById(id);
  }

  @override
  Future<void> insertTask(Task task) async {
    try {
      await apiClient.salvarTaskNaApi(task);
      taskDao.insertTask(task);
    } catch (e) {
      throw Exception('Erro ao salvar tarefa: $e');
    }
  }

  @override
  Future<void> updateTask(Task task) async {
    try {
      await taskDao.updateTask(task);
      print("JSON TASK ATUALIZADA = ");
      await apiClient.atualizarTaskNaApi(task.id, TaskMapper().toJson(task));
    } catch (e) {
      throw Exception('Erro ao atualizar tarefa: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteTask(Task task) async {
    try {
      await taskDao.deleteTask(task);
      await apiClient.deletarTaskNaApi(task.id);
    } catch (e) {
      throw Exception('Erro ao deletar tarefa: $e');
    }
  }

}