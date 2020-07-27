import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'adminproduct.dart';
import 'cartscreen.dart';
import 'product.dart';
import 'productdetails.dart';
import 'profilescreen.dart';
import 'purchasehistoryscreen.dart';
import 'user.dart';

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key key, this.user}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TextEditingController searchProductController = new TextEditingController();
  GlobalKey<RefreshIndicatorState> refreshKey;
  List productInfo; //creating list of products
  double screenHeight, screenWidth;
  String currentCategory = "Recent";
  String titlecenter = "Loading products...";
  bool _visible = false;
  String cartquantity = "0";
  String server =
      "https://saujanaeclipse.com/techGoods"; //the initial cart quantity is set to 0
  bool _isAdmin = false;
  @override
  void initState() {
    super.initState();
    _loadData();
    if (widget.user.email == "admin@techgoods.com") {
      _isAdmin = true;
    }
    _loadCartQuantity();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          //backgroundColor: Colors.black,
          drawer: mainDrawer(context),
          appBar: AppBar(
            backgroundColor: Colors.teal[400],
            title: Center(
              child: Text(
                'Tech Goods',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
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
              ),

              //
            ],
          ),
          body: RefreshIndicator(
              key: refreshKey,
              color: Color.fromRGBO(101, 255, 218, 50),
              onRefresh: () async {
                await refreshList();
              },
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    imageCarousel(),
                    Visibility(
                      visible: _visible,
                      child: GestureDetector(
                        child: Card(
                            //color: Colors.black,
                            elevation: 0,
                            child: Padding(
                                padding: EdgeInsets.all(5),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          FlatButton(
                                              onPressed: () =>
                                                  _sortItem("Recent"),
                                              padding: EdgeInsets.all(10.0),
                                              child: Column(
                                                // Replace with a Row for horizontal icon + text
                                                children: <Widget>[
                                                  Icon(MdiIcons.update,
                                                      color: Colors.teal[200]),
                                                  Text(
                                                    "Recent",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  )
                                                ],
                                              )),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Column(
                                        children: <Widget>[
                                          FlatButton(
                                              onPressed: () =>
                                                  _sortItem("Laptop"),
                                              padding: EdgeInsets.all(10.0),
                                              child: Column(
                                                // Replace with a Row for horizontal icon + text
                                                children: <Widget>[
                                                  Icon(
                                                    MdiIcons.laptopChromebook,
                                                    color: Colors.teal[200],
                                                  ),
                                                  Text(
                                                    "Laptop",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  )
                                                ],
                                              )),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Column(
                                        children: <Widget>[
                                          FlatButton(
                                              onPressed: () =>
                                                  _sortItem("Mobile Phone"),
                                              padding: EdgeInsets.all(10.0),
                                              child: Column(
                                                // Replace with a Row for horizontal icon + text
                                                children: <Widget>[
                                                  Icon(
                                                    MdiIcons.cellphoneAndroid,
                                                    color: Colors.teal[200],
                                                  ),
                                                  Text(
                                                    "Mobile Phone",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  )
                                                ],
                                              )),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Column(
                                        children: <Widget>[
                                          FlatButton(
                                              onPressed: () =>
                                                  _sortItem("Tablet"),
                                              padding: EdgeInsets.all(10.0),
                                              child: Column(
                                                // Replace with a Row for horizontal icon + text
                                                children: <Widget>[
                                                  Icon(
                                                    MdiIcons.tabletAndroid,
                                                    color: Colors.teal[200],
                                                  ),
                                                  Text(
                                                    "Tablet",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  )
                                                ],
                                              )),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Column(
                                        children: <Widget>[
                                          FlatButton(
                                              onPressed: () => _sortItem(
                                                  "Computer Accesories"),
                                              padding: EdgeInsets.all(10.0),
                                              child: Column(
                                                // Replace with a Row for horizontal icon + text
                                                children: <Widget>[
                                                  Icon(
                                                    MdiIcons.desktopClassic,
                                                    color: Colors.teal[200],
                                                  ),
                                                  Text(
                                                    "Computer",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                  Text(
                                                    'Accessories',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  )
                                                ],
                                              )),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Column(
                                        children: <Widget>[
                                          FlatButton(
                                              onPressed: () => _sortItem(
                                                  "Mobile Accessories"),
                                              padding: EdgeInsets.all(10.0),
                                              child: Column(
                                                // Replace with a Row for horizontal icon + text
                                                children: <Widget>[
                                                  Icon(MdiIcons.headphones,
                                                      color: Colors.teal[200]),
                                                  Text(
                                                    "Mobile",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                  Text(
                                                    "Accessories",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  )
                                                ],
                                              )),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Column(
                                        children: <Widget>[
                                          FlatButton(
                                              onPressed: () =>
                                                  _sortItem("Others"),
                                              padding: EdgeInsets.all(10.0),
                                              child: Column(
                                                // Replace with a Row for horizontal icon + text
                                                children: <Widget>[
                                                  Icon(
                                                    MdiIcons.ornament,
                                                    color: Colors.teal[200],
                                                  ),
                                                  Text(
                                                    "Others",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  )
                                                ],
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ))),
                      ),
                    ),
                    searchProd(),
                    productInfo == null
                        ? Flexible(
                            child: Container(
                                child: Center(
                                    child: Text(
                            titlecenter,
                            style: TextStyle(
                                color: Colors.teal,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ))))
                        : Expanded(
                            child: GridView.count(
                                crossAxisCount: 2,
                                childAspectRatio:
                                    (screenWidth / screenHeight) / 0.8,
                                children:
                                    List.generate(productInfo.length, (index) {
                                  return Container(
                                      child: Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16)),
                                          color: Colors.white,
                                          elevation: 1,
                                          child: Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                GestureDetector(
                                                  onTap: () =>
                                                      _productDetails(index),
                                                  child: Container(
                                                    height: screenHeight / 5.9,
                                                    width: screenWidth / 2.8,
                                                    child: ClipOval(
                                                        child:
                                                            CachedNetworkImage(
                                                      fit: BoxFit.fill,
                                                      imageUrl: server +
                                                          "/productimage/${productInfo[index]['id']}.jpg",
                                                      placeholder: (context,
                                                              url) =>
                                                          new CircularProgressIndicator(),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          new Icon(Icons.error),
                                                    )),
                                                  ),
                                                ),
                                                Text(
                                                  productInfo[index]['name'],
                                                  maxLines: 3,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 4, bottom: 4),
                                                  child: Text(
                                                    "RM " +
                                                        productInfo[index]
                                                            ['price'],
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                Text(
                                                  "Quantity available:" +
                                                      productInfo[index]
                                                          ['quantity'],
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )));
                                })))
                  ],
                ),
              )),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Colors.teal,
            onPressed: () async {
              if (widget.user.email == "unregistered@techgoods.com") {
                Toast.show("Please register to use this function", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                return;
              } else if (widget.user.email == "admin@techgoods.com") {
                Toast.show("Admin Mode", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                return;
              } else if (widget.user.quantity == "0") {
                Toast.show("Empty Cart", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                return;
              } else {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => CartScreen(
                              user: widget.user,
                            )));
                _loadData();
                _loadCartQuantity();
              }
            },
            icon: Icon(Icons.add_shopping_cart),
            label: Text(cartquantity),
          ),
        ));
  }

  void _loadData() async {
    String urlLoadData = server + "/php/load_products.php";
    await http.post(urlLoadData, body: {}).then((res) {
      if (res.body == "nodata") {
        cartquantity = "0";
        titlecenter = "No product found";
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

  void _loadCartQuantity() async {
    String urlLoadQty = server + "/php/load_cartQty.php";
    await http.post(urlLoadQty, body: {
      "email": widget.user.email,
    }).then((res) {
      if (res.body == "nodata") {
        widget.user.quantity = '0';
      } else {
        widget.user.quantity = res.body;
      }
    }).catchError((err) {
      print(err);
    });
  }

  Widget mainDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.teal[400]),
              accountName: Text(widget.user.name),
              accountEmail: Text(widget.user.email),
              otherAccountsPictures: <Widget>[
                Text("RM " + widget.user.credit,
                    style: TextStyle(fontSize: 16.0, color: Colors.white)),
              ],
              currentAccountPicture: CircleAvatar(
                backgroundColor:
                    Theme.of(context).platform == TargetPlatform.android
                        ? Colors.white
                        : Colors.white,
                child: Text(
                  widget.user.name.toString().substring(0, 1).toUpperCase(),
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
              onDetailsPressed: () => {
                Navigator.pop(context),
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => ProfileScreen(
                              user: widget.user,
                            )))
              },
            ),
            ListTile(
                leading: Icon(Icons.home, color: Colors.teal[400]),
                title: Text(
                  "Home",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward, color: Colors.white),
                onTap: () => {
                      Navigator.pop(context),
                      _loadData(),
                    }),
            ListTile(
                title: Text(
                  "Shopping Cart",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                leading: Icon(Icons.shopping_cart, color: Colors.red[400]),
                trailing: Icon(Icons.arrow_forward, color: Colors.white),
                onTap: () => {
                      Navigator.pop(context),
                      gotoCart(),
                    }),
            ListTile(
                title: Text(
                  "My Profile",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                leading: Icon(Icons.person, color: Colors.blue[400]),
                trailing: Icon(Icons.arrow_forward, color: Colors.white),
                onTap: () => {
                      Navigator.pop(context),
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => ProfileScreen(
                                    user: widget.user,
                                  )))
                    }),
            ListTile(
                title: Text(
                  "Purchase History",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                leading: Icon(Icons.shopping_basket, color: Colors.orange[300]),
                trailing: Icon(Icons.arrow_forward, color: Colors.white),
                onTap: _paymentScreen),
            Visibility(
              visible: _isAdmin,
              child: Column(
                children: <Widget>[
                  Divider(
                    height: 2,
                    color: Colors.black,
                  ),
                  Center(
                    child: Text(
                      "Admin Menu",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                      title: Text(
                        "Manage Products",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward, color: Colors.white),
                      onTap: () => {
                            Navigator.pop(context),
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        AdminProduct(
                                          user: widget.user,
                                        )))
                          }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _sortItem(String category) {
    try {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: true);
      pr.style(message: "Searching...");
      pr.show();
      String urlLoadJobs = server + "/php/load_products.php";
      http.post(urlLoadJobs, body: {
        "category": category,
      }).then((res) {
        if (res.body == "nodata") {
          setState(() {
            productInfo = null;
            currentCategory = category;
            titlecenter = "No product found";
          });
          pr.hide();
        } else {
          setState(() {
            currentCategory = category;
            var extractdata = json.decode(res.body);
            productInfo = extractdata["products"];
            FocusScope.of(context).requestFocus(new FocusNode());
            pr.hide();
          });
        }
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

  Widget searchProd() {
    return Visibility(
        visible: _visible,
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
              height: screenHeight / 13,
              width: screenWidth / 1.3,
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(28)),
              child: Padding(
                padding: const EdgeInsets.only(top: 3, left: 20),
                child: TextField(
                    controller: searchProductController,
                    decoration: InputDecoration(
                        hintText: 'Search Product', border: InputBorder.none)),
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(top: 15),
              child: MaterialButton(
                  onPressed: () =>
                      {sortItemByName(searchProductController.text)},
                  child: Icon(
                    Icons.search,
                    color: Colors.teal[400],
                  )),
            )),
          ],
        ));
  }

  void sortItemByName(String prodName) {
    try {
      print(prodName);
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: true);
      pr.style(message: "Searching...");
      pr.show();
      String urlLoadJobs = server + "/php/load_products.php";
      http
          .post(urlLoadJobs, body: {
            "name": prodName.toString(),
          })
          .timeout(const Duration(seconds: 4))
          .then((res) {
            if (res.body == "nodata") {
              Toast.show("Product not found", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              pr.hide();
              setState(() {
                titlecenter = "No product found";
                currentCategory = "search for " + "'" + prodName + "'";
                productInfo = null;
              });
              FocusScope.of(context).requestFocus(new FocusNode());

              return;
            } else {
              setState(() {
                var extractdata = json.decode(res.body);
                productInfo = extractdata["products"];
                FocusScope.of(context).requestFocus(new FocusNode());
                currentCategory = "search for " + "'" + prodName + "'";
                pr.hide();
              });
            }
          })
          .catchError((err) {
            pr.hide();
          });
      pr.hide();
    } on TimeoutException catch (_) {
      Toast.show("Time out", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } on SocketException catch (_) {
      Toast.show("Time out", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } catch (e) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  gotoCart() async {
    if (widget.user.email == "unregistered@techgoods.com") {
      Toast.show("Please register to use this function", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else if (widget.user.email == "admin@techgoods.com") {
      Toast.show("Admin mode!!!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else if (widget.user.quantity == "0") {
      Toast.show("Cart empty", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => CartScreen(
                    user: widget.user,
                  )));
      _loadData();
      _loadCartQuantity();
    }
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: new Text(
              'Are you sure?',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            content: new Text(
              'Do you want to exit an App',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                  onPressed: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  child: Text(
                    "Exit",
                    style: TextStyle(
                      color: Color.fromRGBO(101, 255, 218, 50),
                    ),
                  )),
              MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Color.fromRGBO(101, 255, 218, 50),
                    ),
                  )),
            ],
          ),
        ) ??
        false;
  }

  _productDetails(int index) async {
    Product product = new Product(
        id: productInfo[index]['id'],
        model: productInfo[index]['model'],
        name: productInfo[index]['name'],
        brand: productInfo[index]['brand'],
        price: productInfo[index]['price'],
        quantity: productInfo[index]['quantity'],
        weight: productInfo[index]['weight']);

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                ProductDetails(product: product, user: widget.user)));
  }

  void _paymentScreen() {
    if (widget.user.email == "unregistered@techgoods.com") {
      Toast.show("Please register to use this function", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else if (widget.user.email == "admin@techgoods.com") {
      Toast.show("Admin Mode", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => PurchaseHistory(
                  user: widget.user,
                )));
  }

  Widget imageCarousel() {
    return Visibility(
      visible: _visible,
      child: Container(
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
      ),
    );
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    //_getLocation();
    _loadData();
    return null;
  }
}
