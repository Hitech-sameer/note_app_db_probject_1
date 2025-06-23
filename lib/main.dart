import 'package:basic_note_app/home_page.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(NoteApp());
}

class NoteApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    home:HomePage() ,
      debugShowCheckedModeBanner: false,
    );
  }
}
