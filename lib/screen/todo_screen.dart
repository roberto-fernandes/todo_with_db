import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo_with_db/controller/todo_controller.dart';
import 'package:todo_with_db/model/item.dart';

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To do'),
      ),
      body: FutureBuilder(
        future: getItems(),
        builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
          List<Item> data = asyncSnapshot.data;
          print(data);
          return ListView.builder(
            itemCount: data != null ? data.length : 0,
            itemBuilder: (context, index) {
              Item item = data[index];
              return Dismissible(
                key: UniqueKey(),
                onDismissed: (direction) {
                  removeItem(item);
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${item.title} dismissed'),
                    ),
                  );
                },
                background: Container(
                  color: Colors.red,
                ),
                child: Card(
                  elevation: 5,
                  child: Container(
                    width: double.infinity,
                    color: index % 2 == 0
                        ? Colors.orange[900]
                        : Colors.orange[600],
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 22),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Future futureUpdateItem = _asyncInputDialog(
                                  context,
                                  todoTitle: item.title);
                              futureUpdateItem
                                  .then((value) => {
                                        if (value != null)
                                          {
                                            setState(() {
                                              updateItem(item, value);
                                            })
                                          }
                                      })
                                  .catchError((error) => print(error));
                            },
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Future futureItem = _asyncInputDialog(context);
          futureItem
              .then((value) => {
                    if (value != null)
                      {
                        setState(() {
                          addItem(value);
                        })
                      }
                  })
              .catchError((error) => print(error));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future _asyncInputDialog(BuildContext context,
      {String todoTitle = ''}) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Enter your to-do'),
            content: Row(
              children: [
                Expanded(
                  child: TextField(
                    autofocus: true,
                    controller: TextEditingController()..text = todoTitle,
                    decoration: InputDecoration(
                        labelText: 'To-do: ', hintText: 'Eg. buy milk'),
                    onChanged: (value) {
                      todoTitle = value;
                    },
                  ),
                ),
              ],
            ),
            actions: [
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  print('FlatButton $todoTitle');
                  Navigator.of(context).pop(todoTitle);
                },
              ),
            ],
          );
        });
  }
}
