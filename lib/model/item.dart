class Item {
  String title;
  int id;

  Item(this.title, [this.id]);

  Map<String, dynamic> toMap() {
    return {'title': title};
  }
}
