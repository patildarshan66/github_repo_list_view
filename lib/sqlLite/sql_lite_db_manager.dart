import 'dart:developer';

import 'package:github_repositories_list/github/model/model_github_repo.dart';
import 'package:github_repositories_list/utils/ui_helper.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqlLiteDBManager {
  static late final Database database;

  static Future<void> openDB() async {
    try {
      database = await openDatabase(
        join(await getDatabasesPath(), 'github_repo_db.db'),
        onCreate: (db, version) {
          return db.execute(
            'CREATE TABLE githubRepoList(id INTEGER PRIMARY KEY, name TEXT, fullName TEXT, description TEXT, openIssues INTEGER, watchers INTEGER, language TEXT)',
          );
        },
        version: 1,
      );

    } catch (e) {
      log(e.toString());
      showSnackBar(e.toString());
    }
  }

  static Future<void> insertRecords(List<ModelGithubRepo> list) async {
    try {
      for (var element in list) {
        await database.insert(
          'githubRepoList',
          element.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    } catch (e) {
      log(e.toString());
      showSnackBar(e.toString());
    }
  }

  static Future<List<ModelGithubRepo>> getRecords(int offset) async {
    try {
      String selectQuery = "SELECT * FROM githubRepoList LIMIT 15 OFFSET $offset";
      final List<Map<String, dynamic>> maps =
          await database.rawQuery(selectQuery);


      return modelGithubRepoFromMap(maps);
    } catch (e) {
      log(e.toString());
      showSnackBar(e.toString());
      return [];
    }
  }
}
