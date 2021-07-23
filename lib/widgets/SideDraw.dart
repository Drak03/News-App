import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_assignment/Screens/NewsScreens/CategoryScreen.dart';
import 'package:news_assignment/googleSignIn.dart';
import 'package:provider/provider.dart';
import '/modal/categoryModal.dart';

class DrawNavigation extends StatelessWidget {
  final userdetails = FirebaseAuth.instance.currentUser;
  final List<Category> category = [
    Category(categoryName: "business", categoryIcon: Icons.work),
    Category(categoryName: "entertainment", categoryIcon: Icons.movie),
    Category(categoryName: "general", categoryIcon: Icons.people),
    Category(categoryName: "health", categoryIcon: Icons.health_and_safety),
    Category(categoryName: "science", categoryIcon: Icons.science),
    Category(categoryName: "sports", categoryIcon: Icons.sports_basketball),
    Category(categoryName: "technology", categoryIcon: Icons.devices),
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Material(
      color: Colors.red[900],
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPictureSize: Size.square(100),
            decoration: BoxDecoration(color: Colors.grey[800]),
            currentAccountPicture: InkWell(
              onTap: () async {
                await showDialog(
                    context: context, builder: (btx) => imageView());
              },
              child: CircleAvatar(
                  backgroundImage: NetworkImage(userdetails.photoURL)),
            ),
            accountName: Text(
              userdetails.displayName,
            ),
            accountEmail: Text(
              userdetails.email,
            ),
          ),
          Flexible(
            flex: 3,
            child: ListView.builder(
              itemCount: category.length,
              itemBuilder: (btx, index) => InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (btx) => CategoryNews(
                            category: category[index].categoryName),
                      ));
                },
                child: ListTile(
                  leading: Icon(
                    category[index].categoryIcon,
                    color: Colors.white,
                  ),
                  title: Text(
                    category[index].categoryName,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Flexible(
              flex: 1,
              child: InkWell(
                onTap: () {
                  final provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.logout();
                },
                child: ListTile(
                    trailing: Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Log-Out",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    )),
              ))
        ],
      ),
    ));
  }

  Widget imageView() {
    return Dialog(
      child: Container(
        width: 200,
        height: 300,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(userdetails.photoURL), fit: BoxFit.cover)),
      ),
    );
  }
}
