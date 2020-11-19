import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddUsersScreen extends StatefulWidget {
  @override
  _AddUsersScreenState createState() => _AddUsersScreenState();
}

class _AddUsersScreenState extends State<AddUsersScreen> {
  File _selectedImage;

  String _birthday = "";
  String dropdownValue = "Select";
  final _birthdateController = TextEditingController();

  final List<DropdownMenuItem<String>> myItems = [
    DropdownMenuItem<String>(
      value: "B1",
      child: Text("B1"),
    ),
    DropdownMenuItem<String>(
      value: "B2",
      child: Text("B2"),
    )
  ];

  getImage(ImageSource source) async {
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
        setState(() {
          _selectedImage = croppedImage;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        decoration:
            BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(25)), border: Border.all(color: Color.fromRGBO(79, 50, 0, 1))),
        child: ListView(
          children: [
            //Photo
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height / 4,
                width: MediaQuery.of(context).size.height / 4,
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
                        child: _selectedImage == null
                            ? Icon(
                                Icons.person,
                                color: Theme.of(context).primaryColor,
                                size: 100,
                              )
                            : Image.file(_selectedImage),
                      ),
                    ),
                    Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                            icon: Icon(
                              Icons.camera_alt,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: () => getImage(ImageSource.camera)))
                  ],
                ),
              ),
            ),

            Form(
              //key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 2, bottom: 2),
                    child: Text("Name", style: TextStyle(color: Colors.black, fontSize: 20)),
                  ),
                  //Name Text Field
                  Container(
                    child: TextFormField(
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      onChanged: null,
                      validator: (nameString) {
                        return nameString.isEmpty ? "Please fill your Email" : null;
                      },
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 2, bottom: 2),
                    child: Text("Group", style: TextStyle(color: Colors.black, fontSize: 20)),
                  ),
                  //Group Text Field

                  Container(
                    child: DropdownButtonFormField<String>(
                      value: myItems[0].value,
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Theme.of(context).primaryColor,
                        size: 30,
                      ),
                      iconSize: 24,
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;
                        });
                      },
                      items: myItems,
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 2, bottom: 2),
                    child: Text("Birth date", style: TextStyle(color: Colors.black, fontSize: 20)),
                  ),
                  Container(
                    child: TextFormField(
                      decoration: InputDecoration(
                          suffixIcon: Icon(
                        Icons.date_range,
                        size: 24,
                        color: Theme.of(context).primaryColor,
                      )),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                      readOnly: true,
                      controller: _birthdateController,
                      onTap: () {
                        showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1980), lastDate: DateTime.now()).then((date) {
                          setState(() {
                            _birthday = DateFormat('yyyy-MM-dd').format(date);
                            _birthdateController.value = TextEditingValue(text: _birthday);
                          });
                        });
                      },
                      validator: (groupString) {
                        return groupString.isEmpty ? "Please fill the birthdate" : null;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ))
    ]);
  }
}
