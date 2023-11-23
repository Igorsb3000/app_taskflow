import 'dart:async';
import 'package:app_taskflow/model/task.dart';
import 'package:app_taskflow/data/dao/task_dao.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart';

@Database(version: 1, entities: [Task])
abstract class AppDatabase extends FloorDatabase {
  TaskDao get taskDao;
}