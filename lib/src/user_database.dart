import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute('CREATE TABLE user(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT NOT NULL, email TEXT NOT NULL)');
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'user.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      }
    );
  }

  static Future<int> createItem(String name, String email) async {
    final db = await SQLHelper.db();
    final data = {'name': name, 'email': email};
    final id = await db.insert('user', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('user', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('user', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateItem(int id, String name, String email) async {
    final db = await SQLHelper.db();

    final data = {
      'name': name,
      'email': email,
    };

    final result = await db.update('user', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("user", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}