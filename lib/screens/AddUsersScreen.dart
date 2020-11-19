import 'dart:io';

import 'package:StMaryFA/models/Group.dart';
import 'package:StMaryFA/providers/GroupsProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddUsersScreen extends StatefulWidget {
  @override
  _AddUsersScreenState createState() => _AddUsersScreenState();
}

class _AddUsersScreenState extends State<AddUsersScreen> {

  File _selectedImage;

  String _birthday = "";
  String dropdownValue = "Select";

  final _groupController = TextEditingController();
  final _birthdateController = TextEditingController();

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
                height: MediaQuery.of(context).size.height / 5,
                width: MediaQuery.of(context).size.height / 5,
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

            SizedBox(height: 10,),

            Form(
              //key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Name Text Field
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: TextFormField(
                      decoration: InputDecoration(hintText: "Name"),
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      onChanged: null,
                      validator: (nameString) {
                        return nameString.isEmpty ? "*Required" : null;
                      },
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: TextFormField(
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.arrow_drop_down,size: 30, color: Theme.of(context).primaryColor,),
                        hintText: "Group"
                      ),
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      onChanged: null,
                      readOnly: true,
                      controller: _groupController,
                      onTap: () {
                        List<Group> groups = Provider.of<GroupsProvider>(context, listen: false).groups;
                        _groupController.value = TextEditingValue(text:  groups[1].name);
                        showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context, 
                          builder: (_) {
                            return Container(
                              decoration: new BoxDecoration(
                                color: Colors.orangeAccent[100],
                                borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(25.0),
                                topRight: const Radius.circular(25.0))
                              ),

                              height: MediaQuery.of(context).size.height/4,
                              child: CupertinoPicker(
                                
                                itemExtent:  MediaQuery.of(context).size.height/16, 
                                onSelectedItemChanged: (value){
                                  print("micky");
                                    setState(() {
                                      // (+1) as we removed fist element "Admins" group
                                      _groupController.value = TextEditingValue(text: groups[value+1].name);
                                    });
                                }, 
                                children: (groups.map((group) {
                                  return Text(group.name);
                                }).toList()).sublist(1),
                              ),
                            );
                          }
                        );
                      },
                      validator: (nameString) {
                        return nameString.isEmpty ? "*Required" : null;
                      },
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Birth date",
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
                        showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context, 
                          builder: (_) {
                            return Container(
                              decoration: new BoxDecoration(
                                color: Colors.orangeAccent[100],
                                borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(25.0),
                                topRight: const Radius.circular(25.0))
                              ),

                              height: MediaQuery.of(context).size.height/4,
                              child: CupertinoDatePicker(

                                backgroundColor: Colors.transparent,
                                mode: CupertinoDatePickerMode.date,
                                initialDateTime: DateTime.now(),
                                minimumYear: 1980,
                                onDateTimeChanged: (DateTime date) {
                                  print(date.toString());
                                  setState(() {
                                    _birthday = DateFormat('yyyy-MM-dd').format(date);
                                    _birthdateController.value = TextEditingValue(text: _birthday);
                                  });
                                },
                                
                              ),
                            );
                          }
                        );
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
