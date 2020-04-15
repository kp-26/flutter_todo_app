import 'package:flutter/material.dart';
import 'package:fluttertodoapp/Utils/DatabaseHelper.dart';
import 'package:fluttertodoapp/Utils/ToDoModel.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class AddEditToDoItem extends StatefulWidget {
  ToDoModel item;
  AddEditToDoItem.withId(this.item);
  AddEditToDoItem();

  @override
  _AddEditToDoItemState createState() => _AddEditToDoItemState();
}

class _AddEditToDoItemState extends State<AddEditToDoItem> {
  final format = DateFormat("yyyy-MM-dd");
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  fillDataWhileEditItem(){
    if(widget.item != null){
      this._titleController.text = widget.item.title;
      this._descriptionController.text = widget.item.description;
      print(DateFormat("yyyy-MM-dd").format(DateTime.parse(widget.item.createdDate)));
      this._dateController.text = DateFormat("yyyy-MM-dd").format(DateTime.parse(widget.item.createdDate));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.fillDataWhileEditItem();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item != null ? "Edit ToDo Item" : "Add ToDo Item"),
      ),
      body: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(bottom: 24),
                        child: TextFormField(
                          controller: _titleController,
                          keyboardType: TextInputType.text,
                          validator: (value){
                            if (value.isEmpty) {
                              return 'Please enter title';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Title",
                            hintText: "Enter Title",
                          ),
                        )),
                    Padding(
                        padding: EdgeInsets.only(bottom: 24),
                        child: TextFormField(
                          controller: _descriptionController,
                          keyboardType: TextInputType.text,
                          validator: (value){
                            if (value.isEmpty) {
                              return 'Please enter description';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Description",
                            hintText: "Enter Description",
                          ),
                        )),
                    Padding(
                        padding: EdgeInsets.only(bottom: 24),
                        child: DateTimeField(
                          controller: _dateController,
                          format: format,
                          validator: (value){
                            if (value.toString().isEmpty || value == null) {
                              return 'Please select task date';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Task Date",
                            hintText: "Select Task Date",
                          ),
                          onShowPicker: (context, currentValue) {
                            return showDatePicker(
                                context: context,
                                firstDate: DateTime(1900),
                                initialDate: currentValue ?? DateTime.now(),
                                lastDate: DateTime(2100)
                            );
                          },
                        )),
                    RaisedButton(
                        color: Theme.of(context).primaryColor,
                        onPressed: () async {
                          if(_formKey.currentState.validate()){
                            Map data = {"title" : _titleController.text, "description" : _descriptionController.text, "createdDate": _dateController.text.toString()};
                            ToDoModel model = ToDoModel.toModel(data);
                            print("Data : " + model.toMap().toString());

                            if(widget.item != null){
                              await DatabaseHelper().updateItem(model, widget.item.id);
                            }else{
                              await DatabaseHelper().saveItem(model);
                            }
                            _titleController.clear();
                            _descriptionController.clear();
                            _dateController.clear();
                            Navigator.pop(context);
                          }else{
                            print("data missing");
                          }
                        },
                        child: Text("Save",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18)))
                  ],
                ))),
      ),
    );
  }

}
