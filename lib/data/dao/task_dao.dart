import 'package:floor/floor.dart';

import '../../model/task.dart';

@dao
abstract class TaskDao {
  @Query('SELECT * FROM task WHERE id = :id')
  Future<Task?> findTaskById(int id);

  @Query('SELECT * FROM task')
  Future<List<Task>> findAllTasks();

  @insert
  Future<void> insertTask(Task task);

  @insert
  Future<void> insertAllTasks(List<Task> tasks);

  @update
  Future<void> updateTask(Task task);

  @delete
  Future<void> deleteTask(Task task);

}