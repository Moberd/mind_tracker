import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:mind_tracker/main.dart';

class GenerateScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => GenerateScreenState();
}

class GenerateScreenState extends State<GenerateScreen> {

  GlobalKey globalKey = new GlobalKey();
  String _dataString = FirebaseAuth.instance.currentUser.email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.myQR[lang]),
        actions: <Widget>[
        ],
      ),
      body: _contentWidget(),
    );
  }

  _contentWidget() {
    final bodyHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom;
    return  Container(
      color: const Color(0xFFFFFFFF),
      child:  Column(
        children: <Widget>[
          Expanded(
            child:  Center(
              child: RepaintBoundary(
                key: globalKey,
                child: QrImage(
                  data: _dataString,
                  size: 0.4 * bodyHeight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}