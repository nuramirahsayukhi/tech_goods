import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:http/http.dart' as http;
import 'package:tech_goods/editproduct.dart';
import 'package:toast/toast.dart';
import 'constants.dart';
import 'mainscreen.dart';
import 'newproduct.dart';
import 'product.dart';
//import 'productdetails.dart';
import 'user.dart';

class AdminProduct extends StatefulWidget {
  final User user;

  const AdminProduct({Key key, this.user}) : super(key: key);
  @override
  _AdminProductState createState() => _AdminProductState();
}

class _AdminProductState extends State<AdminProduct> {
  TextEditingController searchProductController = new TextEditingController();
  List productInfo; //creating list of products
  double screenHeight, screenWidth;
  String currentCategory = "Recent"; //the initial category is set to Recent
  bool _visible = false;
  String cartquantity = "0"; //the initial cart quantity is set to 0
  //bool _isAdmin = false;
  @override
  void initState() {
    super.initState();
    loadData();
    //_loadCartQuantity();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (productInfo == null) {
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Material App',
          home: Scaffold(
              //backgroundColor: Colors.black,
              body: Container(
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: Text('Loading...'),
                )
              ],
            )),
          )));
    } else {
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Material App',
          home: Scaffold(
            //backgroundColor: Colors.black,
            resizeToAvoidBottomPadding: false,
            appBar: AppBar(
              backgroundColor: Colors.teal[400],
              elevation: 0.5,
              title: Container(
                padding: EdgeInsets.only(left: 80),
                child:
                    Text("Product List", style: TextStyle(color: Colors.white)),
              ),
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
              actions: <Widget>[
                IconButton(
                  icon: _visible
                      ? new Icon(Icons.expand_more)
                      : new Icon(Icons.expand_less),
                  onPressed: () {
                    setState(() {
                      if (_visible) {
                        _visible = false;
                      } else {
                        _visible = true;
                      }
                    });
                  },
                )
              ],
            ),
            body: Container(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 4),
                  searchProd(),
                  SizedBox(
                    height: 5.0,
                  ),
                  categoryText(),
                  categoryIcon(),
                  productList()
                ],
              ),
            ),
            floatingActionButton: SpeedDial(
              backgroundColor: Colors.teal,
              animatedIcon: AnimatedIcons.menu_close,
              children: [
                SpeedDialChild(
                    backgroundColor: Colors.red,
                    child: Icon(Icons.new_releases),
                    label: "New Product",
                    labelBackgroundColor: Colors.white,
                    onTap: createNewProduct),
                SpeedDialChild(
                    backgroundColor: Colors.black,
                    child: Icon(MdiIcons.barcodeScan),
                    label: "Scan Product",
                    labelBackgroundColor: Colors.white, //_changeLocality()
                    onTap: null),
              ],
            ),
          ));
    }
  }

  Future<void> createNewProduct() async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => NewProduct()));
    loadData();
  }

  Widget categoryText() {
    return Visibility(
      visible: _visible,
      child: Container(
        padding: EdgeInsets.only(left: 15),
        child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Categories",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )),
      ),
    );
  }

  //widget to display image carousel
  Widget imageCarousel() {
    return Container(
      child: SizedBox(
          height: 200.0,
          width: 500.0,
          child: Carousel(
            dotBgColor: Colors.grey,
            dotColor: Colors.teal[300],
            indicatorBgPadding: 0.5,
            images: [
              ExactAssetImage("assets/images/miphone.jpg"),
              ExactAssetImage("assets/images/surface.jpg"),
              ExactAssetImage("assets/images/tablets.jpg")
            ],
          )),
    );
  }

  //widget for buttons to go to products based on the categories
  Widget categoryIcon() {
    return Container(
        padding: EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Visibility(
              visible: _visible,
              child: Card(
                elevation: 0,
                color: Colors.white,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                      FlatButton(
                        onPressed: () => sortItem('Recent'),
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.update,
                              color: Colors.green,
                            ),
                            Text(
                              "Recent",
                              style: TextStyle(color: Colors.black),
                            )
                          ],
                        ),
                      ),
                      FlatButton(
                        onPressed: () => sortItem('Laptop'),
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.laptop_mac,
                              color: Colors.green,
                            ),
                            Text(
                              "Laptop",
                              style: TextStyle(color: Colors.black),
                            )
                          ],
                        ),
                      ),
                      FlatButton(
                        onPressed: () => sortItem('Mobile Phone'),
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.phone_android,
                              color: Colors.green[300],
                            ),
                            Text(
                              "Mobile Phone",
                              style: TextStyle(color: Colors.black),
                            )
                          ],
                        ),
                      ),
                      FlatButton(
                        onPressed: () => sortItem('Tablet'),
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.tablet_android,
                              color: Colors.green[300],
                            ),
                            Text(
                              "Tablet",
                              style: TextStyle(color: Colors.black),
                            )
                          ],
                        ),
                      ),
                      FlatButton(
                        onPressed: () => sortItem('Computer Accessories'),
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.keyboard,
                              color: Colors.green,
                            ),
                            Text(
                              "Computer",
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              "Accessories",
                              style: TextStyle(color: Colors.black),
                            )
                          ],
                        ),
                      ),
                      FlatButton(
                        onPressed: () => sortItem('Mobile Accessories'),
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.chat,
                              color: Colors.green,
                            ),
                            Text(
                              "Mobile",
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              "Accessories",
                              style: TextStyle(color: Colors.black),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Widget searchProd() {
    return Visibility(
        visible: _visible,
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 18),
              height: screenHeight / 14,
              width: screenWidth / 1.3,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(28)),
              child: Padding(
                padding: const EdgeInsets.only(top: 3, left: 20),
                child: TextField(
                    controller: searchProductController,
                    decoration: InputDecoration(
                        hintText: 'Search Product',
                        //icon: Icon(Icons.search),
                        border: InputBorder.none)),
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: MaterialButton(
                  onPressed: () =>
                      {sortItemByName(searchProductController.text)},
                  child: Icon(
                    Icons.search,
                    color: Colors.teal,
                  )),
            )),
          ],
        ));
  }

  void loadData() async {
    String urlLoadProduct =
        "https://saujanaeclipse.com/techGoods/php/load_products.php";
    await http.post(urlLoadProduct, body: {}).then((res) {
      if (res.body == "nodata") {
        cartquantity = "0";
        setState(() {
          productInfo = null;
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          productInfo = extractdata["products"];
          cartquantity = widget.user.quantity;
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  //TO DELETE
  /*void _loadCartQuantity() async {
    String urlLoadCartQty =
        "https://saujanaeclipse.com/techGoods/php/load_cartQty.php";
    await http.post(urlLoadCartQty, body: {
      "email": widget.user.email,
    }).then((res) {
      print("Quantity in cart: " + res.body);
      if (res.body == "nodata") {
      } else {
        widget.user.quantity = res.body;
      }
    }).catchError((err) {
      print(err);
    });
  }*/

  Widget productList() {
    return Flexible(
        child: GridView.count(
            childAspectRatio: (screenWidth / screenHeight) / 0.8,
            crossAxisCount: 2,
            children: List.generate(
              productInfo.length,
              (index) {
                return Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: screenHeight / 6,
                          width: screenWidth / 2,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(
                                      "http://saujanaeclipse.com/techGoods/productimage/${productInfo[index]['id']}.jpg"))),
                        ),
                        Container(
                            child: Column(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 5.0),
                              child: Text(
                                productInfo[index]
                                    ['name'], //display the name of the product
                                maxLines: 2,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, height: 1.5),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Text(
                              "RM " + productInfo[index]['price'],
                              style: TextStyle(color: Colors.black),
                            ),
                            Text("In Stock: " + productInfo[index]['quantity']),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                PopupMenuButton<String>(
                                  onSelected: (val) =>
                                      onItemMenuPress(val, context, index),
                                  itemBuilder: (BuildContext context) {
                                    return Constants.choices
                                        .map((String choice) {
                                      return PopupMenuItem<String>(
                                        value: choice,
                                        child: Text(choice),
                                      );
                                    }).toList();
                                  },
                                ),
                              ],
                            )
                          ],
                        ))
                      ],
                    ),
                  ),
                );
              },
            )));
  }

  void onItemMenuPress(String val, BuildContext context, int index) {
    if (val == 'Edit Product') {
      _productDetails(index);
    } else {
      _deleteProductDialog(index);
    }
  }

  void _deleteProductDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Delete Product Id " + productInfo[index]['id'],
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
                //Navigator.of(context).pop();
                _deleteProduct(index);
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

  void _deleteProduct(int index) {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Deleting product..please wait");
    pr.show();
    http.post("https://saujanaeclipse.com/techGoods/php/delete_product.php",
        body: {
          "id": productInfo[index]['id'],
        }).then((res) {
      print(res.body);
      pr.hide();
      if (res.body == "success") {
        Toast.show("Successfully deleted", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        loadData();
        Navigator.of(context).pop();
      } else {
        Toast.show("Failed to delete", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
      pr.hide();
    });
  }

  _productDetails(int index) async {
    Product product = new Product(
        id: productInfo[index]['id'],
        model: productInfo[index]['model'],
        name: productInfo[index]['name'],
        brand: productInfo[index]['brand'],
        price: productInfo[index]['price'],
        quantity: productInfo[index]['quantity'],
        category: productInfo[index]['category'],
        weight: productInfo[index]['weight']);

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                EditProduct(product: product, user: widget.user)));
    loadData();
  }

  void sortItem(String category) {
    try {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Loading Products...");
      pr.show();
      String urlLoadProduct =
          "https://saujanaeclipse.com/techGoods/php/load_products.php";
      http.post(urlLoadProduct, body: {
        "category": category,
      }).then((res) {
        setState(() {
          currentCategory = category;
          var extractdata = json.decode(res.body);
          productInfo = extractdata["products"];
          FocusScope.of(context).requestFocus(new FocusNode());
          pr.hide();
        });
      }).catchError((err) {
        print(err);
        pr.hide();
      });
      pr.hide();
    } catch (e) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void sortItemByName(String prodName) {
    try {
      String urlLoadProduct =
          "https://saujanaeclipse.com/techGoods/php/load_products.php";
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(
          message: 'Searching...',
          progressTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 13.0,
              fontWeight: FontWeight.w400));
      pr.show();
      http
          .post(urlLoadProduct, body: {
            "name": prodName.toString(),
          })
          .timeout(const Duration(seconds: 4))
          .then((res) {
            if (res.body == "nodata") {
              Toast.show("Ooops..product not found!", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              pr.hide();
              FocusScope.of(context).requestFocus(new FocusNode());
              return;
            }
            setState(() {
              var extractdata = json.decode(res.body);
              productInfo = extractdata["products"];
              FocusScope.of(context).requestFocus(new FocusNode());
              currentCategory = prodName;
              pr.hide();
            });
          })
          .catchError((err) {
            pr.hide();
          });
      pr.hide();
    } catch (e) {
      Toast.show('Error', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }
}
