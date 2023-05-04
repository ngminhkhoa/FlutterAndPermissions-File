import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  File? _image;

  @override
  void initState() {
    super.initState();

    handlePermission();
  }

  void handlePermission() async {
    requestMultiplePermissions();

    // var statusPermission = await requestSinglePermission();
    //
    // if (statusPermission == PermissionStatus.permanentlyDenied) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text("Need access permission location")));
    // }
  }

  Future<PermissionStatus?> requestSinglePermission() async {
    final status = await Permission.location.request();
    if (status == PermissionStatus.permanentlyDenied) {
      return PermissionStatus.permanentlyDenied;
    } else if (status == PermissionStatus.denied) {
      return PermissionStatus.denied;
    } else if (status == PermissionStatus.granted) {
      return PermissionStatus.granted;
    }
    return null;
  }

  void requestMultiplePermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.camera,
      Permission.microphone,
      Permission.storage
    ].request();

    print(statuses[Permission.camera]);
    print(statuses[Permission.microphone]);
    print(statuses[Permission.storage]);
  }

  void requestPickImage() async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Do something with the picked image
      print(pickedFile.path);
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Permission'),
        toolbarHeight: 60,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: _image != null
                  ? Image(
                      image: FileImage(_image!),
                      width: 400, // set the width
                      height: 400, // set the height
                      fit: BoxFit.cover, // set the fit mode
                    )
                  : Text('No image selected'),
            ),
            Container(
              child: MaterialButton(
                onPressed: () {
                  requestPickImage();
                },
                child: Text("Click me"),
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
