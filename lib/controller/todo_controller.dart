import 'package:todo_with_db/database/db_helper.dart';
import 'package:todo_with_db/model/item.dart';

Future<List<Item>> getItems() async {
  List<Item> _items = await DBHelper.getItemsFromDb();
  return [..._items];
}

addItem(String title) {
  print('insert $title');
  DBHelper.insert(Item(title));
}

updateItem(Item item, String newTitle) {
  DBHelper.updateItem(item, Item(newTitle));
}

removeItem(Item item) {
  DBHelper.deleteItem(item);
}
