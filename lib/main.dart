import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:purple_app/screens/init_page.dart';
import 'package:purple_app/screens/login_page.dart';

User user;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
    '/': (context) => InitPage(),
    '/login': (context) => LoginPage(),
    },
  ));
}