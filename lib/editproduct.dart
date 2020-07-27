import 'dart:convert';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'product.dart';
import 'user.dart';

class EditProduct extends StatefulWidget {
  final User user;
  final Product product;

  const EditProduct({Key key, this.user, this.product}) : super(key: key);

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  String server = "https://saujanaeclipse.com/techGoods";
  TextEditingController prnameEditingController = new TextEditingController();
  TextEditingController priceEditingController = new TextEditingController();
  TextEditingController qtyEditingController = new TextEditingController();
  TextEditingController typeEditingController = new TextEditingController();
  TextEditingController weigthEditingController = new TextEditingController();
  double screenHeight, screenWidth;
  final focus0 = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  File _image;
  bool _takepicture = true;
  bool _takepicturelocal = false;
  String selectedCategory;
  List<String> listCategory = [
    "Laptop",
    "Mobile Phone",
    "Tablet",
    "Computer Accessories",
    "Mobile Accessories",
    "Others",
  ];

  @override
  void initState() {
    super.initState();
    print("edit Product");
    prnameEditingController.text = widget.product.name;
    priceEditingController.text = widget.product.price;
    qtyEditingController.text = widget.product.quantity;
    typeEditingController.text = widget.product.category;
    weigthEditingController.text = widget.product.weight;
    selectedCategory = widget.product.category;
    print(weigthEditingController.text);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      //backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.teal[400],
        title: Text('Edit Your Product'),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            GestureDetector(
                onTap: _choose,
                child: Column(
                  children: [
                    Visibility(
                      visible: _takepicture,
                      child: Container(
                        height: screenHeight / 3,
                        width: screenWidth / 1.5,
                        child: CachedNetworkImage(
                          fit: BoxFit.fill,
                          imageUrl:
                              server + "/productimage/${widget.product.id}.jpg",
                          placeholder: (context, url) =>
                              new CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              new Icon(Icons.error),
                        ),
                      ),
                    ),
                    Visibility(
                        visible: _takepicturelocal,
                        child: Container(
                          height: screenHeight / 3,
                          width: screenWidth / 1.5,
                          decoration: BoxDecoration(
                            image: new DecorationImage(
                              colorFilter: new ColorFilter.mode(
                                  Colors.black.withOpacity(0.6),
                                  BlendMode.dstATop),
                              image: _image == null
                                  ? AssetImage('assets/images/phonecam.png')
                                  : FileImage(_image),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )),
                  ],
                )),
            SizedBox(height: 15),
            Container(
                width: screenWidth / 1,
                //height: screenHeight / 2,
                child: Card(
                    //color: Colors.black,
                    elevation: 1,
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Table(columnWidths: {
                              0: FractionColumnWidth(.4),
                              1: FractionColumnWidth(.6)
                            },
                                //defaultColumnWidth: FlexColumnWidth(1.0),
                                children: [
                                  TableRow(children: [
                                    TableCell(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 30,
                                          child: Text("ID",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ))),
                                    ),
                                    TableCell(
                                        child: Container(
                                      height: 30,
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 30,
                                          child: Text(
                                            " " + widget.product.id,
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          )),
                                    )),
                                  ]),
                                  TableRow(children: [
                                    TableCell(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 30,
                                          child: Text("Product Name",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ))),
                                    ),
                                    TableCell(
                                      child: Container(
                                        color: Colors.grey[50],
                                        margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                        height: 30,
                                        child: TextFormField(
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                            controller: prnameEditingController,
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.next,
                                            onFieldSubmitted: (v) {
                                              FocusScope.of(context)
                                                  .requestFocus(focus0);
                                            },
                                            decoration: new InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.all(5),
                                              fillColor: Colors.white,
                                              border: new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        5.0),
                                                borderSide: new BorderSide(),
                                              ),

                                              //fillColor: Colors.green
                                            )),
                                      ),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    TableCell(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 30,
                                          child: Text("Price (RM)",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black))),
                                    ),
                                    TableCell(
                                      child: Container(
                                        color: Colors.grey[50],
                                        margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                        height: 30,
                                        child: TextFormField(
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                            controller: priceEditingController,
                                            keyboardType: TextInputType.number,
                                            textInputAction:
                                                TextInputAction.next,
                                            focusNode: focus0,
                                            onFieldSubmitted: (v) {
                                              FocusScope.of(context)
                                                  .requestFocus(focus1);
                                            },
                                            decoration: new InputDecoration(
                                              fillColor: Colors.white,
                                              border: new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        5.0),
                                                borderSide: new BorderSide(),
                                              ),
                                              //fillColor: Colors.green
                                            )),
                                      ),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    TableCell(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 30,
                                          child: Text("Quantity",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black))),
                                    ),
                                    TableCell(
                                      child: Container(
                                        color: Colors.grey[50],
                                        margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                        height: 30,
                                        child: TextFormField(
                                            style:
                                                TextStyle(color: Colors.black),
                                            controller: qtyEditingController,
                                            keyboardType: TextInputType.number,
                                            textInputAction:
                                                TextInputAction.next,
                                            focusNode: focus1,
                                            onFieldSubmitted: (v) {
                                              FocusScope.of(context)
                                                  .requestFocus(focus2);
                                            },
                                            decoration: new InputDecoration(
                                              fillColor: Colors.white,
                                              border: new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        5.0),
                                                borderSide: new BorderSide(),
                                              ),
                                              //fillColor: Colors.green
                                            )),
                                      ),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    TableCell(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 30,
                                          child: Text("Category",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black))),
                                    ),
                                    TableCell(
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                        height: 40,
                                        child: Container(
                                          //color: Colors.black,
                                          height: 40,
                                          child: DropdownButton(
                                            //sorting dropdownoption

                                            hint: Text(
                                              'Category',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ), // Not necessary for Option 1
                                            value: selectedCategory,
                                            onChanged: (newValue) {
                                              setState(() {
                                                selectedCategory = newValue;
                                                print(selectedCategory);
                                              });
                                            },
                                            items: listCategory
                                                .map((selectedCategory) {
                                              return DropdownMenuItem(
                                                child: new Text(
                                                    selectedCategory,
                                                    style: TextStyle(
                                                        color: Colors.teal)),
                                                value: selectedCategory,
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    TableCell(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 30,
                                          child: Text("Weight (kg)",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black))),
                                    ),
                                    TableCell(
                                      child: Container(
                                        color: Colors.grey[50],
                                        margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                        height: 30,
                                        child: TextFormField(
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                            controller: weigthEditingController,
                                            keyboardType: TextInputType.number,
                                            textInputAction:
                                                TextInputAction.next,
                                            focusNode: focus2,
                                            onFieldSubmitted: (v) {
                                              FocusScope.of(context)
                                                  .requestFocus(focus3);
                                            },
                                            decoration: new InputDecoration(
                                              fillColor: Colors.white,
                                              border: new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        5.0),
                                                borderSide: new BorderSide(),
                                              ),
                                              //fillColor: Colors.green
                                            )),
                                      ),
                                    ),
                                  ]),
                                ]),
                            SizedBox(height: 30),
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              minWidth: screenWidth / 1.1,
                              height: 40,
                              child: Text(
                                'Update Product',
                                style: TextStyle(fontSize: 18),
                              ),
                              color: Colors.teal[400],
                              textColor: Colors.white,
                              elevation: 5,
                              onPressed: () => updateProductDialog(),
                            ),
                          ],
                        )))),
          ],
        )),
      ),
    );
  }

  void _choose() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
        source: ImageSource.camera, maxHeight: 800, maxWidth: 800);
    setState(() {
      _image = File(pickedFile.path);
    });
    _cropImage();
    setState(() {});
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: _image.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
              ]
            : [
                CropAspectRatioPreset.square,
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      _image = croppedFile;
      setState(() {
        _takepicture = false;
        _takepicturelocal = true;
      });
    }
  }

  updateProductDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Update Product Id " + widget.product.id,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content:
              new Text("Are you sure?", style: TextStyle(color: Colors.white)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                updateProduct();
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  updateProduct() {
    if (prnameEditingController.text.length < 4) {
      Toast.show("Please enter product name", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (qtyEditingController.text.length < 1) {
      Toast.show("Please enter product quantity", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (priceEditingController.text.length < 1) {
      Toast.show("Please enter product price", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (weigthEditingController.text.length < 1) {
      Toast.show("Please enter product weight", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    double price = double.parse(priceEditingController.text);
    double weigth = double.parse(weigthEditingController.text);

    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Updating product...");
    pr.show();
    String base64Image;

    if (_image != null) {
      base64Image = base64Encode(_image.readAsBytesSync());
      http.post("https://saujanaeclipse.com/techGoods/php/update_product.php",
          body: {
            "id": widget.product.id,
            "name": prnameEditingController.text,
            "quantity": qtyEditingController.text,
            "price": price.toStringAsFixed(2),
            "type": typeEditingController.text,
            "weight": weigth.toStringAsFixed(2),
            "encoded_string": base64Image,
          }).then((res) {
        print(res.body);
        pr.hide();
        if (res.body == "success") {
          Toast.show("Successfully updated", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          Navigator.of(context).pop();
        } else {
          Toast.show("Failed to update", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }).catchError((err) {
        print(err);
        pr.hide();
      });
    } else {
      http.post("https://saujanaeclipse.com/techGoods/php/update_product.php",
          body: {
            "id": widget.product.id,
            "name": prnameEditingController.text,
            "quantity": qtyEditingController.text,
            "price": price.toStringAsFixed(2),
            "category": typeEditingController.text,
            "weight": weigth.toStringAsFixed(2),
          }).then((res) {
        print(res.body);
        pr.hide();
        if (res.body == "success") {
          Toast.show("Successfully updated", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          Navigator.of(context).pop();
        } else {
          Toast.show("Failed to update", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }).catchError((err) {
        print(err);
        pr.hide();
      });
    }
  }
}
