import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'mainscreen.dart';
import 'registerscreen.dart';
import 'user.dart';

final TextEditingController emailEditingController =
    new TextEditingController();
final TextEditingController passwordEditingController =
    new TextEditingController();
bool isChecked = false;
String email = '';
String password = '';

void main() => runApp(LoginScreen());

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    this.loadpref();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        home: Scaffold(
            resizeToAvoidBottomPadding: false,
            body: Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[header(), loginCard()],
              ),
            )));
  }

  Widget header() {
    return Center(
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 30),
            alignment: Alignment.center,
            child: Image.asset(
              'assets/images/loginpage.png',
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 250),
              alignment: Alignment.center,
              child: Text(
                'Log In',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 35.0),
              )),
        ],
      ),
    );
  }

  Widget loginCard() {
    return Card(
        //color: Color.fromRGBO(0, 230, 230, 1),
        elevation: 0,
        child: Container(
          padding: EdgeInsets.fromLTRB(30, 15, 30, 30),
          child: Column(
            children: <Widget>[
              TextField(
                  controller: emailEditingController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    icon: Icon(
                      Icons.email,
                      color: Colors.teal,
                    ),
                  )),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: passwordEditingController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  icon: Icon(
                    Icons.lock,
                    color: Colors.teal,
                  ),
                ),
                obscureText: true,
              ),
              Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 10),
                        child: Container(
                          color: Colors.white,
                          height: 20,
                          width: 20,
                          child: Checkbox(
                            value: isChecked,
                            onChanged: (bool value) {
                              onRememberMe(value);
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 10),
                        child: Text('Remember Me ',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 40),
                          padding: EdgeInsets.only(top: 10),
                          width: 85,
                          height: 50,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0)),
                            textColor: Colors.white,
                            color: Colors.teal[300],
                            child:
                                Text('Login', style: TextStyle(fontSize: 18)),
                            onPressed: userLogin,
                          ),
                        ),
                      ),
                    ],
                  )),
              FlatButton(
                padding: EdgeInsets.only(top: 30),
                onPressed: () {},
                textColor: Colors.red[400],
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              FlatButton(
                onPressed: registerUser,
                textColor: Colors.red[400],
                child: Text(
                  'Register New Account',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ));
  }

  void userLogin() async {
    try {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: 'Logging in..');
      pr.show();
      String urlLogin =
          "https://saujanaeclipse.com/techGoods/php/login_user.php";
      String email = emailEditingController.text;
      String pass = passwordEditingController.text;
      http.post(urlLogin, body: {
        "email": email,
        "password": pass,
      }).then((res) {
        var string = res.body;
        List userdata = string.split(",");
        if (userdata[0] == "success") {
          User _user = new User(
              name: userdata[1],
              email: email,
              password: password,
              phone: userdata[3],
              credit: userdata[4],
              quantity: userdata[5]);

          pr.hide().then((isHidden) {
            print(isHidden);
          });
          Toast.show('Login successful', context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => MainScreen(
                        user: _user,
                      )));
        } else {
          pr.hide().then((isHidden) {
            print(isHidden);
          });
          Toast.show('Login failed', context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }).catchError((err) {
        print(err);
        pr.hide().then((isHidden) {
          print(isHidden);
        });
      });
    } on Exception catch (_) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void registerUser() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => RegisterScreen()));
  }

  void onRememberMe(bool value) {
    setState(() {
      isChecked = value;
      savePref(value);
    });
  }

  void savePref(bool value) async {
    email = emailEditingController.text;
    password = passwordEditingController.text;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      //if checkbox is clicked, preference is stored.
      if (_isEmailValid(email) && (password.length > 5)) {
        await prefs.setString('email', email);
        await prefs.setString('password', password);
        Toast.show("Preferences have been saved", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    } else {
      //if checkbox is not clicked, preference will be removed.
      await prefs.setString('email', '');
      await prefs.setString('password', '');
      setState(() {
        emailEditingController.text = '';
        passwordEditingController.text = '';
        isChecked = false;
        Toast.show("Preferences have been removed", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      });
    }
  }

  Future<void> loadpref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = (prefs.getString('email')) ?? '';
    password = (prefs.getString('password')) ?? '';
    if (email.length > 1) {
      emailEditingController.text = email;
      passwordEditingController.text = password;
      setState(() {
        isChecked = true;
      });
    } else {
      print('No preference');
      setState(() {
        isChecked = false;
      });
    }
  }

  bool _isEmailValid(String email) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }
}
