import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
//own import
import 'cartinfo.dart';
import 'checkoutscreen.dart';
import 'mainscreen.dart';

import 'user.dart';

class CartScreen extends StatefulWidget {
  final User user;

  const CartScreen({Key key, this.user}) : super(key: key);
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List cartInfo;
  double screenHeight;
  double screenWidth;
  double totalPrice = 0.0;
  double weight = 0.0;

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (cartInfo == null) {
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
                Align(
                    alignment: Alignment.center,
                    child: Text('Loading your cart'))
              ],
            )),
          ),
        ),
      );
    } else {
      return MaterialApp(
        title: 'Material App',
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            resizeToAvoidBottomPadding: false,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: Colors.teal[900],
              title: Text(
                'My Cart',
                style: TextStyle(color: Colors.white),
              ),
              elevation: 0.5,
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
            ),
            body: Builder(builder: (context) {
              return Container(
                child: ListView(
                  children: <Widget>[cartList(), footer(context)],
                ),
              );
            })),
      );
    }
  }

  void loadCart() {
    totalPrice = 0.0;
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Updating cart...");
    pr.show();
    String urlLoadCart =
        "https://saujanaeclipse.com/techGoods/php/load_cart.php";
    http.post(urlLoadCart, body: {
      "email": widget.user.email,
    }).then((res) {
      print(res.body);
      pr.hide().then((isHidden) {
  print(isHidden);
});
      if (res.body == "Empty cart") {
        widget.user.quantity = "0";
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MainScreen(
                      user: widget.user,
                    )));
      }
      setState(() {
        var extractdata = json.decode(res.body);
        cartInfo = extractdata["cart"];
        for (int i = 0; i < cartInfo.length; i++) {
          weight = double.parse(cartInfo[i]['weight']) *
                  int.parse(cartInfo[i]['cquantity']) +
              weight;
          totalPrice = double.parse(cartInfo[i]['yourprice']) + totalPrice;
        }
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
  }

  Widget cartList() {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, index) {
        return cartListItem(index);
      },
      itemCount: cartInfo.length,
    );
  }

  Widget cartListItem(int index) {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 10, right: 10, top: 20),
          decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.all(Radius.circular(16))),
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 8, left: 8, bottom: 10),
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    color: Colors.white,
                    image: DecorationImage(
                        image: NetworkImage(
                            "http://saujanaeclipse.com/techGoods/productimage/${cartInfo[index]['id']}.jpg"))),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        (cartInfo[index]['name']),
                        maxLines: 2,
                        softWrap: true,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        ("RM " + cartInfo[index]['yourprice']),
                        style: TextStyle(fontSize: 15),
                      ),
                      Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 20, left: 5),
                              child: Row(
                                children: <Widget>[
                                  FlatButton(
                                    onPressed: () =>
                                        {updateCart(index, "remove")},
                                    child: Icon(
                                      Icons.remove,
                                      size: 18,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  Container(
                                    color: Colors.grey.shade200,
                                    padding: const EdgeInsets.only(
                                        right: 10, left: 10),
                                    child: Text(
                                      (cartInfo[index]['cquantity']),
                                    ),
                                  ),
                                  FlatButton(
                                    onPressed: () => {updateCart(index, "add")},
                                    child: Icon(
                                      Icons.add,
                                      size: 18,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 52),
                        child: FlatButton.icon(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            color: Colors.red[300],
                            onPressed: () => {removeItem(index)},
                            icon: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            label: Text(
                              'Remove',
                              style: TextStyle(color: Colors.white),
                            )),
                      )
                    ],
                  ),
                ),
                flex: 100,
              ),
            ],
          ),
        ),
      ],
    );
  }

  updateCart(int index, String operation) {
    int qtyAvailable = int.parse(cartInfo[index]['quantity']);
    int currentQty = int.parse(cartInfo[index]['cquantity']);
    if (operation == "add") {
      currentQty++;
      if (qtyAvailable < (currentQty - 2)) {
        Toast.show("Out of stock", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
      }
    }
    if (operation == "remove") {
      currentQty--;
      if (currentQty == 0) {
        removeItem(index);
        return;
      }
    }
    String urlUpdateCart =
        "https://saujanaeclipse.com/techGoods/php/update_cart.php";
    http.post(urlUpdateCart, body: {
      "email": widget.user.email,
      "prodid": cartInfo[index]['id'],
      "quantity": currentQty.toString()
    }).then((res) {
      if (res.body == "failed") {
        Toast.show("Failed to update", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Toast.show("Cart is successfully updated", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        loadCart();
      } else {
        print(res.body);
        Toast.show("Cart is successfully updated", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        loadCart();
      }
    });
  }

  removeItem(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Delete item from cart?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Container(
                height: screenHeight / 15,
                child: Column(
                  children: <Widget>[
                    Expanded(
                        child: RichText(
                            text: TextSpan(
                                text: 'If you wish to ',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20.0),
                                children: <TextSpan>[
                          TextSpan(
                              text: 'cancel, ',
                              style:
                                  TextStyle(color: Colors.red, fontSize: 20.0)),
                          TextSpan(
                              text: "click 'No' ",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 20.0))
                        ]))),
                  ],
                )),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                    String urlDeleteItem =
                        "https://saujanaeclipse.com/techGoods/php/delete_item.php";
                    http.post(urlDeleteItem, body: {
                      "email": widget.user.email,
                      "prodid": cartInfo[index]['id']
                    }).then((res) {
                      if (res.body == "success") {
                        loadCart();
                      } else {
                        Toast.show("Failed to delete item", context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      }
                    });
                  },
                  child: Text(
                    'Yes',
                    style: TextStyle(color: Colors.teal),
                  )),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    'No',
                    style: TextStyle(color: Colors.teal),
                  )),
            ],
          );
        });
  }

  footer(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 30),
                child: Text(
                  "Total Price",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 30),
                child: Text(
                  "RM " + totalPrice.toStringAsFixed(2) ?? "0.0",
                  style: TextStyle(
                      color: Colors.greenAccent.shade700, fontSize: 16),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            width: screenWidth / 1.5,
            height: 42,
            child: RaisedButton(
              onPressed: () {
                CartInfo cartinfo =
                    new CartInfo(subtotal: totalPrice, totalWeight: weight);
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => CheckOut(
                              user: widget.user,
                              cartinfo: cartinfo,
                            )));
                loadCart();
              },
              color: Colors.green[900],
              padding:
                  EdgeInsets.only(top: 12, left: 40, right: 40, bottom: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24))),
              child: Text(
                "Check Out",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
      margin: EdgeInsets.only(top: 16),
    );
  }
}
