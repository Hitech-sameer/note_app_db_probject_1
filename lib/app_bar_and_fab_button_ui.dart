import 'package:flutter/material.dart';

PreferredSizeWidget noteAppBar(){
  return AppBar(
    title: Text('NotePro',style: TextStyle(
      fontWeight: FontWeight.bold
    ),
    ),
    titleSpacing: 0,
    backgroundColor: Colors.deepOrange,
    foregroundColor: Colors.white,


leadingWidth: 36,

    leading: Icon(Icons.menu),


    actions: [Container(
      width: 40,height: 40,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 2
        ),
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
        image:DecorationImage(image: AssetImage('assets/images/profile_pic.jpg'),
          fit: BoxFit.cover,
          alignment: Alignment.topCenter

             )
           )
        )],
    actionsPadding: EdgeInsets.only(right: 8),
  );
}

Widget addButton({required void Function() onClick }){
  return FloatingActionButton(onPressed: onClick,
  backgroundColor: Colors.deepOrange,
  foregroundColor: Colors.white,
  child: Icon(Icons.add));
}

