
class Article {

  int id;
  String title;
  int item;
  String price;
  String shop;
  String image;

  Article();

  void fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.title = map['title'];
    this.item = map['item'];
    this.price = map['price'];
    this.shop = map['shop'];
    this.image = map['image'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "title" : this.title,
      "item" : this.item,
      "price" : this.price,
      "shop" : this.shop,
      "image" : this.image,
    };
    if (id != null) {
      map["id"] = this.id;
    }
    return map;
  }



}