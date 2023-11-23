import 'package:app_taskflow/data/repository/implementacao_task_repository.dart';
import 'package:app_taskflow/model/task.dart';

class TaskController {
  late final ImplementacaoTaskRepository repository;

  TaskController({required this.repository});

  Future<List<Task>> getAllTasks() async {
    return repository.findAllTasks();
  }

  Future<void> addTask(Task task) async {
    return repository.insertTask(task);
  }

  Future<void> updateTask(Task task) async {
    return repository.updateTask(task);
  }

  Future<void> deleteTask(Task task) async {
    return repository.deleteTask(task);
  }
}