import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';
import 'package:todo_with_db/model/item.dart';

const tableName = 'todoTable';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'tododb.db'),
        onCreate: (db, version) {
      print('openDatabse $db');
      return db.execute(
          'CREATE TABLE $tableName(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT)');
    }, version: 1);
  }

  static Future<void> insert(Item item) async {
    print('insert $item');
    final db = await database();
    db.insert(
      tableName,
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Item>> getItemsFromDb() async {
    final Database db = await database();
    final List<Map<String, dynamic>> maps = await db.query(tableName);

    return List.generate(maps.length, (i) {
      return Item(
        maps[i]['title'],
        maps[i]['id'],
      );
    });
  }

  static Future<void> deleteItem(Item item) async {
    final db = await database();
    await db.delete(
      tableName,
      where: "id = ?",
      whereArgs: [item.id],
    );
  }

  static Future<void> updateItem(Item oldItem, Item newItem) async {
    final db = await database();

    await db.update(
      tableName,
      newItem.toMap(),
      where: "id = ?",
      whereArgs: [oldItem.id],
    );
  }
}
