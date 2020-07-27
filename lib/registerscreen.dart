import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:recase/recase.dart';
import 'package:email_validator/email_validator.dart';

import 'loginscreen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameEditingController = new TextEditingController();
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController phoneEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();
  GlobalKey<FormState> _key = new GlobalKey();
  //lidate = false;
  String phoneErrorMessage;
  bool validateMobile = false;
  bool emailcheck = false;
  String urlRegister =
      "http://saujanaeclipse.com/techGoods/php/register_user.php";

  double screenHeight;
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: Scaffold(
          resizeToAvoidBottomPadding: false,
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                header(),
                SizedBox(height: 10),
                registerationForm()
              ],
            ),
          )),
    );
  }

  Widget header() {
    return Center(
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 30),
            alignment: Alignment.center,
            child: Image.asset(
              'assets/images/headerimg.png',
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 250),
              alignment: Alignment.center,
              child: Text(
                'Register Now!',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 35.0),
              )),
        ],
      ),
    );
  }

  Widget registerCard() {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: <Widget>[
          Card(
            color: Colors.white,
            elevation: 10,
            child: Form(
              child: Container(
                padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                child: Form(
                  child: registerationForm(),
                  key: _key,
                  //autovalidate: autoValidate,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget registerationForm() {
    return Container(
      padding: EdgeInsets.fromLTRB(45, 10, 45, 10),
      child: Column(
        children: <Widget>[
          TextFormField(
            style: TextStyle(color: Colors.white),
            controller: nameEditingController,
            keyboardType: TextInputType.text,
            //validator: _validateName,
            decoration: InputDecoration(
              hintText: "Name",
              icon: Icon(
                Icons.person,
                color: Colors.teal,
              ),
            ),
          ),
          SizedBox(height: 8),
          TextFormField(
            style: TextStyle(color: Colors.white),
            controller: emailEditingController,
            keyboardType: TextInputType.emailAddress,
            //validator: _validateEmail,
            decoration: InputDecoration(
              hintText: "Email",
              icon: Icon(
                Icons.email,
                color: Colors.teal,
              ),
            ),
          ),
          SizedBox(height: 8),
          TextFormField(
            style: TextStyle(color: Colors.white),
            controller: phoneEditingController,
            keyboardType: TextInputType.phone,
            //validator: _validatePhoneNo,
            decoration: InputDecoration(
              hintText: "Phone number",
              icon: Icon(
                Icons.phone,
                color: Colors.teal,
              ),
            ),
          ),
          SizedBox(height: 8),
          TextFormField(
            style: TextStyle(color: Colors.white),
            controller: passwordEditingController,
            keyboardType: TextInputType.text,
            //validator: _validatePassword,
            decoration: InputDecoration(
              hintText: "Password",
              icon: Icon(
                Icons.lock,
                color: Colors.teal,
              ),
            ),
            obscureText: true,
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            margin: EdgeInsets.only(left: 185),
            width: 130,
            height: 40,
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
              textColor: Colors.white,
              color: Colors.teal[300],
              child: Text('Register', style: TextStyle(fontSize: 20)),
              onPressed: _confirmRegister,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Checkbox(
                  value: _isChecked,
                  onChanged: (bool value) {
                    _onChange(value);
                  },
                ),
                GestureDetector(
                  onTap: _showEULA,
                  child: Text('I Agree to Terms  ',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ),
              ]),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Already have an account?',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
              SizedBox(width: 10),
              GestureDetector(
                child: Text('Log In',
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => LoginScreen()));
                },
              )
            ],
          )
        ],
      ),
    );
  }

  void _confirmRegister() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Register Confirmation",
              style: TextStyle(color: Colors.red)),
          content: new Container(
            height: screenHeight / 10,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: new SingleChildScrollView(
                    child: RichText(
                        softWrap: true,
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              //fontWeight: FontWeight.w500,
                              fontSize: 20.0,
                            ),
                            text:
                                "Confirm registration? If you wish to cancel registration, click 'Cancel' to cancel registration. " //children: getSpan(),
                            )),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
                child: new Text(
                  "Yes",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  _onRegister();
                  Navigator.of(context).pop();
                }),
            new FlatButton(
              child: new Text("Cancel", style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                return;
              },
            )
          ],
        );
      },
    );
  }

  void _onRegister() {
    String name = nameEditingController.text;
    String email = emailEditingController.text;
    String phone = phoneEditingController.text;
    String password = passwordEditingController.text;
    ReCase rc = new ReCase(name);

    emailcheck = EmailValidator.validate(email);
    validateMobile(String phone) {
      String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
      RegExp regExp = new RegExp(pattern);
      if (phone.length == 0 || phone == null) {
        phoneErrorMessage = 'Please enter mobile number';
        return false;
      } else if (!regExp.hasMatch(phone)) {
        phoneErrorMessage = 'Please enter valid mobile number';
        return false;
      }
      return true;
    }

    if (name.length == 0) {
      Toast.show("Please Enter Your Name", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

      return;
    } else if (email.length == 0) {
      Toast.show("Please Enter Your Email", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

      return;
    } else if (emailcheck == false) {
      Toast.show("Invalid Email Format", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

      return;
    } else if (validateMobile(phone) == false) {
      Toast.show(phoneErrorMessage, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

      return;
    } else if (password.length == 0) {
      Toast.show("Please Enter Your Password", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

      return;
    } else if (!_isChecked) {
      Toast.show("Please Accept Terms", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

      return;
    }

    http.post(urlRegister, body: {
      "name": rc.titleCase.toString(),
      "email": email,
      "password": password,
      "phone": phone,
    }).then((res) {
      if (res.body == "success") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => LoginScreen()));
        Toast.show("Registration success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
        Toast.show("Registration failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _onChange(bool value) {
    setState(() {
      _isChecked = value;
      //savepref(value);
    });
  }

  void _showEULA() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("EULA"),
          content: new Container(
            height: screenHeight / 2,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: new SingleChildScrollView(
                    child: RichText(
                        softWrap: true,
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              //fontWeight: FontWeight.w500,
                              fontSize: 12.0,
                            ),
                            text:
                                "This End-User License Agreement is a legal agreement between you and SaujanaEclipse This EULA agreement governs your acquisition and use of our MyClass software (Software) directly from Slumberjer or indirectly through a SaunajaEclipse authorized reseller or distributor (a Reseller).Please read this EULA agreement carefully before completing the installation process and using the MyClass software. It provides a license to use the MyClass software and contains warranty information and liability disclaimers. If you register for a free trial of the MyClass software, this EULA agreement will also govern that trial. By clicking accept or installing and/or using the MyClass software, you are confirming your acceptance of the Software and agreeing to become bound by the terms of this EULA agreement. If you are entering into this EULA agreement on behalf of a company or other legal entity, you represent that you have the authority to bind such entity and its affiliates to these terms and conditions. If you do not have such authority or if you do not agree with the terms and conditions of this EULA agreement, do not install or use the Software, and you must not accept this EULA agreement.This EULA agreement shall apply only to the Software supplied by SaujanaEclipse herewith regardless of whether other software is referred to or described herein. The terms also apply to any SaujanaEclipse updates, supplements, Internet-based services, and support services for the Software, unless other terms accompany those items on delivery. If so, those terms apply. This EULA was created by EULA Template for MyClass. Slumberjer shall at all times retain ownership of the Software as originally downloaded by you and all subsequent downloads of the Software by you. The Software (and the copyright, and other intellectual property rights of whatever nature in the Software, including any modifications made thereto) are and shall remain the property of Saujanaelipse. Saujanaeclipse reserves the right to grant licences to use the Software to third parties"
                            //children: getSpan(),
                            )),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
