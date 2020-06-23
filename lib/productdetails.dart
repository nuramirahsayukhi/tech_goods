import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import 'mainscreen.dart';
import 'product.dart';
import 'user.dart';

void main() => runApp(ProductDetails());

class ProductDetails extends StatefulWidget {
  final Product product;
  final User user;
  const ProductDetails({Key key, this.product, this.user}) : super(key: key);
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  double screenHeight, screenWidth;
  //List productInfo;
  String cartquantity = "0";
  int quantity = 1;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        home: Scaffold(
            appBar: AppBar(
              title: Text('Product Details'),
              backgroundColor: Colors.teal[900],
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
            body: Stack(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Image(
                      height: screenHeight / 2.2,
                      width: screenWidth / 0.8,
                      fit: BoxFit.fill,
                      image: NetworkImage(
                          "http://saujanaeclipse.com/techGoods/productimage/${widget.product.id}.jpg"),
                    )),
                Container(
                    margin: EdgeInsets.only(top: 330),
                    padding: EdgeInsets.only(top: 20, left: 18),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(28),
                            topRight: Radius.circular(28)),
                        color: Colors.grey[300]),
                    height: screenHeight / 2,
                    width: double.infinity,
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            widget.product.name,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "RM" + widget.product.price,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.greenAccent.shade700),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 15),
                          child: Table(columnWidths: {
                            0: FractionColumnWidth(.3),
                            1: FractionColumnWidth(.7)
                          }, children: [
                            TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text('Brand',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(widget.product.brand,
                                    style: TextStyle(fontSize: 16)),
                              ),
                            ]),
                            TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text('Model',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(widget.product.model,
                                    style: TextStyle(fontSize: 16)),
                              ),
                            ]),
                            TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text('Weight',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(widget.product.weight + 'kg',
                                    style: TextStyle(fontSize: 16)),
                              ),
                            ]),
                          ]),
                        ),
                        Container(
                          width: screenWidth / 2,
                          height: 42,
                          margin: EdgeInsets.only(top: 30),
                          child: MaterialButton(
                              padding: EdgeInsets.only(left: 40),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              onPressed: () {
                                addItemConfirmation();
                              },
                              color: Colors.teal,
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.add_shopping_cart,
                                      color: Colors.white),
                                  SizedBox(width: 10),
                                  Text('Add to Cart',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18)),
                                ],
                              )),
                        )
                      ],
                    )),
              ],
            )));
  }

  addItemConfirmation() {
    quantity = 1;
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, newSetState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              title: Text('Add item to cart?',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Select quantity of product",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                            onPressed: () => {
                              newSetState(() {
                                if (quantity > 1) {
                                  quantity--;
                                }
                              })
                            },
                            child: Icon(
                              Icons.remove,
                              color: Colors.teal,
                            ),
                          ),
                          Text(
                            quantity.toString(),
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          FlatButton(
                            onPressed: () => {
                              newSetState(() {
                                if (quantity <
                                    (int.parse(widget.product.quantity) - 2)) {
                                  quantity++;
                                } else {
                                  Toast.show("Quantity not available", context,
                                      duration: Toast.LENGTH_LONG,
                                      gravity: Toast.BOTTOM);
                                }
                              })
                            },
                            child: Icon(Icons.add, color: Colors.teal),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                    child: new Text(
                      "Yes",
                      style: TextStyle(color: Colors.teal),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                      _addItemtoCart();
                    }),
                new FlatButton(
                  child:
                      new Text("Cancel", style: TextStyle(color: Colors.teal)),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                    return;
                  },
                )
              ],
            );
          });
        });
  }

  void _addItemtoCart() {
    try {
      int cquantity = int.parse(widget.product.quantity);
      print(cquantity);
      print(widget.user.email);
      print(widget.product.id);

      if (cquantity > 0) {
        ProgressDialog pd = new ProgressDialog(context,
            type: ProgressDialogType.Normal, isDismissible: false);
        pd.style(message: "Adding to cart...");
        pd.show();
        String urlAddToCart =
            "https://saujanaeclipse.com/techGoods/php/insert_cart.php";
        http.post(urlAddToCart, body: {
          "email": widget.user.email,
          "prodid": widget.product.id,
          "quantity": quantity.toString()
        }).then((res) {
          print(res.body);
          if (res.body == "failed") {
            Toast.show('Failed to add to cart', context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            pd.hide().then((isHidden) {
              print(isHidden);
            });
            return;
          } else {
            List respond = res.body.split(',');
            setState(() {
              cartquantity = respond[1];
              widget.user.quantity = cartquantity;
            });
            Toast.show('Successfully added to cart', context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          }
          pd.hide().then((isHidden) {
            print(isHidden);
          });
        }).catchError((err) {
          print(err);
          pd.hide().then((isHidden) {
            print(isHidden);
          });
        });
        pd.hide().then((isHidden) {
          print(isHidden);
        });
      } else {
        Toast.show("Out of stock", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } catch (e) {
      Toast.show("Failed add to cart", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }
}
