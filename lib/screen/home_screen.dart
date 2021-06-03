import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todolist/helpers/drawer_navigation.dart';
import 'package:todolist/models/todo.dart';
import 'package:todolist/screen/todo_screen.dart';
import 'package:todolist/service/todoService.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TodoService _todoService;
  List<Todo> _todoList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllTodos();
  }

  setColor(index) {
    DateTime dob = DateTime.parse(_todoList[index].todoDate);
    Duration dur = DateTime.now().difference(dob);
    if (dur.inDays > 0) {
      return Card(
        color: Colors.grey,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        child: ListTile(
          title: Text(_todoList[index].title),
          subtitle: Text(_todoList[index].description, maxLines: 8),
          trailing: Text(_todoList[index].todoDate),
        ),
      );
    } else {
      return Card(
        color: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        child: ListTile(
          title: Text(_todoList[index].title),
          subtitle: Text(_todoList[index].description, maxLines: 8),
          trailing: Text(_todoList[index].todoDate),
        ),
      );
    }
  }

  getAllTodos() async {
    _todoService = TodoService();
    var todos = await _todoService.readTodo();
    todos.forEach((todo) {
      setState(() {
        var model = Todo();
        model.id = todo['id'];
        model.title = todo['title'];
        model.description = todo['description'];
        model.category = todo['category'];
        model.todoDate = todo['todoDate'];
        model.isFinished = todo['isFinished'];
        _todoList.add(model);
      });
    });
  }

  Future<bool> _onBackPressed() async {
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Todo List'),
          ),
          drawer: DrawerNavigation(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => TodoScreen()));
            },
            child: Icon(Icons.add),
          ),
          body: ListView.builder(
              itemCount: _todoList.length,
              itemBuilder: (context, index) {
                return setColor(index);
              }),
        ),
        onWillPop: _onBackPressed);
  }
}
