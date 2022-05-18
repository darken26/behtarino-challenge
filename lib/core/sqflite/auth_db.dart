import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/auth_model.dart';

class AuthenticationDBHelper {
  AuthenticationDBHelper._privateConstructor();
  static final AuthenticationDBHelper instance = AuthenticationDBHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'auth.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE auth(
          token Text PRIMARY KEY,
          key TEXT,
          userName TEXT
      )
      ''');
  }

  Future<List<AuthModel>> getAuth() async {
    Database db = await instance.database;
    var auth = await db.query('auth', orderBy: 'token');
    List<AuthModel> authList = auth.isNotEmpty
        ? auth.map((c) => AuthModel.fromJson(c)).toList()
        : [];
    return authList;
  }

  Future<int> add(AuthModel auth) async {
    Database db = await instance.database;
    return await db.insert('auth', auth.toMap());
  }

  Future<int> remove(String token) async {
    Database db = await instance.database;
    return await db.delete('auth', where: 'token = ?', whereArgs: [token]);
  }

  Future<int> update(AuthModel auth) async {
    Database db = await instance.database;
    return await db.update('auth', auth.toMap(),
        where: "token = ?", whereArgs: [auth.token]);
  }
}
