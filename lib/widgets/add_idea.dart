import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_list_projects/enumPackage/text_field_type.dart';
import 'package:flutter_list_projects/models/article.dart';
import 'package:flutter_list_projects/database/databaseClient.dart';
import 'package:image_picker/image_picker.dart';


class AddArticle extends StatefulWidget {

  int id;
  AddArticle(int id) {
    this.id = id;
  }

  @override
  _AddArticleState createState() {
    return _AddArticleState();
  }

}

class _AddArticleState extends State<AddArticle> {

  String image;
  String title;
  String price;
  String shop;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter"),
        actions: <Widget>[
          IconButton(
            onPressed: validateIdea,
            icon: const Icon(Icons.check, color: Colors.white,),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(25.0),
        child: Column(
          children: <Widget>[
          Text(
            'Article à ajouter',
            textScaleFactor: 1.4,
            style: TextStyle(
                color: Colors.blueGrey
            ),
          ),
            Card(
              elevation: 9.0,
              margin: EdgeInsets.all(4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  (image == null)
                      ? Image.asset('assets/question.jpg')
                      : Image.file(new File(image)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(icon: Icon(Icons.camera_enhance), onPressed: () => {
                        getImage(ImageSource.camera),
                      }),
                      IconButton(icon: Icon(Icons.photo_library), onPressed: () => {
                        getImage(ImageSource.gallery)
                      })
                    ],
                  ),
                  textField(TextFieldType.title, "Article"),
                  textField(TextFieldType.price, "Prix"),
                  textField(TextFieldType.shop, "Magasin"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  TextField textField(TextFieldType type, String label) {
    return TextField(
      textInputAction: TextInputAction.newline,
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        contentPadding: EdgeInsets.all(8.0),
        labelText: label,
      ),
      onChanged: (String string) {
        switch (type) {
          case TextFieldType.title:
            title = string;
            break;
          case TextFieldType.price:
            price = string;
            break;
          case TextFieldType.shop:
            shop = string;
            break;
        }
      },
    );
  }

  void validateIdea() {
    if (title != null) {
      Map<String, dynamic> map = {
      "title" : title, "item" : widget.id};
      if (price != null) {
        map["price"] = price;
      }
      if (shop != null) {
        map["shop"] = shop;
      }
      if (image != null) {
        map["image"] = image;
      }
      Article article = new Article();
      article.fromMap(map);
      DatabaseClient().upsertIdea(article).then((value) {
        image = null;
        title = null;
        price = null;
        shop = null;
        Navigator.pop(context);
      });
    }
  }

  Future getImage(ImageSource source) async {
    var newImage = await ImagePicker.pickImage(source: source);
    setState(() {
      image = newImage.path;
    });
  }
}

