import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'purchasehistoryscreen.dart';
import 'purchaseorder.dart';

class PurchaseDetails extends StatefulWidget {
  final PurchaseOrder pOrder;

  const PurchaseDetails({Key key, this.pOrder}) : super(key: key);
  @override
  _PurchaseDetailsState createState() => _PurchaseDetailsState();
}

class _PurchaseDetailsState extends State<PurchaseDetails> {
  List purchaseDetails;
  String titlecenter = "Loading purchase details..";
  double totalPrice = 0.0;
  double screenHeight;
  @override
  void initState() {
    super.initState();
    _loadPurchaseDetails();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: Scaffold(
        //backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text('Purchase Details'),
          backgroundColor: Colors.teal[400],
          elevation: 0.5,
          leading: FlatButton(
              onPressed: () {
                Navigator.pop(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => PurchaseHistory()));
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
        ),
        body: Container(
            child: ListView(
          children: <Widget>[
            purchaseDetails == null
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
                : purchaseDetailsList()
          ],
        )),
      ),
    );
  }

  Widget purchaseDetailsList() {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, index) {
        return purchaseData(index);
      },
      itemCount: purchaseDetails.length,
    );
  }

  Widget purchaseData(int index) {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
          padding: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.all(Radius.circular(16))),
          child: Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    margin:
                        EdgeInsets.only(right: 8, left: 8, top: 10, bottom: 10),
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.white,
                        image: DecorationImage(
                            image: NetworkImage(
                                "http://saujanaeclipse.com/techGoods/productimage/${purchaseDetails[index]['id']}.jpg"))),
                  ),
                  Text(
                    "RM" + purchaseDetails[index]['price'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Expanded(
                child: Container(
                    padding: EdgeInsets.fromLTRB(8, 2, 8, 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          (purchaseDetails[index]['name']),
                          maxLines: 2,
                          softWrap: true,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              ("Product ID: " + purchaseDetails[index]['id']),
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              ("Qty: " + purchaseDetails[index]['cquantity']),
                              style: TextStyle(fontSize: 15),
                            ),
                            Text("RM" + purchaseDetails[index]['yourprice'],
                                style: TextStyle(
                                    fontSize: 15, color: Colors.green)),
                          ],
                        ),
                      ],
                    )),
              )
            ],
          ),
        )
      ],
    );
  }

  _loadPurchaseDetails() async {
    String urlLoadJobs =
        "https://saujanaeclipse.com/techGoods/php/load_carthistory.php";
    await http.post(urlLoadJobs, body: {
      "orderid": widget.pOrder.orderid,
    }).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        setState(() {
          purchaseDetails = null;
          titlecenter = "No Previous Payment";
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          purchaseDetails = extractdata["carthistory"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }
}
