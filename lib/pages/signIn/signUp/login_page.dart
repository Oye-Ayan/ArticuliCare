import 'package:articulicare/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:articulicare/components/my_button.dart';
import 'package:articulicare/components/square_tile.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../components/my_textfield.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isPasswordVisible = false; 

  void signUserIn() async {
    if (formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        showErrorMessage(e.code);
      }
    }
  }

  void showTryLaterMessage() {
    // Show a SnackBar with the "try later" message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Please try later'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.blue.shade400,
      ),
    );
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blue.shade400,
          title: Text(
            message,
            style: TextStyle(color: Colors.white, fontSize: 15.sp),
          ),
        );
      },
    );
  }

  //function to show dialog box
void Betaversion_showDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
    return AlertDialog(
    title: Text('Beta Version'),
      content: Text('login with Apple id is not possible at the moment',),
      actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                child: Text('OK', style: TextStyle(color: Colors.blue),),
              ),
            ],
          );         
        },
      );
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 15.h),
                    Container(
                    height: 230.h, 
                    width: 230.h,  
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, 
                      image: const DecorationImage(
                        image: AssetImage('assets/images/speech_transcribe.png'),
                        fit: BoxFit.cover, 
                      ),
                    ),
                  ),

                  SizedBox(height: 25.h),
                  Text(
                    'ArticuliCare',
                    style: TextStyle(
                      fontSize: 24.sp,
                      color: Colors.blue[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 25.h),
                  
                  // Email TextField
                  MyTextfield(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10.h),

                  // Password TextField
                  MyTextfield(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: !_isPasswordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10.h),

                  // Forgot Password
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                  InkWell(
                    onTap: showTryLaterMessage, 
                    hoverColor: Colors.blue.withOpacity(0.2), 
                    child: Text(
                      "Forgot password?",
                        style: TextStyle(
                          color: Colors.grey[600],
                          decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                  SizedBox(height: 25.h),
                  
                  // Continue Button
                  MyButton(
                    text: 'Continue',
                    onTap: signUserIn,
                  ),
                  SizedBox(height: 30.h),
                  
                  // Or Continue with
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[300],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Text(
                            "Or Continue with",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15.h),
                  
                  // Google and Apple Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SquareTile(
                        onTap: () => AuthService().signInWithGoogle(),
                        imagePath: "assets/images/google.png",
                      ),
                      SizedBox(width: 25.w),
                      SquareTile(
                        onTap: () {
                          Betaversion_showDialog();
                        },
                        imagePath: "assets/images/apple.png",
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  
                  // Sign Up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Not a member?",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      SizedBox(width: 4.w),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          "Sign up",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
