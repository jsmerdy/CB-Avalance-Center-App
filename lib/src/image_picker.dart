
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'observation_page.dart';

class ImageFromGalleryEx extends StatefulWidget {
  final type;
  const ImageFromGalleryEx(this.type);

  @override
  ImageFromGalleryExState createState() => ImageFromGalleryExState(type);
}
class ImageFromGalleryExState extends State<ImageFromGalleryEx> {
  var _image;
  var imagePicker;
  var type;
  final List<String> _imagePaths = List<String>.empty(growable: true);

  ImageFromGalleryExState(this.type);

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(type == ImageSourceType.camera
              ? "Image from Camera"
              : "Image from Gallery")),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context,_imagePaths);
          return false;
        },
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 52,
            ),
            Center(
              child: GestureDetector(
                onTap: () async {
                  var source = type == ImageSourceType.camera
                      ? ImageSource.camera
                      : ImageSource.gallery;
                  XFile image = await imagePicker.pickImage(
                      source: source, imageQuality: 50, preferredCameraDevice: CameraDevice.front);
                  setState(() {
                    _image = File(image.path);
                    _imagePaths.add(image.path);
                  });
                },
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(
                      color: Colors.white),
                  child: _image != null
                      ? Image.file(
                    _image,
                    width: 200.0,
                    height: 200.0,
                    fit: BoxFit.fitHeight,
                  )
                      : Container(
                    decoration: const BoxDecoration(
                        color: Colors.white),
                    width: 200,
                    height: 200,
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}