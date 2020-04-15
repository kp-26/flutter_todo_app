
class ToDoModel{
  int _id;
  String _title;
  String _description;
  String _createdDate;
  bool _isCompleted;

  ToDoModel(this._title, this._description, this._createdDate);

  ToDoModel.map(dynamic obj) {
    this._id = obj["id"];
    this._title = obj["title"];
    this._description = obj["description"];
    this._createdDate = obj["createdDate"];
    this._isCompleted = obj["isCompleted"];
  }

  int get id => _id;
  String get title => _title;
  String get description => _description;
  String get createdDate => _createdDate;
  bool get isCompleted => _isCompleted;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = _id;
    map["title"] = _title;
    map["description"] = _description;
    map["createdDate"] = _createdDate;
    map["isCompleted"] = _isCompleted;
    print("Item added SuccessFully");
    return map;
  }

  static ToDoModel toModel(Map map) {
    ToDoModel toDoModel = ToDoModel(map["title"], map["description"], map["createdDate"]);
    if  (map["isCompleted"] == 1) {
      toDoModel.isCompleted = true;
    } else {
      toDoModel.isCompleted = false;
    }
    toDoModel.setItemId(map["id"]);
    return toDoModel;
  }

  void setItemId(int id) {
    this._id = id;
  }

  set isCompleted(bool value) {
    _isCompleted = value;
  }


}