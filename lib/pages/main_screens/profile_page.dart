import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart'; 

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String? profileImagePath;
  String? userName;
  TextEditingController _usernameController = TextEditingController();
  bool isEditingUsername = false;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
    _getUserName();
  }

  // Function to get the username from Firebase Auth
  void _getUserName() {
    User? user = auth.currentUser;
    if (user != null) {
      setState(() {
        userName = user.displayName ?? "Guest";
        _usernameController.text = userName!;
      });
    }
  }
//function to show dialog box
void Betaversion_showDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
    return AlertDialog(
    title: Text('Beta Version'),
      content: Text('Complete Module is not available at the moment.',),
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
  // Function to load the saved profile image from local storage
  Future<void> _loadProfileImage() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/profile_picture.png';
    if (File(filePath).existsSync()) {
      setState(() {
        profileImagePath = filePath;
      });
    }
  }

  // Function to upload and save a profile picture
  Future<void> uploadProfilePicture() async {
    final cameraPermission = await Permission.camera.request();
    final storagePermission = await Permission.storage.request();

    if (cameraPermission.isGranted && storagePermission.isGranted) {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                CircularProgressIndicator(color: Colors.blue,),
                SizedBox(width: 20),
                Text('Uploading image...'),
              ],
            ),
          ),
        );

        await Future.delayed(const Duration(seconds: 2));

        try {
          final directory = await getApplicationDocumentsDirectory();
          final savedImagePath = '${directory.path}/profile_picture.png';
          final newImage = await File(image.path).copy(savedImagePath);

          await FileImage(newImage).evict();

          setState(() {
            profileImagePath = savedImagePath;
          });

          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile picture updated successfully!'),
              backgroundColor: Colors.blue,),
            );
          });
        } catch (error) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to upload image: $error'),
            backgroundColor: Colors.blue,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No image selected.'), 
          backgroundColor: Colors.blue,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permissions denied. Please allow access to camera and storage.'),
        backgroundColor: Colors.blue,
        ),
      );

      if (cameraPermission.isPermanentlyDenied || storagePermission.isPermanentlyDenied) {
        await openAppSettings();
      }
    }
  }
  Future<void> _saveUserName() async {
    User? user = auth.currentUser;
    if (user != null) {
      try {
        await user.updateDisplayName(_usernameController.text);
        setState(() {
          userName = _usernameController.text;
        });
        FocusScope.of(context).unfocus();
        setState(() {
          isEditingUsername = false; 
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Username updated successfully!'),backgroundColor: Colors.blue),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update username: $error'), backgroundColor: Colors.blue),
          
        );
      }
    }
  }
  void signUserOut() {
    auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Profile",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    key: ValueKey(profileImagePath),
                    backgroundImage: profileImagePath != null
                        ? FileImage(File(profileImagePath!))
                        : AssetImage('assets/images/profile1.jpg') as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: uploadProfilePicture,
                      child: Container(
                        padding: EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                        ),
                        child: Icon(Icons.camera_alt, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isEditingUsername
                  ? Container(
                      width: 200,
                      child: TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          hintText: 'Enter username',
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue), 
                          ),
                        ),
                        cursorColor: Colors.blue, 
                        onEditingComplete: () {
                          _saveUserName(); 
                          FocusScope.of(context).unfocus(); 
                        },
                      ),
                    )
                  : Text(
                      userName != null ? userName! : '@your_username',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  setState(() {
                    isEditingUsername = !isEditingUsername; // Toggle edit mode
                  });
                  if (!isEditingUsername) {
                    _saveUserName(); // Save username when user exits editing mode
                  }
                },
              ),
            ],
          ),

            SizedBox(height: 5.h),
            // Streak and Goal
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Column(
            //       children: [
            //         Icon(Icons.local_fire_department, color: Colors.blue),
            //         Text('STREAK'),
            //         Text('0'),
            //       ],
            //     ),
            //     SizedBox(width: 40),
            //     Column(
            //       children: [
            //         Icon(Icons.flag, color: Colors.blue),
            //         Text('GOAL'),
            //         Text('5'),
            //       ],
            //     ),
            //   ],
            // ),
            Divider(height: 40, thickness: 1),
            // Settings
            ListTile(
              leading: Icon(Icons.person, color: Colors.blue),
              title: Text('Profile'),
              trailing: TextButton(
                onPressed: () {
                  Betaversion_showDialog();
                },
                child: Text('Edit', style: TextStyle(color: Colors.blue.shade400)),
              ),
            ),
            ListTile(
              leading: Icon(Icons.bar_chart, color: Colors.blue),
              title: Text('Statistics'),
              trailing: TextButton(onPressed:(){
                Betaversion_showDialog();
                },
                 child: Text('View stats', style: TextStyle(color: Colors.blue.shade400))),
            ),
            ListTile(
              leading: Icon(Icons.notifications, color: Colors.blue),
              title: Text('Practice Reminder'),
              trailing: TextButton(onPressed:() {
                Betaversion_showDialog();
              },
              child: Text('Not set', style: TextStyle(color: Colors.blue.shade400))),
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.blue),
              title: Text('Notification'),
              trailing: TextButton(onPressed:(){
                Betaversion_showDialog();
              },
              child: Text('On', style: TextStyle(color: Colors.blue.shade400))),
            ),
            Divider(height: 40.h, thickness: 1.sp),
            // Other Actions
            ListTile(
              leading: Icon(Icons.featured_play_list, color: Colors.blue),
              title: Text('Request a feature'),
              onTap: Betaversion_showDialog,
            ),
            ListTile(
              leading: Icon(Icons.share, color: Colors.blue),
              title: Text('Share this app'),
              onTap: Betaversion_showDialog,
            ),
            ListTile(
              leading: Icon(Icons.contact_support, color: Colors.blue),
              title: Text('Contact us'),
              onTap: Betaversion_showDialog,
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.blue),
              title: Text('Log Out'),
              onTap: signUserOut,
            ),
            ListTile(
              leading: Icon(Icons.pin_end_outlined, color: Colors.blue,),
              title: Text("Privacy Policy"),
              onTap: Betaversion_showDialog,
            ),
          ],
        ),
      ),
    );
  }
}
