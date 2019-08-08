import 'package:flutter/material.dart';
import 'package:flutter_list_projects/models/item.dart';
import 'package:flutter_list_projects/widgets/empty_data.dart';
import 'package:flutter_list_projects/database/databaseClient.dart';
import 'package:flutter_list_projects/widgets/item_detail.dart';



class HomeController extends StatefulWidget {
  HomeController({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeControllerState createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {

  String newList;
  List<Item> items;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        brightness: Brightness.dark,
        actions: <Widget>[
          IconButton(
            onPressed: (() => addAnArticle(null)),
            icon: const Icon(Icons.add, color: Colors.white,),
          ),
        ],
      ),
      body: (items == null || items.length == 0)
        ? EmptyData()
          : ListView.builder(
        itemCount: items.length,
          itemBuilder: (context, i) {
          Item item = items[i];
          return ListTile(
            title: Text(item.title),
            trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  DatabaseClient().deleteItem(item.id, 'item').then((int) {
                    getData();
                  });
                }),
            leading: IconButton(
                icon: Icon(Icons.edit),
                onPressed: (() => addAnArticle(item))),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext buildContext) {
                    return ItemDetail(item);
                  }));
            },
          );
        }
      ),
    );
  }

  Future<Null> addAnArticle(Item item) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext buildContext) {
          return AlertDialog(
            title: Text("Ajouter une liste"),
            shape: RoundedRectangleBorder(),
            elevation: 20.0,
            content: TextField(
              decoration: InputDecoration(
                  labelText: "Liste : ",
                  hintText: (item == null) ? "Titre de ma nouvelle liste" : item.title,
              ),
              onChanged: (String str) {
                newList = str;
              },
            ),
            actions: <Widget>[
              FlatButton(onPressed: (() => Navigator.pop(buildContext)), child: Text("Annuler", style : TextStyle(color: Colors.red[900]))),
              FlatButton(onPressed: () {
                if (newList != null) {
                  if (item == null) {
                    item = new Item();
                    Map<String, dynamic> map = {"title" : newList};
                    item.fromMap(map);
                  } else {
                    item.title = newList;
                  }
                  DatabaseClient().upsertItem(item).then((i) => getData());
                  newList = null;
                }
                Navigator.pop(buildContext);
              }, child: Text("Valider"),
              ),
            ],
          );
        }
    );
  }

  void getData() {
    DatabaseClient().getAllItems().then((items) {
      setState(() {
        this.items = items;
      });
    });
  }
}