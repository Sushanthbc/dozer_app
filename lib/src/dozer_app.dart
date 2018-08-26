library dozer;

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:date_format/date_format.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

part 'utli/authentication.dart';
part 'pages/splash_page.dart';
part 'pages/form_snake.dart';

class DozerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      title: 'WildLife NGO',
      theme: new ThemeData(
        fontFamily: 'Helvetica Neue',
        primarySwatch: Colors.blueGrey,
      ),
      home: new SplashPage(),
    );
  }
}


