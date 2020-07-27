import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'profilescreen.dart';
import 'user.dart';

class StoreCreditScreen extends StatefulWidget {
  final User user;
  final String val;

  StoreCreditScreen({this.user, this.val});

  @override
  _StoreCreditScreenState createState() => _StoreCreditScreenState();
}

class _StoreCreditScreenState extends State<StoreCreditScreen> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  String server = "https://saujanaeclipse.com/techGoods";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: FlatButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => ProfileScreen(
                              user: widget.user,
                            )));
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
          backgroundColor: Colors.teal[800],
          title: Text('BUY STORE CREDITS'),
          // backgroundColor: Colors.deepOrange,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: WebView(
                initialUrl:
                    'http://saujanaeclipse.com/techGoods/php/buycredit.php?email=' +
                        widget.user.email +
                        '&mobile=' +
                        widget.user.phone +
                        '&name=' +
                        widget.user.name +
                        '&amount=' +
                        widget.val +
                        '&csc=' +
                        widget.user.credit,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
              ),
            )
          ],
        ));
  }
}
