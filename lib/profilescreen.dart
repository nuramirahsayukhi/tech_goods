import 'package:flutter/material.dart';

import 'editprofile.dart';
import 'loginscreen.dart';
import 'registerscreen.dart';
import 'user.dart';


class ProfileScreen extends StatefulWidget {
  final User user;

  const ProfileScreen({Key key, this.user}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  double screenHeight, screenWidth;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: Scaffold(
        /*appBar: AppBar(
          backgroundColor: Colors.teal[900],
          title: Text(
            'My Profile ',
            style: TextStyle(color: Colors.white),
          ),
          elevation: 0.5,
          leading: FlatButton(
              onPressed: () {
                Navigator.pop(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => MainScreen()));
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
        ),*/
        endDrawer: new Drawer(
          child: new ListView(
            children: <Widget>[
              InkWell(
                  onTap: () {},
                  child: ListTile(
                      title: Text(
                        'Log In Page',
                        style: TextStyle(fontSize: 16),
                      ),
                      leading: Icon(Icons.person, color: Colors.teal[400]))),
              InkWell(
                  onTap: () {

                  },
                  child: ListTile(
                      title: Text(
                        'Registeration Page',
                        style: TextStyle(fontSize: 16),
                      ),
                      leading: Icon(Icons.accessibility_new,
                          color: Colors.blue[400]))),
              InkWell(
                  onTap: () {},
                  child: ListTile(
                      title: Text(
                        'Buy Store Credit',
                        style: TextStyle(fontSize: 16),
                      ),
                      leading:
                          Icon(Icons.credit_card, color: Colors.red[400]))),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
             Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      EditProfile(
                                        user: widget.user,
                                      )));
          },
          child: Icon(Icons.edit, color: Colors.white),
          elevation: 20.0,
          backgroundColor: Colors.teal[700],
        ),
        body: Container(
          color: Colors.grey[200],
          child: Column(
            children: <Widget>[
              profileCard(),
              /*Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Align(
                    alignment: Alignment.center,
                    child: Text(widget.user.name,
                        style: TextStyle(color: Colors.white, fontSize: 25))),
              ),*/
              //infoCard()

              Container(
                  padding: EdgeInsets.only(left: 30,top:10),
                  width: screenWidth,
                  height: screenHeight / 2.8,
                  color: Colors.grey[200],
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.lock),
                        title: Text('Change Password',
                            style: TextStyle(color: Colors.black)),
                      ),
                      ListTile(onTap: () {},
                        leading: Icon(Icons.monetization_on),
                        title: Text('Buy Store Credits',
                            style: TextStyle(color: Colors.black)),
                      ),
                      ListTile( onTap: () {
                         Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      RegisterScreen()));
                      },
                        leading: Icon(Icons.account_box),
                        title: Text('Register New Account',
                            style: TextStyle(color: Colors.black)),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      LoginScreen()));
                        },
                        leading: Icon(Icons.exit_to_app),
                        title: Text('Log In Page',
                            style: TextStyle(color: Colors.black)),
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget profileCard() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.teal[300],
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25))),
      width: screenWidth,
      height: screenHeight / 1.8,
      child: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 12.0),
            Container(
                margin: const EdgeInsets.fromLTRB(10, 30, 10, 20),
                child: CircleAvatar(
                  radius: 90.0,
                  backgroundImage:
                      NetworkImage('https://i.mydramalist.com/eRpddc.jpg'),
                )),
            Text(widget.user.name,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22)),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(widget.user.email,
                  style: TextStyle(color: Colors.black, fontSize: 18)),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(widget.user.phone,
                    style: TextStyle(color: Colors.black, fontSize: 18))),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text("RM" + widget.user.credit,
                  style: TextStyle(color: Colors.black, fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

 
}
