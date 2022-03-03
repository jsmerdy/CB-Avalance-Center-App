import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:cbac_app/src/user_info.dart';

/*class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();

  static Database? _database;

  AppDatabase._init();

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await _initDB('appData.db');
    return _database;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute( 'CREATE TABLE user(id INTEGER PRIMARY KEY, name TEXT, email TEXT)');
  }

} */

Future<void> startDatabase(User addUser) async {
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

  Future<void> updateUser(User user) async {
    final db = await database;
    await db.update(
      'user',
      user.toMap(),
      where: 'id = 0',
      whereArgs: [user.id],
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

  await updateUser(addUser);
}