import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SpeechRecording extends StatefulWidget {
  @override
  _SpeechRecordingState createState() => _SpeechRecordingState();
}

class _SpeechRecordingState extends State<SpeechRecording> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool isRecording = false;
  String? filePath;

  @override
  void initState() {
    super.initState();
    initializeRecorder();
  }

  Future<void> initializeRecorder() async {
    await Permission.microphone.request();
    await _recorder.openRecorder();
  }
  
  Future<void> startRecording() async {
  // Check if microphone permission is granted
  var micStatus = await Permission.microphone.status;

  if (micStatus.isGranted) {
    // If granted, start recording
    Directory tempDir = await getTemporaryDirectory();
    filePath = '${tempDir.path}/audio_recording.aac';
    await _recorder.startRecorder(toFile: filePath);
    setState(() {
      isRecording = true;
    });
  } else if (micStatus.isDenied || micStatus.isPermanentlyDenied) {
    // If denied, show a dialog to re-request permission
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Microphone Permission'),
          content: Text(
              'This app requires microphone access to record audio. Please allow microphone access.'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                var status = await Permission.microphone.request();
                if (status.isGranted) {
                  // If permission granted, start recording
                  Directory tempDir = await getTemporaryDirectory();
                  filePath = '${tempDir.path}/audio_recording.aac';
                  await _recorder.startRecorder(toFile: filePath);
                  setState(() {
                    isRecording = true;
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Microphone permission is required to record audio.'),
                  ));
                }
              },
              child: Text('Allow'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Microphone access is restricted or unavailable.'),
    ));
  }
}


  Future<void> stopRecording() async {
    await _recorder.stopRecorder();
    setState(() {
      isRecording = false;
    });
    uploadRecording();
  }

  Future<void> uploadRecording() async {
    if (filePath == null) return;

    File file = File(filePath!);

    try {
      List<int> bytes = await file.readAsBytes();
      String base64Audio = base64Encode(bytes);

      String username =
          FirebaseAuth.instance.currentUser?.displayName ?? FirebaseAuth.instance.currentUser?.uid ?? "Anonymous";

      await FirebaseFirestore.instance.collection('recordings').add({
        'audioData': base64Audio,
        'timestamp': FieldValue.serverTimestamp(),
        'username': username,
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.blue,
        content: Text('Recording uploaded and saved to Firestore!'),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.blue,
        content: Text('Failed to upload recording: $e'),
      ));
    }
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Voice Recorder',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.sp),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Recordings',
                  style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.h),
                TextField(
                  decoration: InputDecoration(
                  hintText: "Search Recordings",
                  prefixIcon:const Icon(Icons.search),
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 16.sp),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide:  BorderSide(color: Colors.blue.shade200, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Colors.blue, width: 1),
                  ),
                ),
                cursorColor: Colors.blueAccent,
              ),
                SizedBox(height: 20.h),
                Center(
                  child: GestureDetector(
                    onTap: isRecording ? stopRecording : startRecording,
                    child: CircleAvatar(
                      radius: 80.r,
                      backgroundColor: Colors.blue,
                      child: Icon(
                        isRecording ? Icons.stop : Icons.mic,
                        size: 60.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Can not upload file, Complete risk assessment is not available at the moment.',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.blueAccent,
                    ),
                  );
                },
                icon: const Icon(Icons.upload_file, color: Colors.blueAccent),
                label: const Text(
                  'Upload File',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
             ],
            ),
          ),
        ),
      ),
    );
  }
}