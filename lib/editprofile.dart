import 'dart:convert';
import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:recase/recase.dart';
import 'package:toast/toast.dart';
import 'package:image_picker/image_picker.dart';

import 'profilescreen.dart';
import 'user.dart';

class EditProfile extends StatefulWidget {
  final User user;

  const EditProfile({Key key, this.user}) : super(key: key);
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  double screenHeight, screenWidth;
  TextEditingController nameEditingController = new TextEditingController();
  TextEditingController phoneEditingController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    nameEditingController.text = widget.user.name;
    phoneEditingController.text = widget.user.phone;
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Edit Profile'),
          backgroundColor: Colors.teal[400],
          leading: FlatButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => ProfileScreen(
                              user: widget.user,
                            )));
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
        ),
        resizeToAvoidBottomPadding: false,
        body: Container(
          child: Column(children: <Widget>[
            GestureDetector(
              onTap: _takePhoto,
              child: Container(
                  height: screenHeight / 2,
                  width: screenWidth,
                  child:
                      Image(image: AssetImage('assets/images/newphoto.png'))),
            ),
            Container(
              margin: EdgeInsets.only(left: 5, right: 10, top: 2),
              height: screenHeight / 14,
              width: screenWidth / 1.3,
              decoration: BoxDecoration(
                  color: Colors.teal[100],
                  borderRadius: BorderRadius.circular(28)),
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: TextField(
                    controller: nameEditingController,
                    decoration: InputDecoration(

                        //icon: Icon(Icons.search),
                        border: InputBorder.none)),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 5, right: 10, top: 15),
              height: screenHeight / 14,
              width: screenWidth / 1.3,
              decoration: BoxDecoration(
                  color: Colors.teal[100],
                  borderRadius: BorderRadius.circular(28)),
              child: Padding(
                padding: const EdgeInsets.only(top: 3, left: 20),
                child: TextField(
                    controller: phoneEditingController,
                    decoration: InputDecoration(

                        //icon: Icon(Icons.search),
                        border: InputBorder.none)),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 50),
              width: screenWidth / 2,
              height: screenHeight / 16,
              child: MaterialButton(
                color: Colors.teal[300],
                onPressed: editConfirmation,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Text(
                  'Update',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }

  void _takePhoto() async {
    if (widget.user.email == 'unregistered') {
      Toast.show('Please register a new account first', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    File _image;
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      _image = File(pickedFile.path);
    });
    if (_image == null) {
      Toast.show('Please take a photo', context);
    } else {
      String base64Image = base64Encode(_image.readAsBytesSync());
      http.post('https://saujanaeclipse.com/techGoods/php/upload_image.php',
          body: {
            "encoded_string": base64Image,
            "email": widget.user.email
          }).then((res) {
        if (res.body == 'success') {
          setState(() {
            DefaultCacheManager manager = new DefaultCacheManager();
            manager.emptyCache();
          });
          Toast.show('Successfully changed photo', context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        } else {
          Toast.show('Failed to upload photo', context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }).catchError((err) {
        print(err);
      });
    }
  }

  editProfile(String name, String phone) {
    if (name == "" || name == null) {
      Toast.show("Please enter your name", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (phone == "" || phone == null) {
      Toast.show("Please enter your phone number", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    ReCase rc = new ReCase(name);
    print(rc.titleCase.toString());
    http.post("https://saujanaeclipse.com/techGoods/php/update_profile.php",
        body: {
          "email": widget.user.email,
          "name": rc.titleCase.toString(),
          "phone": phone,
        }).then((res) {
      if (res.body == "success") {
        print('in success editing');

        setState(() {
          widget.user.name = rc.titleCase;
          widget.user.phone = phone;
        });
        Toast.show("Successfully updated", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.of(context).pop();
        return;
      } else {}
    }).catchError((err) {
      print(err);
    });
  }

  void editConfirmation() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              //backgroundColor: Colors.black38,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              content: Text(
                'Update your profile?',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                    child: new Text(
                      "Yes",
                      style: TextStyle(
                        color: Colors.teal,
                      ),
                    ),
                    onPressed: () => editProfile(
                        nameEditingController.text.toString(),
                        phoneEditingController.text.toString())),
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
}
