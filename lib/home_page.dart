import 'package:basic_note_app/app_bar_and_fab_button_ui.dart';
import 'package:basic_note_app/db_helper.dart';
import 'package:basic_note_app/note_model.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePage();
  }
}

class _HomePage extends State<HomePage> {

  NoteDatabase db = NoteDatabase.getInstance();
  List<NoteModel> listOfNote = []; // Top level declaration so it can access

  void openBottomSheet({bool isUpdating = false, int? noteId,
     String? previousTitle, String? previousDescription}
      ) {
    var titleController = TextEditingController(text: previousTitle ?? '');
    var descController = TextEditingController(text: previousDescription??'');

    showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(22),
          topRight: Radius.circular(22),
        ),
      ),
      context: context,
      builder: (_) {
        return Container(
          height: 700,
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.deepOrange,
              width: 2,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(22),
              topRight: Radius.circular(22),
            ),
          ),
          child: Column(
            spacing: 14,
            children: [
              Text(
                isUpdating ? 'Update Note' : 'Add Note',
                style: TextStyle(
                  color: Colors.deepOrangeAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  errorStyle: TextStyle(color: Colors.black45),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: Colors.deepOrangeAccent,
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(
                      color: Colors.deepOrangeAccent,
                      width: 3,
                    ),
                  ),
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Colors.deepOrangeAccent),
                  hintText: 'Enter note title here..',
                  hintStyle: TextStyle(color: Color(0xFFF88663)),
                ),
              ),
              TextField(
                controller: descController,
                minLines: 3,
                maxLines: 3,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: Colors.deepOrangeAccent,
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(
                      color: Colors.deepOrangeAccent,
                      width: 3,
                    ),
                  ),
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.deepOrangeAccent),
                  alignLabelWithHint: true,
                  hintText: 'Enter note description here..',
                  hintStyle: TextStyle(color: Color(0xFFF88663)),
                ),
              ),
              Row(
                spacing: 16,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        Colors.deepOrangeAccent,
                      ),
                      foregroundColor: WidgetStateProperty.all(Colors.white),
                    ),
                    onPressed: () async {
                      if (titleController.text.isNotEmpty || descController.text.isNotEmpty) {

                        if (isUpdating) {
                          await db.updateNote(NoteModel(
                            noteId: noteId,
                            noteTitle: titleController.text,
                            noteDescription: descController.text,
                            createAt: DateTime.now().microsecondsSinceEpoch.toString()
                          ));

                        } else {
                          await db.addNote(NoteModel(noteTitle: titleController.text,
                              noteDescription: descController.text,
                              createAt: DateTime.now().millisecondsSinceEpoch.toString())

                          );
                        }

                        fetchNote();
                        Navigator.pop(context);
                        titleController.clear();
                        descController.clear();
                      }else{
                        titleController.text = 'required';
                      }

                    },
                    child: Text(isUpdating?'Update':'Save'),
                  ),

                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      titleController.clear();
                      descController.clear();
                    },
                    style: ButtonStyle(
                      foregroundColor: WidgetStateProperty.all(
                        Colors.deepOrangeAccent,
                      ),
                      side: WidgetStateProperty.all(
                        BorderSide(color: Colors.deepOrangeAccent, width: 2),
                      ),
                    ),

                    child: Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchNote();
  }

  void fetchNote() async {
    listOfNote = await db.getAllNote();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: noteAppBar(),
      floatingActionButton: addButton(
        onClick: () {
          openBottomSheet();
        },
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: listOfNote.length,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.only(bottom: 8),
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 1),
                  offset: Offset(0, 3),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        listOfNote[index].noteTitle,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        listOfNote[index].noteDescription,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 14, color: Colors.black45),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    openBottomSheet(previousTitle: listOfNote[index].noteTitle,
                        previousDescription:listOfNote[index].noteDescription,
                    isUpdating: true,
                    noteId: listOfNote[index].noteId);

                  },
                  icon: Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () {
                    db.deleteNote(id: listOfNote[index].noteId!);
                    fetchNote();
                  },
                  icon: Icon(Icons.delete),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
