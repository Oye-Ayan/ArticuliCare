import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:articulicare/pages/signIn/signUp/auth_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the AuthPage after a delay
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                    height: 350.h, 
                    width: 350.h,  
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle, 
                      image: DecorationImage(
                        image: AssetImage('assets/images/splash_logo.png'),
                        fit: BoxFit.cover, 
                      ),
                    ),
                  ),
            SizedBox(height: 20.h),
            Center(
              child: Padding(
                padding:  EdgeInsets.all(10.w),
                child: Text(textAlign: TextAlign.center,
                  'ArticuliCare',
                  style: TextStyle(fontSize: 28.sp, color: Colors.blue.shade800, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 10.w),
                child: Text(textAlign: TextAlign.center,
                  'Speak with Confidence, \n Improve with ArticuliCare',
                  style: TextStyle(fontSize: 20.sp, color: Colors.blue.shade600,fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
