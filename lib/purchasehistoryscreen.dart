import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'mainscreen.dart';
import 'purchasedetails.dart';
import 'purchaseorder.dart';
import 'user.dart';

class PurchaseHistory extends StatefulWidget {
  final User user;

  const PurchaseHistory({Key key, this.user}) : super(key: key);
  @override
  _PurchaseHistoryState createState() => _PurchaseHistoryState();
}

class _PurchaseHistoryState extends State<PurchaseHistory> {
  List paymentData;
  double screenHeight, screenWidth;
  String titlecenter = "Loading purchase history...";
  final f = new DateFormat('dd-MM-yyyy hh:mm a');
  var parsedDate;

  @override
  void initState() {
    super.initState();
    _loadPurchasedHistory();
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
          backgroundColor: Colors.teal[900],
          elevation: 0.5,
          title: Text('Purchase History'),
          leading: FlatButton(
              onPressed: () {
                Navigator.pop(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => MainScreen()));
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
        ),
        body: Container(
            child: ListView(
          children: <Widget>[
            paymentData == null
                ? Container(
                    margin: EdgeInsets.only(top: screenHeight / 2),
                    child: Center(
                        child: Text(
                      titlecenter,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    )))
                : paymentList()
          ],
        )),
      ),
    );
  }

  Widget paymentList() {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, index) {
        return paymentDataItem(index);
      },
      itemCount: paymentData.length,
    );
  }

  Widget paymentDataItem(int index) {
    return GestureDetector(
      onTap: () => loadPurchaseDetails(index),
      child: Card(
          color: Colors.teal[50],
          child: Column(
            children: <Widget>[
              Text("Order ID #" + paymentData[index]['orderid']),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        "Bill ID",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        paymentData[index]['billid'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  SizedBox(width: 10),
                  Column(
                    children: <Widget>[
                      Text("Total Amount",
                          style: TextStyle(color: Colors.grey)),
                      Text("RM" + paymentData[index]['total'],
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ],
                  ),
                  SizedBox(width: 10),
                  Column(
                    children: <Widget>[
                      Text("Date", style: TextStyle(color: Colors.grey)),
                      Text(
                        f.format(DateTime.parse(paymentData[index]['date'])),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              )
            ],
          )),
    );
  }

  Future<void> _loadPurchasedHistory() async {
    String urlLoadPayment =
        "https://saujanaeclipse.com/techGoods/php/load_purchasedhistory.php";
    await http
        .post(urlLoadPayment, body: {"email": widget.user.email}).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        setState(() {
          paymentData = null;
          titlecenter = "No Payment Made";
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          paymentData = extractdata["payment"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  loadPurchaseDetails(int index) {
    PurchaseOrder porder =
        new PurchaseOrder(orderid: paymentData[index]['orderid']);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => PurchaseDetails(
                  pOrder: porder,
                )));
  }
}
