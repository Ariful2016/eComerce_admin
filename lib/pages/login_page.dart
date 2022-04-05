import 'dart:math';

import 'package:ecomerce_admin/auth/firebase_auth_service.dart';
import 'package:ecomerce_admin/pages/dashboard_page.dart';
import 'package:ecomerce_admin/providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? _email;
  String? _password;
  String errMsg = '';
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(8.0),
            children: [
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text('Admin Login', style: TextStyle(fontSize: 30, color: Colors.green,), ),
                ),
              ),
              const SizedBox(height: 20,),
              TextFormField(
                validator: (value){
                  if(value == null || value.isEmpty){
                    return 'This field can not be empty';
                  }
                  return null;
                },
                onSaved: (value){
                  _email = value;
                },
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon:Icon(Icons.email),
                  border: OutlineInputBorder()
                ),
              ),
              const SizedBox(height: 10,),
              TextFormField(
                obscureText: true,
                keyboardType: TextInputType.emailAddress,
                validator: (value){
                  if(value == null || value.isEmpty){
                    return 'This field can not be empty';
                  }
                  return null;
                },
                onSaved: (value){
                  _password = value;
                },
                decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.password),
                    border: OutlineInputBorder()
                ),
              ),
              const SizedBox(height: 20,),
              Center(
                child: ElevatedButton(
                    onPressed: _loginAdmin,
                    child: const Text('Login')),
              ),
              const SizedBox(height: 20,),
              Center(child: Text(errMsg, style: const TextStyle(fontSize: 20, color: Colors.red),))

            ],
          ),
        ),
      ),
    );
  }

  void _loginAdmin() async{
    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();
      try{
        final user = await FirebaseAuthService.loginAdmin(_email!, _password!);
        if(user != null){
          final isAdmin = await Provider.of<AuthProvider>(context, listen: false)
          .checkAdmin(_email!);
          if(isAdmin){
            Navigator.pushReplacementNamed(context, DashBoardPage.routeName);
          }else{
            setState(() {
              errMsg = 'You are not an admin, Please check your email & password!';
            });
          }

        }
      }on FirebaseAuthException catch(e){
        setState(() {
          errMsg = e.message!;
        });
      }
    }
  }
}
