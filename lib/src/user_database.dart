import 'package:flutter/widgets.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:cbac_app/src/user_info.dart';

void startDatabase() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = openDatabase(
    join(await getDatabasesPath(), 'user_info.db'),

    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE user(id INTEGER PRIMARY KEY, name TEXT, email TEXT)',
      );
    },
    version: 1,
  );

  Future<void> insertUser(User user) async {
    final db = await database;

    await db.insert(
      'user',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<User>> user() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('user');

    return List.generate(maps.length, (index) {
      return User(
        id: maps[index]['id'],
        name: maps[index]['name'],
        email: maps[index]['email'],
      );
    });
  }

  var jared = const User(id: 0, name: 'Jared', email: 'Jared@me.com');

  await insertUser(jared);
  print(await user());
}