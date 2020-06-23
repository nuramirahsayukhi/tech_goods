import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:toast/toast.dart';
import 'package:random_string/random_string.dart';
import 'package:intl/intl.dart';

import 'cartinfo.dart';
import 'cartscreen.dart';
import 'paymentscreen.dart';
import 'user.dart';
//import 'package:TechGoods/cartinfo.dart';
//import 'package:TechGoods/cartscreen.dart';

//import 'package:TechGoods/user.dart';

//import 'paymentscreen.dart';

class CheckOut extends StatefulWidget {
  final User user;
  final CartInfo cartinfo;

  const CheckOut({Key key, this.user, this.cartinfo}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<CheckOut> {
  double screenHeight;
  double screenWidth;
  List orderInfo;
  double weight;
  double deliveryCharge = 0.0;
  double subtotal;
  double totalPrice;
  bool selfPickup;
  String curaddress;
  Position currentPosition;
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController gmapcontroller;
  CameraPosition home;
  MarkerId markerId1 = MarkerId("12");
  Set<Marker> markers = Set();
  double latitude, longitude;
  CameraPosition userPosition;
  @override
  void initState() {
    super.initState();
    subtotal = widget.cartinfo.subtotal;
    totalPrice = widget.cartinfo.subtotal;
    weight = widget.cartinfo.totalWeight;
    selfPickup = true;
    _getLocation();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Check Out'),
          backgroundColor: Colors.teal[900],
          leading: FlatButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => CartScreen(
                              user: widget.user,
                            )));
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
        ),
        body: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(left: 10, top: 10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Delivery Options',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      RadioListTile(
                        title: Text('Self Pickup'),
                        value: true,
                        groupValue: selfPickup,
                        onChanged: (val) {
                          print("Self pickup: $val");
                          onSelfPickup(val);
                        },
                        activeColor: Colors.teal,
                      ),
                      RadioListTile(
                        title: Text('Home Delivery'),
                        value: false,
                        groupValue: selfPickup,
                        onChanged: (val) {
                          print("Self pickup: $val");
                          onHomeDelivery(val);
                        },
                        activeColor: Colors.teal,
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Adress information',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15, left: 8),
                        child: Text("Current Address:",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 18)),
                      ),
                      Row(
                        children: <Widget>[
                          Text("  "),
                          Flexible(
                            child: Text(
                              curaddress ?? "Address not set",
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                      Center(
                          child: MaterialButton(
                              color: Colors.teal[900],
                              onPressed: () => {_loadMapDialog()},
                              child: Icon(
                                Icons.map,
                                color: Colors.white,
                              ))),
                      SizedBox(height: 10),
                      Text('Order Information',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Table(
                        columnWidths: {
                          0: FractionColumnWidth(.5),
                          1: FractionColumnWidth(.5)
                        },
                        children: [
                          TableRow(children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 15, top: 15),
                              child: Text(
                                'Subtotal',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 15.0,
                                left: 50,
                              ),
                              child: Text(
                                "RM " +
                                        widget.cartinfo.subtotal
                                            .toStringAsFixed(2) ??
                                    "0.0",
                                style: TextStyle(
                                    color: Colors.greenAccent.shade700,
                                    fontSize: 16),
                              ),
                            )
                          ]),
                          TableRow(children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 15, top: 5),
                              child: Text(
                                'Delivery Charge',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 5.0,
                                left: 50,
                              ),
                              child: Text(
                                "RM" + deliveryCharge.toStringAsFixed(2) ??
                                    "0.0",
                                style: TextStyle(
                                    color: Colors.greenAccent.shade700,
                                    fontSize: 16),
                              ),
                            )
                          ]),
                          TableRow(children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 15, top: 5),
                              child: Text(
                                'Total weight',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 5.0,
                                left: 50,
                              ),
                              child: Text(
                                widget.cartinfo.totalWeight.toStringAsFixed(2) +
                                    "kg",
                                style: TextStyle(
                                    color: Colors.greenAccent.shade700,
                                    fontSize: 16),
                              ),
                            )
                          ]),
                          TableRow(children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 15, top: 5),
                              child: Text(
                                'Total Price',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 5.0,
                                left: 50,
                              ),
                              child: Text(
                                "RM" + totalPrice.toStringAsFixed(2) ?? "0.0",
                                style: TextStyle(
                                    color: Colors.greenAccent.shade700,
                                    fontSize: 16),
                              ),
                            )
                          ]),
                        ],
                      ),
                      SizedBox(height: 80),
                      Center(
                          child: Container(
                        width: screenWidth / 1.5,
                        height: 42,
                        child: RaisedButton(
                          onPressed: makePayment,
                          color: Colors.green[900],
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24))),
                          child: Text(
                            'Make Payment',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ))
                    ])),
          ],
        ),
      ),
    );
  }

  onSelfPickup(bool val) {
    //self pickup is true
    setState(() {
      selfPickup = val;
      if (selfPickup == true) {
        _updatePayment();
      }
    });
  }

  onHomeDelivery(bool val) {
    //self pick up is false
    _getLocation();
    setState(() {
      selfPickup = val;
      if (selfPickup == false) {
        _updatePayment();
      }
    });
  }

  _getLocation() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    currentPosition = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    final coordinates =
        new Coordinates(currentPosition.latitude, currentPosition.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    setState(() {
      curaddress = first.addressLine;
      if (curaddress != null) {
        latitude = currentPosition.latitude;
        longitude = currentPosition.longitude;
        return;
      }
    });

    print("${first.addressLine}");
  }

  _loadMapDialog() {
    try {
      if (currentPosition.latitude == null) {
        Toast.show("Location not available. Please wait...", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _getLocation(); //_getCurrentLocation();
        return;
      }
      _controller = Completer();
      userPosition = CameraPosition(
        target: LatLng(latitude, longitude),
        zoom: 14.4746,
      );

      markers.add(Marker(
          markerId: markerId1,
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(
            title: 'Current Location',
            snippet: 'Delivery Location',
          )));
      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, newSetState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Select New Delivery Location",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                titlePadding: EdgeInsets.all(5),
                actions: <Widget>[
                  Text(
                    curaddress,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    height: screenHeight ?? 300,
                    width: screenWidth ?? 360,
                    child: GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: userPosition,
                        markers: markers.toSet(),
                        onMapCreated: (controller) {
                          _controller.complete(controller);
                        },
                        onTap: (newLatLng) {
                          _loadLoc(newLatLng, newSetState);
                        }),
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    //minWidth: 200,
                    height: 30,
                    child: Text('Close'),
                    color: Colors.teal,
                    textColor: Colors.white,
                    elevation: 10,
                    onPressed: () =>
                        {markers.clear(), Navigator.of(context).pop(false)},
                  ),
                ],
              );
            },
          );
        },
      );
    } catch (e) {
      print(e);
      return;
    }
  }

  void _loadLoc(LatLng loc, newSetState) async {
    newSetState(() {
      print("insetstate");
      markers.clear();
      latitude = loc.latitude;
      longitude = loc.longitude;
      _getLocationfromlatlng(latitude, longitude, newSetState);
      home = CameraPosition(
        target: loc,
        zoom: 14,
      );
      markers.add(Marker(
          markerId: markerId1,
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(
            title: 'New Location',
            snippet: 'New Delivery Location',
          )));
    });
    userPosition = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 14.4746,
    );
    _newhomeLocation();
  }

  Future<void> _newhomeLocation() async {
    gmapcontroller = await _controller.future;
    gmapcontroller.animateCamera(CameraUpdate.newCameraPosition(home));
    //Navigator.of(context).pop(false);
    //_loadMapDialog();
  }

  _getLocationfromlatlng(double lat, double lng, newSetState) async {
    final Geolocator geolocator = Geolocator()
      ..placemarkFromCoordinates(lat, lng);
    currentPosition = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    //debugPrint('location: ${_currentPosition.latitude}');
    final coordinates = new Coordinates(lat, lng);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    newSetState(() {
      curaddress = first.addressLine;
      if (curaddress != null) {
        latitude = currentPosition.latitude;
        longitude = currentPosition.longitude;
        return;
      }
    });
    setState(() {
      curaddress = first.addressLine;
      if (curaddress != null) {
        latitude = currentPosition.latitude;
        longitude = currentPosition.longitude;
        return;
      }
    });
  }

  void _updatePayment() {
    //weight = widget.cartinfo.totalWeight;
    deliveryCharge = 0.0;

    print(selfPickup);
    if (selfPickup == true) {
      deliveryCharge = 0.0;
    } else {
      if (weight > 5.0) {
        deliveryCharge = 8.00;
      } else if (weight > 10.0) {
        deliveryCharge = 15.00;
      } else {
        deliveryCharge = 5.00;
      }
    }
    totalPrice = subtotal + deliveryCharge;
    print(deliveryCharge);
  }

  Future<void> makePayment() async {
    if (selfPickup == true) {
      print("PICKUP");
      Toast.show("Self Pickup", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else if (selfPickup == false) {
      print("HOME DELIVERY");
      Toast.show("Home Delivery", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else {
      Toast.show("Please select delivery option", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
    var now = new DateTime.now();
    var formatter = new DateFormat('ddMMyyyy-');
    String orderid = widget.user.email.substring(1, 4) +
        "-" +
        formatter.format(now) +
        randomAlphaNumeric(6);
    print(orderid);
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => PaymentScreen(
                  user: widget.user,
                  val: totalPrice.toStringAsFixed(2),
                  orderid: orderid,
                )));
    //_loadCart();
  }
}
