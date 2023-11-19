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
      final tasksLocal = await taskDao.findAllTasks();
      if(tasksLocal.isNotEmpty){
        return tasksLocal;
      } else {
        final tasksApi = await apiClient.getTasksFromApi();
        await taskDao.insertAllTasks(tasksApi);
        return tasksApi;
      }
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
      final novaTask = await apiClient.salvarTaskNaApi(task);
      await taskDao.insertTask(novaTask);
    } catch (e) {
      throw Exception('Erro ao salvar tarefa: $e');
    }
  }

  @override
  Future<void> updateTask(Task task) async {
    await taskDao.updateTask(task);
    try {
      await apiClient.atualizarTaskNaApi(task.id, TaskMapper().toJson(task));
    } catch (e) {
      throw Exception('Erro ao atualizar tarefa: $e');
    }
  }

  @override
  Future<void> deleteTask(Task task) async {
    await taskDao.deleteTask(task);
    try {
      await apiClient.deletarTaskNaApi(task.id);
    } catch (e) {
      throw Exception('Erro ao atualizar tarefa: $e');
    }
  }

}