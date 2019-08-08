
class Item {

  int id;
  String title;

  Item();

  /// convert the item from a map
  void fromMap(Map<String, dynamic> map) {
    this.id = map["id"];
    this.title = map["title"];
  }

  /// convert the item to a map, to send it to storage
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "title" : this.title
    };
    if (id != null) {
      map["id"] = this.id;
    }
    return map;
  }
}