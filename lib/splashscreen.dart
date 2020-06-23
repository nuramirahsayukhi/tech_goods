import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

import 'mainscreen.dart';
import 'user.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double screenHeight;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      title: 'Material App',
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 50, right: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset('assets/images/techgoodsicon.png'),
                  ProgressIndicator(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProgressIndicator extends StatefulWidget {
  @override
  _ProgressIndicatorState createState() => new _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<ProgressIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          //updating states
          if (animation.value > 0.99) {
            controller.stop();
            loadPref(this.context);
            // Navigator.push(
            //   context,
            //  MaterialPageRoute(
            //     builder: (BuildContext context) => LoginScreen()));
          }
        });
      });
    controller.repeat();
  }

  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        new Container(
          child: CircularProgressIndicator(
            value: animation.value,
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.teal),
          ),
        ),
      ],
    );
  }

  void loadPref(BuildContext ctx) async {
    print('Inside loadpref()');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email') ?? '');
    String pass = (prefs.getString('password') ?? '');
    print("Splash:Preference" + email + "/" + pass);
    if (email.length > 5) {
      //login with email and password
      loginUser(email, pass, ctx);
    } else {
      loginUser("unregistered", "123456789", ctx);
    }
  }
  void loginUser(String email, String pass, BuildContext ctx) {
   
    http.post("https://saujanaeclipse.com/techGoods/php/login_user.php", body: {
      "email": email,
      "password": pass,
    })
        //.timeout(const Duration(seconds: 4))
        .then((res) {
      print(res.body);
      var string = res.body;
      List userdata = string.split(",");
      if (userdata[0] == "success") {
        User _user = new User(
            name: userdata[1],
            email: email,
            password: pass,
            phone: userdata[3],
            credit: userdata[4],
            quantity: userdata[5]);
   
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MainScreen(
                      user: _user,
                    )));
      } else {
        Toast.show("Failed to login with stored credential. Login as unregistered account.", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        loginUser("unregistered@techgoods.com","123456",ctx);
       }
    }).catchError((err) {
      print(err);
   
    });
  }
}

