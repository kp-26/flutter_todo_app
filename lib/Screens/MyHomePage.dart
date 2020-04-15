import 'package:flutter/material.dart';
import 'package:fluttertodoapp/Screens/AddEditToDoItem.dart';
import 'package:fluttertodoapp/Utils/DatabaseHelper.dart';
import 'package:fluttertodoapp/Utils/ToDoModel.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {

  List<ToDoModel> todoList;
  IconData iconData = Icons.check_circle_outline;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.fillData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ToDo List"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (_) => AddEditToDoItem()))
                    .then((onValue){
                  this.fillData();
                });
              })
        ],
      ),
      body: this.getList(),
    );
  }

  fillData() async {
    var result = await DatabaseHelper().getAllItem();
    setState(()  {
      this.todoList = result;
    });
  }

  getList() {
    if (this.todoList != null && this.todoList.length > 0) {
      return ListView.builder(
          itemCount: this.todoList.length,
          itemBuilder: (context, index) {
            return Padding(
                padding: EdgeInsets.only(
                    left: 10, right: 10, top: index == 0 ? 10 : 5),
                child: Slidable(
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.symmetric(vertical: 2),
                                    child: Row(
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () async {
                                            await DatabaseHelper().updateItemStatus(this.todoList.elementAt(index).id, !this.todoList.elementAt(index).isCompleted);
                                            this.fillData();
                                          },
                                          child: Icon(this.todoList.elementAt(index).isCompleted == false ? Icons.check_circle_outline : Icons.check_circle),
                                        ),
                                        SizedBox(width: 10),
                                        Text(this.todoList
                                            .elementAt(index)
                                            .title, style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                      ],
                                    )),
                                SizedBox(height: 5),
                                Text(this.todoList
                                    .elementAt(index)
                                    .createdDate, style: TextStyle(fontSize: 13,
                                    fontWeight: FontWeight.normal)),
                              ],
                            ),
                            Padding(padding: EdgeInsets.only(left: 34),
                              child: Text(this.todoList
                                  .elementAt(index)
                                  .description, style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.normal)),
                            ),
                          ],
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(left: 44),
                      child: Divider(height: 0, thickness: 1))
                    ],
                  ),
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.15,
                  secondaryActions: <Widget>[
                    Padding(padding: EdgeInsets.symmetric(vertical: 2),
                        child: IconSlideAction(
                            caption: 'Edit',
                            color: Colors.black45,
                            icon: Icons.edit,
                            onTap: () async {
                              print("Edit");
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (_) =>
                                  AddEditToDoItem.withId(
                                      this.todoList.elementAt(index)))).then((value){
                                this.fillData();
                              });
                            }
                        )),
                    Padding(padding: EdgeInsets.symmetric(vertical: 2),
                        child: IconSlideAction(
                            caption: 'Delete',
                            color: Colors.red,
                            icon: Icons.delete,
                            onTap: () async {
                              print("Delete");
                              print("ID : " + this.todoList
                                  .elementAt(index)
                                  .id
                                  .toString());
                              await DatabaseHelper().deleteItem(this.todoList
                                  .elementAt(index)
                                  .id);
                              this.fillData();
                            }
                        ))
                  ],
                ));
          });
    }
    return Center(
        child: Text("No Todo Item available", style: TextStyle(fontSize: 17)));
  }
}