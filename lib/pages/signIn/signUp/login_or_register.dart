import 'package:flutter/material.dart';

import 'login_page.dart';
import 'register_page.dart';
class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  // shw pg
  bool showLoginPage = true;

  // toggle b/w login n rgstr pg
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    if(showLoginPage){
      return LoginPage(
        onTap: togglePages,
      );
    } else {
      return RegisterPage(
        onTap: togglePages,
      ); 
    }
  }
}