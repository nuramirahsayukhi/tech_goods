import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'editprofile.dart';
import 'loginscreen.dart';
import 'mainscreen.dart';
import 'registerscreen.dart';
import 'storecredit.dart';
import 'user.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  const ProfileScreen({Key key, this.user}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;
  double screenHeight, screenWidth;
  String server = "https://saujanaeclipse.com/techGoods";
  @override
  void initState() {
    super.initState();
    loadCredit();
  }

  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.teal[400],
          elevation: 0.5,
          leading: FlatButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => MainScreen(
                              user: widget.user,
                            )));
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (widget.user.email == "unregistered@techgoods.com") {
              Toast.show("Please register to use this function", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
              return;
            } else if (widget.user.email == "admin@techgoods.com") {
              Toast.show("Admin Mode", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
              return;
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => EditProfile(
                            user: widget.user,
                          )));
            }
          },
          child: Icon(Icons.edit, color: Colors.white),
          elevation: 20.0,
          backgroundColor: Colors.teal[700],
        ),
        body: RefreshIndicator(
          key: refreshKey,
          color: Color.fromRGBO(101, 255, 218, 50),
          onRefresh: () async {
            await refreshList();
          },
          child: ListView(children: <Widget>[
            Container(
              //color: Colors.grey[200],
              child: Column(
                children: <Widget>[
                  profileCard(),
                  Container(
                      padding: EdgeInsets.only(left: 30, top: 10),
                      width: screenWidth,
                      height: screenHeight / 2.8,
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            onTap: changePassword,
                            leading: Icon(
                              Icons.lock,
                              color: Colors.red[200],
                            ),
                            title: Text('Change Password',
                                style: TextStyle(color: Colors.black)),
                          ),
                          ListTile(
                            onTap: buyStoreCredit,
                            leading: Icon(Icons.monetization_on,
                                color: Colors.green[300]),
                            title: Text('Buy Store Credits',
                                style: TextStyle(color: Colors.black)),
                          ),
                          ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          RegisterScreen()));
                            },
                            leading: Icon(
                              Icons.account_box,
                              color: Colors.teal[200],
                            ),
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
                            leading: Icon(
                              Icons.exit_to_app,
                              color: Colors.blue[300],
                            ),
                            title: Text('Log In Page',
                                style: TextStyle(color: Colors.black)),
                          )
                        ],
                      )),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    //_getLocation();
    loadCredit();

    return null;
  }

  Widget profileCard() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.teal[400],
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
              height: screenHeight / 4.8,
              width: screenWidth / 3.2,
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                //border: Border.all(color: Colors.black),
              ),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: server + "/profileimages/${widget.user.email}.jpg?",
                placeholder: (context, url) => new SizedBox(
                    height: 10.0,
                    width: 10.0,
                    child: CircularProgressIndicator()),
                errorWidget: (context, url, error) =>
                    new Icon(MdiIcons.cameraIris, size: 64.0),
              ),
            ),
            Text(widget.user.name,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22)),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(widget.user.email,
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(widget.user.phone,
                    style: TextStyle(color: Colors.white, fontSize: 18))),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text("RM" + widget.user.credit,
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  void buyStoreCredit() {
    if (widget.user.email == "unregistered@techgoods.com") {
      Toast.show("Please register to use this function", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
      return;
    } else if (widget.user.email == "admin@techgoods.com") {
      Toast.show("Admin Mode", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
      return;
    }
    TextEditingController creditController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              //backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: new Text(
                "Buy Store Credits",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              content: new TextField(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  controller: creditController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Enter RM',
                    icon: Icon(
                      Icons.attach_money,
                      color: Colors.green[200],
                    ),
                  )),
              actions: <Widget>[
                new FlatButton(
                    child: new Text(
                      "Yes",
                      style: TextStyle(
                        color: Colors.teal,
                      ),
                    ),
                    onPressed: () =>
                        _buyCredit(creditController.text.toString())),
                new FlatButton(
                  child: new Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.teal,
                    ),
                  ),
                  onPressed: () => {Navigator.of(context).pop()},
                ),
              ]);
        });
  }

  _buyCredit(String cr) {
    print("RM " + cr);
    if (cr.length <= 0) {
      Toast.show("Please enter correct amount", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        //backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Buy store credits RM ' + cr,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        content: new Text(
          'Are you sure?',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                Navigator.of(context).pop(false);
                confirmCredit(cr);
              },
              child: Text(
                "Confirm",
                style: TextStyle(
                  color: Colors.teal,
                ),
              )),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                Navigator.of(context).pop(false);
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.teal,
                ),
              )),
        ],
      ),
    );
  }

  loadCredit() {
    print(widget.user.credit);
    String urlLoadCredit = server + "/php/load_credit.php";
    http.post(urlLoadCredit, body: {
      "email": widget.user.email,
    }).then((res) {
      if (res.body == "nodata") {
      } else {
        widget.user.credit = res.body;
      }
    }).catchError((err) {
      print(err);
    });
  }

  Future<void> confirmCredit(String cr) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => StoreCreditScreen(
                  user: widget.user,
                  val: cr,
                )));
    loadCredit();
  }

  void changePassword() {
    if (widget.user.email == "unregistered@techgoods.com") {
      Toast.show("Please register to use this function", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
      return;
    }
    TextEditingController passController = TextEditingController();
    TextEditingController pass2Controller = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              //backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: new Text(
                "Change your password?",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              content: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      controller: passController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Old Password',
                        icon: Icon(
                          Icons.lock,
                          color: Colors.red[200],
                        ),
                      )),
                  TextField(
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      obscureText: true,
                      controller: pass2Controller,
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        icon: Icon(
                          Icons.lock,
                          color: Colors.red[200],
                        ),
                      )),
                ],
              ),
              actions: <Widget>[
                new FlatButton(
                    child: new Text(
                      "Yes",
                      style: TextStyle(
                        color: Colors.teal,
                      ),
                    ),
                    onPressed: () => updatePassword(
                        passController.text, pass2Controller.text)),
                new FlatButton(
                  child: new Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.teal,
                    ),
                  ),
                  onPressed: () => {Navigator.of(context).pop()},
                ),
              ]);
        });
  }

  updatePassword(String pass1, String pass2) {
    if (pass1 == "" || pass2 == "") {
      Toast.show("Please enter your password", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    http.post(server + "/php/update_profile.php", body: {
      "email": widget.user.email,
      "oldpassword": pass1,
      "newpassword": pass2,
    }).then((res) {
      if (res.body == "success") {
        print('in success');
        setState(() {
          widget.user.password = pass2;
        });
        Toast.show("Success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.of(context).pop();
        return;
      } else {}
    }).catchError((err) {
      print(err);
    });
  }
}
