import 'package:basic_note_app/db_helper.dart';
import 'package:sqflite/sqflite.dart';

class NoteModel{

  String noteTitle;
  String noteDescription;
  String createAt;
  int? noteId;

  NoteModel({
     required this.noteTitle,
    required this.noteDescription,
   required this.createAt,
    this.noteId});


  Map<String,dynamic> toMap(){
    return {
      NoteDatabase.N_id : noteId,
      NoteDatabase.N_TITLE : noteTitle,
      NoteDatabase.N_DESC : noteDescription,
      NoteDatabase.CREATE_AT : createAt,
    };
  }



  factory NoteModel.fromMap(Map<String, dynamic> map){
    return NoteModel(noteTitle: map[NoteDatabase.N_TITLE],
        noteDescription: map[NoteDatabase.N_DESC],
    noteId: map[NoteDatabase.N_id],
    createAt: map[NoteDatabase.CREATE_AT]);
  }


}




//static const String NOTE_TABLE = 'note_table';
//   static const String N_id = 'n_id';
//   static const String N_TITLE = 'n_title';
//   static const String N_DESC = 'n_desc';
//   static const String CREATE_AT = 'create_at';