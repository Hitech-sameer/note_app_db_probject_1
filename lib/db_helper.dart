import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class NoteDatabase {
  NoteDatabase._();

  static getInstance()=> NoteDatabase._();

  Database? noteDb;


  Future<Database> initDb() async {
    return noteDb ??= await openDb();
    // if(noteDb!=null){
    //   return noteDb!;
    // }else{
    //   return noteDb = await openDb();
    // }
  }


  /// Column and table name
  static const String NOTE_TABLE = 'note_table';
  static const String N_id = 'n_id';
  static const String N_TITLE = 'n_title';
  static const String N_DESC = 'n_desc';
  static const String CREATE_AT = 'create_at'; // Us static so that u don't have to create an object to access table name

  Future<Database> openDb() async {
    // Note - directoryPath can't be assign with const
    final directoryPath = await getApplicationDocumentsDirectory();
    final dbPath = join(directoryPath.path, 'note_database.db');

    // db is created once so make sure u setup table before opening db
    // because later u change in on create will not reflect unless u delete and reinstall app you have to increase version to trigger db update
    return openDatabase(dbPath, version: 1, onCreate: (db, version) {
      return db.execute(
          'create table $NOTE_TABLE ($N_id integer primary key autoincrement,'
              '$N_TITLE text, $N_DESC text, $CREATE_AT text)');
    });
  }


  Future<void> addNote({required String title, required String desc}) async {
    Database db = await openDb();
    await db.insert(NOTE_TABLE,{
      N_TITLE: title,
      N_DESC: desc,
      CREATE_AT: DateTime.now().toString()
    });


  }

  Future<List<Map<String, dynamic>>> getAllNote()async{
    Database db = await initDb();
    List<Map<String,dynamic>> fetchNotes = await db.query(NOTE_TABLE);
    return fetchNotes;
  }

  Future<void> deleteNote({required int id})async{
    Database db = await initDb();
   await db.delete(NOTE_TABLE,where: '$N_id=?',whereArgs: [id]);
  }


 Future<void> updateNote({required String title, required String description,required int id})async{
    Database db = await initDb();
    await db.update(NOTE_TABLE,
        {
      N_TITLE: title,
          N_DESC: description,
          CREATE_AT: DateTime.now().toString()
    },
        where: '$N_id=?',
        whereArgs: [id]
    );
  }


}

// Bug take 2 hour
/*Future<void> updateNote({required String title, required String description,required int id})async{
  Database db = await initDb();
  db.update(NOTE_TABLE,where: '$N_id=?', whereArgs: [id],
      {
        N_TITLE: title,
        N_DESC: description,
        CREATE_AT: DateTime.now().toString()
      }
  );
}*/
