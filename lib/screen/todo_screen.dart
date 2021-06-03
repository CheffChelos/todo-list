import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todolist/models/todo.dart';
import 'package:todolist/screen/home_screen.dart';
import 'package:todolist/service/category_service.dart';
import 'package:intl/intl.dart';
import 'package:todolist/service/todoService.dart';

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  var _titleController = TextEditingController();
  var _descriptionController = TextEditingController();
  var _dateController = TextEditingController();
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  var _selectedValue;
  var _todo = Todo();
  var _todoService = TodoService();

  var _categories = List<DropdownMenuItem>();
  DateTime _dateTime = DateTime.now();

  _selectDate(BuildContext context) async {
    var pickDate = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (pickDate != null) {
      setState(() {
        _dateTime = pickDate;
        _dateController.text = DateFormat('yyyy-MM-dd').format(pickDate);
      });
    }
  }

  Future<bool> _onBackPressed() async {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      SystemNavigator.pop();
    }
  }

  _showSnackBar(message) {
    var snackBar = SnackBar(content: message);
    _globalKey.currentState.showSnackBar(snackBar);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadCategories();
  }

  void _loadCategories() async {
    var _categoryService = CategoryService();
    var categories = await _categoryService.readCategory();
    categories.forEach((category) {
      setState(() {
        _categories.add(DropdownMenuItem(
          child: Text(category['name']),
          value: category['name'],
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            key: _globalKey,
            appBar: AppBar(
              title: Text('Create Todo'),
            ),
            body: Container(
              padding: EdgeInsets.all(32.0),
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      hintText: 'Write Title',
                    ),
                    maxLines: 1,
                    minLines: 1,
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      hintText: 'Write Note',
                    ),
                    maxLines: 20,
                    minLines: 4,
                  ),
                  TextField(
                    controller: _dateController,
                    decoration: InputDecoration(
                        labelText: 'Date',
                        hintText: 'Pick a Date',
                        prefixIcon: InkWell(
                          onTap: () {
                            _selectDate(context);
                          },
                          child: Icon(Icons.calendar_today),
                        )),
                  ),
                  DropdownButtonFormField(
                    value: _selectedValue,
                    items: _categories,
                    hint: Text('Category'),
                    onChanged: (value) {
                      setState(() {
                        _selectedValue = value;
                      });
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      _todo.title = _titleController.text;
                      _todo.description = _descriptionController.text;
                      _todo.category = _selectedValue.toString();
                      _todo.todoDate = _dateController.text;
                      _todo.isFinished = 0;
                      var result = _todoService.saveTodo(_todo);
                      print(result);
                      _showSnackBar(Text('Added'));
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) => HomeScreen()))
                          .then((value) => setState(() => {}));
                    },
                    child: Text('Save'),
                  )
                ],
              ),
            )),
        onWillPop: _onBackPressed);
  }
}
