import 'package:flutter/material.dart';
import 'package:flutter_list_projects/models/item.dart';
import 'package:flutter_list_projects/models/article.dart';
import 'package:flutter_list_projects/widgets/empty_data.dart';
import 'package:flutter_list_projects/widgets/add_idea.dart';
import 'package:flutter_list_projects/database/databaseClient.dart';
import 'dart:io';



class ItemDetail extends StatefulWidget {

  Item item;

  ItemDetail(Item item) {
    this.item = item;
  }

  @override
  _ItemDetailState createState() {
    return _ItemDetailState();
  }

}

class _ItemDetailState extends State<ItemDetail> {

  List<Article> articles;

  @override
  void initState() {
    super.initState();
    DatabaseClient().getAlIdeas(widget.item.id).then((list) {
      setState(() {
        articles = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.title),
        actions: <Widget>[
          IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
              return AddArticle(widget.item.id);
            })).then((value) {
              DatabaseClient().getAlIdeas(widget.item.id).then((list) {
                setState(() {
                  articles = list;
                });
              });
            }),
            icon: const Icon(Icons.add, color: Colors.white,),
          ),
        ],
      ),
      body: (articles == null || articles.length == 0)
          ? new EmptyData()
          : GridView.builder(
          itemCount: articles.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
          itemBuilder: (context, i) {
            Article article = articles[i];
            return Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(article.title, textScaleFactor: 1.5,),
                  Container(
                    height: MediaQuery.of(context).size.height / 4,
                    child: (article.image == null)
                        ? Image.asset('assets/question.jpg',)
                        : Image.file(File(article.image)),
                  ),
                  Text((article.price == null) ? "Aucun prix renseigné" : "Prix : ${article.price}",),
                  Text((article.shop == null) ? "Aucun magasin renseigné" : "Magasin : ${article.shop}"),
                  ],
                  ),
              );
            })
          );
  }

}