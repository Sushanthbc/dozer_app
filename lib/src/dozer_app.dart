library dozer;

import 'dart:async';
import 'package:async/async.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:date_format/date_format.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


part 'util/image_info.dart';
part 'util/authentication.dart';
part 'util/snake_info.dart';
part 'util/drawer_main.dart';
part 'util/app_user_info.dart';
part 'util/shared_preferences.dart';

part 'pages/splash_page.dart';
part 'pages/form_snake.dart';
part 'pages/list_snakes.dart';
part 'pages/snake_details.dart';
part 'pages/form_edit_snake.dart';
part 'pages/list_users.dart';
part 'pages/form_new_user.dart';

class DozerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      title: 'WildLife NGO',
      theme: new ThemeData(
        fontFamily: 'Helvetica Neue',
        primarySwatch: Colors.indigo,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => new SplashPage(),
        '/snakeForm': (context) => new NewRescueForm(),
        '/snakesList': (context) => new ListSnakes(),
        '/snakeDetail': (context) => new DetailScreen(),
        '/usersList': (context) => new UsersList(),
      },
    );
  }
}


