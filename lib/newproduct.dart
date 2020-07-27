import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:image_cropper/image_cropper.dart';

class NewProduct extends StatefulWidget {
  @override
  _NewProductState createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  String server = "https://saujanaeclipse.com/techGoods";
  double screenHeight, screenWidth;
  File _image;
  var _tapPosition;
  String _scanBarcode = 'Click here to scan';
  String pathAsset = 'assets/images/phonecam.png';
  TextEditingController prnameEditingController = new TextEditingController();
  TextEditingController brandEditingController = new TextEditingController();
  TextEditingController modelEditingController = new TextEditingController();
  TextEditingController priceEditingController = new TextEditingController();
  TextEditingController qtyEditingController = new TextEditingController();
  TextEditingController typeEditingController = new TextEditingController();
  TextEditingController weigthEditingController = new TextEditingController();
  final focus0 = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final focus4 = FocusNode();
  final focus5 = FocusNode();
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
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      //backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.teal[400],
        title: Text('New Product'),
      ),
      body: Center(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 6),
                GestureDetector(
                    onTap: () => {_choose()},
                    child: Container(
                      height: screenHeight / 3,
                      width: screenWidth / 1.8,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: _image == null
                              ? AssetImage(pathAsset)
                              : FileImage(_image),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(
                          width: 3.0,
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(
                                5.0) //         <--- border radius here
                            ),
                      ),
                    )),
                SizedBox(height: 5),
                Text("Click the image above to upload picture",
                    style: TextStyle(fontSize: 14.0, color: Colors.black)),
                SizedBox(height: 5),
                Container(
                    width: screenWidth / 1,
                    //height: screenHeight / 2,
                    child: Card(
                        //color: Colors.black,
                        elevation: 6,
                        child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: <Widget>[
                                Table(
                                    defaultColumnWidth: FlexColumnWidth(1.0),
                                    children: [
                                      TableRow(children: [
                                        TableCell(
                                          child: Container(
                                              alignment: Alignment.centerLeft,
                                              height: 30,
                                              child: Text("Product ID",
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
                                              child: GestureDetector(
                                                onTap: _showPopupMenu,
                                                onTapDown: _storePosition,
                                                child: Text(_scanBarcode,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    )),
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
                                            margin:
                                                EdgeInsets.fromLTRB(2, 1, 5, 1),
                                            height: 30,
                                            child: TextFormField(
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                controller:
                                                    prnameEditingController,
                                                keyboardType:
                                                    TextInputType.text,
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
                                                  border:
                                                      new OutlineInputBorder(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(5.0),
                                                    borderSide:
                                                        new BorderSide(),
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
                                              child: Text("Brand",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black))),
                                        ),
                                        TableCell(
                                          child: Container(
                                            color: Colors.grey[50],
                                            margin:
                                                EdgeInsets.fromLTRB(2, 1, 5, 1),
                                            height: 30,
                                            child: TextFormField(
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                controller:
                                                    brandEditingController,
                                                keyboardType:
                                                    TextInputType.text,
                                                textInputAction:
                                                    TextInputAction.next,
                                                focusNode: focus0,
                                                onFieldSubmitted: (v) {
                                                  FocusScope.of(context)
                                                      .requestFocus(focus1);
                                                },
                                                decoration: new InputDecoration(
                                                  fillColor: Colors.black,
                                                  border:
                                                      new OutlineInputBorder(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(5.0),
                                                    borderSide:
                                                        new BorderSide(),
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
                                              child: Text("Model",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black))),
                                        ),
                                        TableCell(
                                          child: Container(
                                            color: Colors.grey[50],
                                            margin:
                                                EdgeInsets.fromLTRB(2, 1, 5, 1),
                                            height: 30,
                                            child: TextFormField(
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                controller:
                                                    modelEditingController,
                                                keyboardType:
                                                    TextInputType.text,
                                                textInputAction:
                                                    TextInputAction.next,
                                                focusNode: focus1,
                                                onFieldSubmitted: (v) {
                                                  FocusScope.of(context)
                                                      .requestFocus(focus2);
                                                },
                                                decoration: new InputDecoration(
                                                  fillColor: Colors.black,
                                                  border:
                                                      new OutlineInputBorder(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(5.0),
                                                    borderSide:
                                                        new BorderSide(),
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black))),
                                        ),
                                        TableCell(
                                          child: Container(
                                            color: Colors.grey[50],
                                            margin:
                                                EdgeInsets.fromLTRB(2, 1, 5, 1),
                                            height: 30,
                                            child: TextFormField(
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                controller:
                                                    priceEditingController,
                                                keyboardType:
                                                    TextInputType.number,
                                                textInputAction:
                                                    TextInputAction.next,
                                                focusNode: focus2,
                                                onFieldSubmitted: (v) {
                                                  FocusScope.of(context)
                                                      .requestFocus(focus3);
                                                },
                                                decoration: new InputDecoration(
                                                  fillColor: Colors.black,
                                                  border:
                                                      new OutlineInputBorder(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(5.0),
                                                    borderSide:
                                                        new BorderSide(),
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black))),
                                        ),
                                        TableCell(
                                          child: Container(
                                            color: Colors.grey[50],
                                            margin:
                                                EdgeInsets.fromLTRB(2, 1, 5, 1),
                                            height: 30,
                                            child: TextFormField(
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                controller:
                                                    qtyEditingController,
                                                keyboardType:
                                                    TextInputType.number,
                                                textInputAction:
                                                    TextInputAction.next,
                                                focusNode: focus3,
                                                onFieldSubmitted: (v) {
                                                  FocusScope.of(context)
                                                      .requestFocus(focus4);
                                                },
                                                decoration: new InputDecoration(
                                                  fillColor: Colors.white,
                                                  border:
                                                      new OutlineInputBorder(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(5.0),
                                                    borderSide:
                                                        new BorderSide(),
                                                  ),
                                                  //fillColor: Colors.green
                                                )),
                                          ),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        TableCell(
                                          child: Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  1, 1, 0, 1),
                                              //alignment: Alignment.centerLeft,
                                              height: 40,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8),
                                                child: Text("Category",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black)),
                                              )),
                                        ),
                                        TableCell(
                                          child: Container(
                                            margin:
                                                EdgeInsets.fromLTRB(5, 1, 0, 1),
                                            height: 40,
                                            child: Container(
                                              height: 40,
                                              child: DropdownButton(
                                                //sorting dropdownoption
                                                dropdownColor: Colors.white,
                                                hint: Text(
                                                  'Category',
                                                  style: TextStyle(
                                                      color: Colors.black),
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
                                                            color:
                                                                Colors.teal)),
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black))),
                                        ),
                                        TableCell(
                                          child: Container(
                                            color: Colors.grey[50],
                                            margin:
                                                EdgeInsets.fromLTRB(2, 1, 5, 3),
                                            height: 30,
                                            child: TextFormField(
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                controller:
                                                    weigthEditingController,
                                                keyboardType:
                                                    TextInputType.number,
                                                textInputAction:
                                                    TextInputAction.next,
                                                focusNode: focus4,
                                                onFieldSubmitted: (v) {
                                                  FocusScope.of(context)
                                                      .requestFocus(focus5);
                                                },
                                                decoration: new InputDecoration(
                                                  fillColor: Colors.white,
                                                  border:
                                                      new OutlineInputBorder(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(5.0),
                                                    borderSide:
                                                        new BorderSide(),
                                                  ),
                                                  //fillColor: Colors.green
                                                )),
                                          ),
                                        ),
                                      ]),
                                    ]),
                                SizedBox(height: 3),
                                MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  minWidth: screenWidth / 1.5,
                                  height: 40,
                                  child: Text(
                                    'Insert New Product',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  color: Colors.teal,
                                  textColor: Colors.black,
                                  elevation: 5,
                                  onPressed: _insertNewProduct,
                                ),
                              ],
                            )))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _choose() async {
    //File _image;
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
                CropAspectRatioPreset.original,
              ]
            : [
                CropAspectRatioPreset.original,
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
      setState(() {});
    }
  }

  void _onGetId() {
    scanBarcodeNormal();
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      if (barcodeScanRes == "-1") {
        _scanBarcode = "click here to scan";
      } else {
        _scanBarcode = barcodeScanRes;
      }
    });
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  void _insertNewProduct() {
    if (_scanBarcode == "click here to scan") {
      Toast.show("Please scan product id", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (_image == null) {
      Toast.show("Please take product photo", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Insert New Product " + prnameEditingController.text,
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
                insertProduct();
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

  insertProduct() {
    double price = double.parse(priceEditingController.text);
    double weigth = double.parse(weigthEditingController.text);

    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Inserting new product...");
    pr.show();
    String base64Image = base64Encode(_image.readAsBytesSync());

    http.post(server + "/php/insert_product.php", body: {
      "prid": _scanBarcode,
      "prname": prnameEditingController.text,
      "prbrand": brandEditingController.text,
      "prmodel": modelEditingController.text,
      "quantity": qtyEditingController.text,
      "price": price.toStringAsFixed(2),
      "category": selectedCategory,
      "weight": weigth.toStringAsFixed(2),
      "encoded_string": base64Image,
    }).then((res) {
      print(res.body);
      pr.hide();
      if (res.body == "found") {
        Toast.show("Product id already in database", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return;
      }
      if (res.body == "success") {
        Toast.show("Insert success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.of(context).pop();
      } else {
        Toast.show("Insert failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
      pr.hide();
    });
  }

  _showPopupMenu() async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

    await showMenu(
      context: context,
      color: Colors.black,
      position: RelativeRect.fromRect(
          _tapPosition & Size(40, 40), // smaller rect, the touch area
          Offset.zero & overlay.size // Bigger rect, the entire screen
          ),
      items: [
        //onLongPress: () => _showPopupMenu(), //onLongTapCard(index),

        PopupMenuItem(
          child: GestureDetector(
              onTap: () => {Navigator.of(context).pop(), _onGetId()},
              child: Text(
                "Scan Barcode",
                style: TextStyle(
                  color: Colors.teal,
                ),
              )),
        ),
        PopupMenuItem(
          child: GestureDetector(
              onTap: () => {Navigator.of(context).pop(), scanQR()},
              child: Text(
                "Scan QR Code",
                style: TextStyle(color: Colors.teal),
              )),
        ),
        PopupMenuItem(
          child: GestureDetector(
              onTap: () => {Navigator.of(context).pop(), _manCode()},
              child: Text(
                "Manual",
                style: TextStyle(color: Colors.teal),
              )),
        ),
      ],
      elevation: 8.0,
    );
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  _manCode() {
    TextEditingController pridedtctrl = new TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Enter Product ID ",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: new Container(
            margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
            height: 30,
            child: TextFormField(
                style: TextStyle(
                  color: Colors.white,
                ),
                controller: pridedtctrl,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: new InputDecoration(
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0),
                    borderSide: new BorderSide(),
                  ),
                  //fillColor: Colors.green
                )),
          ),
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
                setState(() {
                  if (pridedtctrl.text.length > 3) {
                    _scanBarcode = pridedtctrl.text;
                  } else {}
                });
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
}
