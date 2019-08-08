import 'package:flutter/material.dart';
import 'package:flutter_list_projects/widgets/home_controller.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mes idées d\'applications',
        theme: ThemeData(
            primarySwatch: Colors.blueGrey
        ),
      home: HomeController(title: "Mes idées d\'applications"),
    );
  }
}


