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
    double photoDiameterRatio = 0.4;

    var imagePlaceholder = Container(
   
        width: MediaQuery.of(context).size.width * photoDiameterRatio,
        height: double.infinity,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
   
        ),
        child: Container(
          child: FractionallySizedBox(
            heightFactor: 0.65,
            widthFactor: 0.65,
            child: Icon(Icons.person_add),
          ),
        ));
    return Stack(
      children: [
        Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  flex: 3,
                  child: (_selectedImage == null)
                      ? imagePlaceholder
                      : ClipOval(
                          child: Image.file(_selectedImage),
                        )),
              Flexible(
                flex: 2,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FlatButton( 
                        child: Icon(Icons.person_add),
                        color: Colors.black,
                        onPressed: () => getImage(ImageSource.camera), //() => getImage(ImageSource.gallery),
                       )
                      
                    ],
                  ),
                ),
              ),
          
            ],
          ),
        (inProcess)
            ? Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: CircularProgressIndicator(),
                ))
            : Container()
      ],
    );
  }
}