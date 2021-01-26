import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImgListProvider with ChangeNotifier {
  List <File> imgList = [];
  File latestImage;
  final imgpicker = ImagePicker();

  Future getImageFromCamera() async {
    final pickedFile = await imgpicker.getImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      latestImage = File(pickedFile.path);
      imgList.add(latestImage);
      notifyListeners();
    } else {
      print('No image selected.');
    }
  }

  Future getImageFromGallery() async {
    final pickedFile = await imgpicker.getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      latestImage = File(pickedFile.path);
      imgList.add(latestImage);
    } else {
      print('No image selected.');
    }
  }

  void deleteImage(deletionIndex) {
    imgList.removeAt(deletionIndex);
      if (imgList.length == 0) {
        latestImage = null;
      } else {
        latestImage = imgList[imgList.length-1];
      }
    notifyListeners();
  }

  void clearAll() {
    imgList.clear();
    latestImage = null;
  }
}