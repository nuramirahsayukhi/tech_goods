import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

import 'cartscreen.dart';
import 'product.dart';
import 'productdetails.dart';
import 'profilescreen.dart';
import 'purchasehistoryscreen.dart';
import 'user.dart';
//own import


class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key key, this.user}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TextEditingController searchProductController = new TextEditingController();
  List productInfo; //creating list of products
  double screenHeight, screenWidth;
  String currentCategory = "Recent"; //the initial category is set to Recent
  bool _visible = false;
  String cartquantity = "0"; //the initial cart quantity is set to 0

  @override
  void initState() {
    super.initState();
    loadData();
    _loadCartQuantity();
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
            resizeToAvoidBottomPadding: false,
            appBar: AppBar(
              backgroundColor: Colors.teal[900],
              elevation: 0.5,
              title: Container(
                padding: EdgeInsets.only(left: 80),
                child: Text("TechGoods", style: TextStyle(color: Colors.white)),
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
                )
              ],
            ),
            drawer: new Drawer(
              child: new ListView(
                children: <Widget>[
                  new UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      color: const Color(0xFF004D40),
                    ),
                    accountName: Text(
                      widget.user.name,
                      style: TextStyle(fontSize: 20.0),
                    ),
                    accountEmail: Text(widget.user.email),
                    currentAccountPicture: CircleAvatar(
                        backgroundColor:
                            Theme.of(context).platform == TargetPlatform.android
                                ? Colors.white
                                : Colors.white,
                        child: Text(
                          widget.user.name
                              .toString()
                              .substring(0, 1)
                              .toUpperCase(),
                          style: TextStyle(fontSize: 40.0),
                        )),
                  ),
                  InkWell(
                      onTap: () {},
                      child: ListTile(
                          title: Text(
                            'Home',
                            style: TextStyle(fontSize: 16),
                          ),
                          leading: Icon(Icons.home, color: Colors.teal[400]))),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ProfileScreen(
                                      user: widget.user,
                                    )));
                      },
                      child: ListTile(
                          title: Text(
                            'My Profile',
                            style: TextStyle(fontSize: 16),
                          ),
                          leading:
                              Icon(Icons.person, color: Colors.blue[400]))),
                  InkWell(
                      onTap: () async {
                        if (widget.user.email == "unregistered") {
                          Toast.show(
                              "Please register to use this function", context,
                              duration: Toast.LENGTH_LONG,
                              gravity: Toast.BOTTOM);
                          return;
                        } else if (widget.user.quantity == "0") {
                          Toast.show("Cart is empty", context,
                              duration: Toast.LENGTH_LONG,
                              gravity: Toast.BOTTOM);
                        } else {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => CartScreen(
                                        user: widget.user,
                                      )));
                          loadData();
                          _loadCartQuantity();
                        }
                      },
                      child: ListTile(
                          title: Text(
                            'Shopping Cart',
                            style: TextStyle(fontSize: 16),
                          ),
                          leading: Icon(Icons.shopping_cart,
                              color: Colors.red[400]))),
                  InkWell(
                      onTap: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    PurchaseHistory(
                                      user: widget.user,
                                    )));
                      },
                      child: ListTile(
                          title: Text(
                            'Purchased History',
                            style: TextStyle(fontSize: 16),
                          ),
                          leading: Icon(Icons.shopping_basket,
                              color: Colors.orange[300]))),
                ],
              ),
            ),
            body: Container(
              color: Colors.white,
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
            floatingActionButton: FloatingActionButton.extended(
              backgroundColor: Colors.teal,
              onPressed: () async {
                if (widget.user.email == "unregistered") {
                  Toast.show("Please register to use this function", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                } else if (widget.user.quantity == "0") {
                  Toast.show("Cart is empty", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                } else {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => CartScreen(
                                user: widget.user,
                              )));
                  loadData();
                  _loadCartQuantity();
                }
              },
              icon: Icon(Icons.shopping_cart, color: Colors.white),
              label: Text(
                cartquantity,
                style: TextStyle(color: Colors.white),
              ),
              elevation: 20.0,
              //backgroundColor: Colors.teal[700],
            ),
          ));
    }
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
          //print("Quantity in cart: $cartquantity");
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _loadCartQuantity() async {
    String urlLoadCartQty =
        "https://saujanaeclipse.com/techGoods/php/load_cartQty.php";
    await http.post(urlLoadCartQty, body: {
      "email": widget.user.email,
    }).then((res) {
      print(res.body);
      if (res.body == "nodata") {
      } else {
        widget.user.quantity = res.body;
      }
    }).catchError((err) {
      print(err);
    });
  }

  Widget productList() {
    return Flexible(
        child: GridView.count(
            childAspectRatio: (screenWidth / screenHeight) / 0.8,
            crossAxisCount: 2,
            children: List.generate(
              productInfo.length,
              (index) {
                return GestureDetector(
                  onTap: () => _productDetails(index),
                  child: Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    color: Colors.grey[100],
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Column(
                        children: <Widget>[
                          //to display image of product
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            height: screenHeight / 5,
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
                                  productInfo[index][
                                      'name'], //display the name of the product
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, height: 1.5),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Text(
                                "RM " + productInfo[index]['price'],
                                style: TextStyle(
                                    color: Colors.greenAccent.shade700),
                              ),
                              Text("In Stock:" +
                                  productInfo[index]['quantity']),
                            ],
                          ))
                        ],
                      ),
                    ),
                  ),
                );
              },
            )));
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
          pr.hide().then((isHidden) {
  print(isHidden);
});
        });
      }).catchError((err) {
        print(err);
        pr.hide().then((isHidden) {
  print(isHidden);
});
      });
      pr.hide().then((isHidden) {
  print(isHidden);
});
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
              pr.hide().then((isHidden) {
  print(isHidden);
});
              FocusScope.of(context).requestFocus(new FocusNode());
              return;
            }
            setState(() {
              var extractdata = json.decode(res.body);
              productInfo = extractdata["products"];
              FocusScope.of(context).requestFocus(new FocusNode());
              currentCategory = prodName;
              pr.hide().then((isHidden) {
  print(isHidden);
});
            });
          })
          .catchError((err) {
          pr.hide().then((isHidden) {
  print(isHidden);
});
          });
      pr.hide().then((isHidden) {
  print(isHidden);
});
    } catch (e) {
      Toast.show('Error', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  addItemConfirmation(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Text('Add item to cart?',
                style: TextStyle(fontWeight: FontWeight.bold)),
            content: Container(
                height: screenHeight / 15,
                child: Column(
                  children: <Widget>[
                    Text('Choose your quantity'),
                  ],
                )),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                  child: new Text(
                    "Yes",
                    style: TextStyle(color: Colors.teal),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                    _addItemtoCart(index);
                  }),
              new FlatButton(
                child: new Text("No", style: TextStyle(color: Colors.teal)),
                onPressed: () {
                  Navigator.of(context).pop(false);
                  return;
                },
              )
            ],
          );
        });
  }

  void _addItemtoCart(int index) {
    try {
      int quantity = int.parse(productInfo[index]['quantity']);
      if (quantity > 0) {
        ProgressDialog pd = new ProgressDialog(context,
            type: ProgressDialogType.Normal, isDismissible: false);
        pd.style(message: "Adding to cart...");
        pd.show();
        String urlAddToCart =
            "https://saujanaeclipse.com/techGoods/php/insert_cart.php";
        http.post(urlAddToCart, body: {
          "email": widget.user.email,
          "prodid": productInfo[index]["id"]
        }).then((res) {
          if (res.body == "failed") {
            Toast.show('Failed to add to cart', context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          } else {
            List respond = res.body.split(',');
            setState(() {
              cartquantity = respond[1];
            });
            Toast.show('Successfully added to cart', context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          }
          pd.hide().then((isHidden) {
  print(isHidden);
});
        });
      }
    } catch (e) {
      Toast.show('Error', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
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
}
