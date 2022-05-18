import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/events_model.dart';

class EventsDBHelper {
  EventsDBHelper._privateConstructor();
  static final EventsDBHelper instance = EventsDBHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'events.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE events(
          id TEXT PRIMARY KEY,
          name TEXT,
          start TEXT,
          end TEXT
      )
      ''');
  }

  Future<List<EventsModel>> getEvents() async {
    Database db = await instance.database;
    var event = await db.query('events', orderBy: 'id');
    List<EventsModel> eventsList = event.isNotEmpty
        ? event.map((c) => EventsModel.fromJson(c)).toList()
        : [];
    return eventsList;
  }

  Future<int> add(EventsModel event) async {
    Database db = await instance.database;
    return await db.insert('events', event.toMap());
  }

  Future<int> remove(String id) async {
    Database db = await instance.database;
    return await db.delete('events', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(EventsModel event) async {
    Database db = await instance.database;
    return await db.update('events', event.toMap(),
        where: "id = ?", whereArgs: [event.id]);
  }
}
