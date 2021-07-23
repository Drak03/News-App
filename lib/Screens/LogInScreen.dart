import 'package:flutter/material.dart';
import 'package:news_assignment/googleSignIn.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[800],
      body: Column(
        children: [
          Container(
            height: 500,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("asset/news_img.webp"),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "LogIn with you're Google Account to continue.",
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(width: 200)
              ],
            ),
          ),
          SizedBox(height: 30),
          Container(
            width: 300,
            height: 60,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colors.grey[800],
                  ),
                ),
                onPressed: () {
                  final provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.googleLogIn();
                },
                label: Text(
                  "Sign-up with Google",
                  style: TextStyle(fontSize: 20),
                ),
                icon: Icon(Icons.login),
              ),
            ),
          )
        ],
      ),
    );
  }
}
