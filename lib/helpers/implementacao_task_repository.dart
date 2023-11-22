import 'package:app_taskflow/domain/task.dart';
import 'package:app_taskflow/helpers/interface_task_repository.dart';
import 'package:app_taskflow/helpers/task_dao.dart';
import 'package:app_taskflow/helpers/task_mapper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'api_client.dart';
import 'connectivity_service.dart';

class ImplementacaoTaskRepository implements InterfaceTaskRepository {
  final TaskDao taskDao;
  final ApiClient apiClient;
  final ConnectivityService connectivityService;
  ImplementacaoTaskRepository({required this.taskDao, required this.apiClient, required this.connectivityService});

  @override
  Future<List<Task>> findAllTasks() async {
    final List<Task> tasksLocal = await taskDao.findAllTasks();

    if (connectivityService.getConnectionStatus() == ConnectivityResult.mobile ||
        connectivityService.getConnectionStatus() == ConnectivityResult.wifi) {
      print('Obtendo tasks da API...');
      try {
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
      } catch (e) {
        throw Exception('Erro ao obter tasks: $e');
      }
    }
    return await taskDao.findAllTasks();
  }

  @override
  Future<Task?> findTaskById(int id) async {
    return taskDao.findTaskById(id);
  }

  @override
  Future<void> insertTask(Task task) async {
    await taskDao.insertTask(task);

    if (connectivityService.getConnectionStatus() ==
        ConnectivityResult.mobile ||
        connectivityService.getConnectionStatus() == ConnectivityResult.wifi) {
      try {
        await apiClient.salvarTaskNaApi(task);
        print('A task foi cadastrada com sucesso na API!');
      } catch (e) {
        throw Exception('Erro ao salvar task: $e');
      }
    } else {
      print("Não foi possível cadastrar task na API por falta de conexão");
    }
  }

    @override
    Future<void> updateTask(Task task) async {
      await taskDao.updateTask(task);
      final List<Task> tasksLocal = await taskDao.findAllTasks();

      if (connectivityService.getConnectionStatus() ==
          ConnectivityResult.mobile ||
          connectivityService.getConnectionStatus() == ConnectivityResult.wifi) {

        List<Task> tasksApi;
        try{
          tasksApi = await apiClient.getTasksFromApi();
        } catch(e){
          print("Erro ao obter dados da API: $e");
          tasksApi = [];
        }
        // Verifica se existe alguma task no BD local que nao esteja na API, assim, quando o usuario atualizar e estiver conectado ele enviara para API
        Iterable<Task> listaEnviarParaApi = tasksLocal.where((task) => !tasksApi.any((item) => item.id == task.id));
        for (var task in listaEnviarParaApi) { await apiClient.salvarTaskNaApi(task); }

        if(!listaEnviarParaApi.contains(task)) {
          try {
            await apiClient.atualizarTaskNaApi(task.id, TaskMapper().toJson(task));
            print('A task foi atualizada com sucesso na API!');
          } catch (e) {
            throw Exception('Erro ao atualizar task: ${e.toString()}');
          }
        }

      } else {
        print("Não foi possível atualizar task na API por falta de conexão");
      }
    }

    @override
    Future<void> deleteTask(Task task) async {
      await taskDao.deleteTask(task);

      if (connectivityService.getConnectionStatus() ==
          ConnectivityResult.mobile ||
          connectivityService.getConnectionStatus() ==
              ConnectivityResult.wifi) {
        try {
          await apiClient.deletarTaskNaApi(task.id);
          print('A task foi deletada com sucesso na API!');
        } catch (e) {
          throw Exception('Erro ao deletar task: ${e.toString()}');
        }
      } else {
        print("Não foi possível deletar task na API por falta de conexão");
      }
    }

}