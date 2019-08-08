import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_list_projects/models/item.dart';
import 'package:flutter_list_projects/models/article.dart';


class DatabaseClient  {

  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    } else {
      /// create database
      _database = await createDatabase();
      return _database;
    }
  }

  Future createDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String database_directory = join(directory.path, 'database.db');
    var bdd = await openDatabase(database_directory, version: 1, onCreate: _onCreate);
    return bdd;
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE item (
    id INTEGER PRIMARY KEY, 
    title TEXT NOT NULL)
    ''');
    await db.execute(
      '''
      CREATE TABLE article (
      id INTEGER PRIMARY KEY,
      title TEXT NOT NULL,
      item INTEGER,
      price TEXT,
      shop TEXT,
      image TEXT)
      '''
    );
  }

  /// Insert
  Future<Item> insertItem(Item item) async {
    Database myDatabase = await database;
    item.id = await myDatabase.insert("item", item.toMap());
    return item;
  }

  /// Upsert Idea
  Future<Article> upsertIdea(Article idea) async {
    Database myDatabase = await database;
    if (idea.id == null) {
      idea.id = await myDatabase.insert('article', idea.toMap());
    } else {
      await myDatabase.update('article', idea.toMap(), where: 'id = ?', whereArgs: [idea.id]);
    }
    return idea;
  }

  /// Delete
  Future<int> deleteItem(int id, String table) async {
    Database myDatabase = await database;
    await myDatabase.delete('article', where: 'item = ?', whereArgs: [id]);
    return await myDatabase.delete(table, where: "id = ?", whereArgs: [id]);
  }

  /// Update
  Future<int> updateItem(Item item) async {
    Database myDatabase = await database;
    return await myDatabase.update('item', item.toMap(), where: 'id = ?', whereArgs: [item.id]);
  }

  /// Upsert : update or insert
  Future<Item> upsertItem(Item item) async {
    Database myDatabase = await database;
    if (item.id == null) {
      item.id = await myDatabase.insert('item', item.toMap());
    } else {
      await myDatabase.update('item', item.toMap(), where: 'id = ?', whereArgs: [item.id]);
    }
    return item;
  }

  /// Get all items
  Future<List<Item>> getAllItems() async {
    Database myDatabase = await database;
    List<Map<String, dynamic>> result = await myDatabase.rawQuery("SELECT * FROM item");
    List<Item> items = [];
    result.forEach((map) {
      Item item = new Item();
      item.fromMap(map);
      items.add(item);
    });
    return items;
  }

  /// Récupérer l'idée créée
 Future<List<Article>> getAlIdeas(int item) async {
    Database myDatabase = await database;
    List<Map<String, dynamic>> result = await myDatabase.query('article', where: 'item = ?', whereArgs: [item]);
    List<Article> ideas = [];
    result.forEach((map) {
      Article idea = new Article();
      idea.fromMap(map);
      ideas.add(idea);
    });
    return ideas;
    }
 }

