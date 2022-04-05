import 'package:ecomerce_admin/auth/firebase_auth_service.dart';
import 'package:ecomerce_admin/pages/dashboard_page.dart';
import 'package:ecomerce_admin/pages/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LauncherPage extends StatefulWidget {
  static const String routeName = '/launcher';

  @override
  State<LauncherPage> createState() => _LauncherPageState();
}

class _LauncherPageState extends State<LauncherPage> {

  @override
  void initState() {
   Future.delayed(Duration.zero,() {
     if(FirebaseAuthService.currentUser == null){
       Navigator.pushReplacementNamed(context, LoginPage.routeName);
     }else{
       Navigator.pushReplacementNamed(context, DashBoardPage.routeName);
     }
   });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator(),),
    );
  }
}
