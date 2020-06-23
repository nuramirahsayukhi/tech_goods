
import 'dart:convert';
import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:image_picker/image_picker.dart';

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
        resizeToAvoidBottomPadding: false,
        body: Container(
          child: Column(children: <Widget>[
            GestureDetector(
              onTap: _takePhoto,
              child: Container(
                  height: screenHeight / 1.8,
                  width: screenWidth,
                  child:
                      Image(image: AssetImage('assets/images/newphoto.png'))),
            ),
            Container(
              margin: EdgeInsets.only(left: 5, right: 10, top: 10),
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
                onPressed: () {},
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Text(
                  'Save',
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
    if(_image == null ) {
      Toast.show('Please take a photo', context);
    } else {
      String base64Image = base64Encode(_image.readAsBytesSync());
      http.post('https://saujanaeclipse.com/techGoods/php/upload_image.php',body: {
        "encoded_string": base64Image,
        "email":widget.user.email
      }).then((res){
        if(res.body == 'success') {
           setState(() {
            DefaultCacheManager manager = new DefaultCacheManager();
            manager.emptyCache();
          });
          Toast.show('Successfully changed photo', context,duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        } else {
           Toast.show('Failed to upload photo', context,duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }  }).catchError((err) {
        print(err);
      });
    }
  }
}
