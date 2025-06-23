import 'dart:async';

import 'package:basic_note_app/note_model.dart';
import 'package:flutter/cupertino.dart';
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


  Future<void> addNote(NoteModel noteModel) async {
    Database db = await openDb();
    await db.insert(NOTE_TABLE,noteModel.toMap());
  }

  Future<List<NoteModel>> getAllNote()async{
    Database db = await initDb();
    List<NoteModel> allNotes = [];
    List<Map<String,dynamic>> notes = await db.query(NOTE_TABLE);

    for(Map<String, dynamic> map in notes){
      NoteModel eachNote = NoteModel.fromMap(map);
      allNotes.add(eachNote);
    }
    return allNotes;
  }

  Future<void> deleteNote({required int id})async{
    Database db = await initDb();
   await db.delete(NOTE_TABLE,where: '$N_id=?',whereArgs: [id]);
  }


 Future<void> updateNote(NoteModel noteModel)async{
    Database db = await initDb();

    await db.update(NOTE_TABLE,noteModel.toMap(),
        where: '$N_id=?',
        whereArgs: [noteModel.noteId]
            );
  }


}

// Bug take 2 hour i forget to follow parameter passing
// order i must pass positional args first then where and whereArgs
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
