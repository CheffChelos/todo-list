import 'package:flutter/material.dart';
import 'package:todolist/screen/categories_screen.dart';
import 'package:todolist/screen/home_screen.dart';
import 'package:todolist/screen/todo_by_category.dart';
import 'package:todolist/service/category_service.dart';

class DrawerNavigation extends StatefulWidget {
  @override
  _DrawerNavigationState createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  CategoryService categoryService = CategoryService();
  List<Widget> _categoryList = <Widget>[];

  @override
  void initState() {
    super.initState();
    getAllCategories();
  }

  getAllCategories() async {
    var categories = await categoryService.readCategory();
    categories.forEach((category) {
      setState(() {
        _categoryList.add(ListTile(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        TodoByCategory(category: category['name'])));
          },
          title: Text(category['name']),
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://st.depositphotos.com/2101611/3925/v/600/depositphotos_39258143-stock-illustration-businessman-avatar-profile-picture.jpg'),
              ),
              accountName: Text('Artur'),
              accountEmail: Text('archy1337@gmail.com'),
              decoration: BoxDecoration(color: Colors.blue),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => HomeScreen())),
            ),
            ListTile(
              leading: Icon(Icons.view_list),
              title: Text('Categories'),
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CategoriesScreen())),
            ),
            Column(
              children: _categoryList,
            )
          ],
        ),
      ),
    );
  }
}
