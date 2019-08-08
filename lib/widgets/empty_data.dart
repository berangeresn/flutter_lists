import 'package:flutter/material.dart';

class EmptyData extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Aucune donnée n'est disponible",
      textScaleFactor: 2.0,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.blueGrey,
        fontStyle: FontStyle.italic,
      ),),
    );
  }

}