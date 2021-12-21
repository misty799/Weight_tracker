import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/auth_service.dart';
import 'package:flutter_application/home_screen.dart';
import 'package:flutter_application/sign_in_page.dart';

class RouteScreen extends StatefulWidget {
  const RouteScreen({Key? key}) : super(key: key);

  @override
  _RouteScreenState createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
            stream: AuthService.authService.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const HomeScreen();
              } else if (!snapshot.hasData) {
                return const SignInPage();
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }
}
