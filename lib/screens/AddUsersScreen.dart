import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class AddUsersScreen extends StatefulWidget {
  @override
  _AddUsersScreenState createState() => _AddUsersScreenState();
}

class _AddUsersScreenState extends State<AddUsersScreen> {
  bool inProcess = false;

  File _selectedImage;

  getImage(ImageSource source) async {
    setState(() {
      inProcess = true;
    });
    final _picker = ImagePicker();
    PickedFile image = await _picker.getImage(source: source);
    if (image != null) {
      File croppedImage = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          maxWidth: 700,
          maxHeight: 700,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(),
          iosUiSettings: IOSUiSettings(
            showCancelConfirmationDialog: true,
          ));
      if (croppedImage != null) {
        _selectedImage = croppedImage;
      }
    }
    setState(() {
      inProcess = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.all(10),
      child: Column(

        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        
        children: [

          //Photo
          Container(
            height: MediaQuery.of(context).size.height/4,
            width: MediaQuery.of(context).size.height/4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Color.fromRGBO(79, 50, 0, 0.2),
                ),
              ),
            child: Stack(
              children: [
                  Center(
                      child: ClipOval(
                        child: _selectedImage == null ? 
                              Icon(Icons.person, color: Theme.of(context).primaryColor,size: 100,) : Image.file(_selectedImage),
                      ),
                  ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    icon: Icon(Icons.camera_alt, color: Colors.black,), 
                    onPressed: () => getImage(ImageSource.camera)
                  )
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}