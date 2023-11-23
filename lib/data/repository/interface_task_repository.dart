import 'package:app_taskflow/model/task.dart';

abstract class InterfaceTaskRepository {
  Future<List<Task>> findAllTasks();
  Future<Task?> findTaskById(int id);
  Future<void> insertTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(Task task);
}