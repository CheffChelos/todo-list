import 'package:flutter/material.dart';
import 'package:todolist/models/category.dart';
import 'package:todolist/screen/home_screen.dart';
import 'package:todolist/service/category_service.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  var _category = Category();
  var _categoryController = TextEditingController();
  var _descriptionController = TextEditingController();
  var _updateCategoryController = TextEditingController();
  var _updateDescriptionController = TextEditingController();
  var categoryService = CategoryService();
  List<Category> _categoryList = [];
  var category;
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getAllCategories();
  }

  getAllCategories() async {
    var categories = await categoryService.readCategory();
    categories.forEach((category) {
      setState(() {
        var model = Category();
        model.id = category['id'];
        model.name = category['name'];
        model.description = category['description'];
        _categoryList.add(model);
      });
    });
  }

  _editCategory(BuildContext context, categoryId) async {
    category = await categoryService.readCategoryByID(categoryId);
    setState(() {
      _updateCategoryController.text = category[0]['name'] ?? 'No Name';
      _updateDescriptionController.text =
          category[0]['description'] ?? 'No Description';
    });
    _editFromDialog(context);
  }

  _showFromDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            title: Text('Categories Form'),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  _category.name = _categoryController.text;
                  _category.description = _descriptionController.text;
                  var result = await categoryService.saveCategory(_category);
                  print(result);
                  _categoryList.clear();
                  getAllCategories();
                  Navigator.pop(context);
                  _showSnackBar(Text('Added'));
                  _categoryController.clear();
                  _descriptionController.clear();
                },
                child: Text('Add'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showSnackBar(Text('Canceled'));
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red, // background
                  onPrimary: Colors.white,
                ),
                child: Text('Cancel'),
              ),
            ],
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Write A Category',
                      labelText: 'Category',
                    ),
                    minLines: 1,
                    maxLines: 1,
                    controller: _categoryController,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Write a Description',
                      labelText: 'Description',
                    ),
                    minLines: 2,
                    maxLines: 20,
                    controller: _descriptionController,
                  ),
                ],
              ),
            ),
          );
        });
  }

  _deleteFromDialog(BuildContext context, categoryId) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            title: Text('Are You Sure ?'),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  var result = await categoryService.deleteCategory(categoryId);
                  print(result);
                  _categoryList.clear();
                  getAllCategories();
                  _showSnackBar(Text('Deleted'));
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red, // background
                  onPrimary: Colors.white,
                ),
                child: Text('Delete'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showSnackBar(Text('Canceled'));
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green, // background
                  onPrimary: Colors.white,
                ),
                child: Text('Cancel'),
              ),
            ],
          );
        });
  }

  _showSnackBar(message) {
    var snackBar = SnackBar(content: message);
    _globalKey.currentState.showSnackBar(snackBar);
  }

  _editFromDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            title: Text('Update Categories Form'),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  _category.id = category[0]['id'];
                  _category.name = _updateCategoryController.text;
                  _category.description = _updateDescriptionController.text;
                  var result = await categoryService.updateCategory(_category);
                  _updateCategoryController.clear();
                  _updateDescriptionController.clear();
                  print('Update Result : $result');
                  Navigator.pop(context);
                  _categoryList.clear();
                  getAllCategories();
                  _showSnackBar(Text('Updated'));
                },
                child: Text('Update'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showSnackBar(Text('Canceled'));
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red, // background
                  onPrimary: Colors.white,
                ),
                child: Text('Cancel'),
              ),
            ],
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Write A Category',
                      labelText: 'Category',
                    ),
                    minLines: 1,
                    maxLines: 1,
                    controller: _updateCategoryController,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Write a Description',
                      labelText: 'Description',
                    ),
                    minLines: 2,
                    maxLines: 20,
                    controller: _updateDescriptionController,
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text('Categories'),
        leading: TextButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => HomeScreen()));
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFromDialog(context),
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
          itemCount: _categoryList.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                leading: IconButton(
                  onPressed: () {
                    _editCategory(context, _categoryList[index].id);
                  },
                  icon: Icon(Icons.edit),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_categoryList[index].name),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    _deleteFromDialog(context, _categoryList[index].id);
                  },
                ),
              ),
            );
          }),
    );
  }
}
