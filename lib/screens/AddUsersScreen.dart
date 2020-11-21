import 'dart:io';

import 'package:StMaryFA/models/Group.dart';
import 'package:StMaryFA/providers/GroupsProvider.dart';
import 'package:StMaryFA/providers/UsersProvider.dart';
import 'package:StMaryFA/screens/HomeScreen.dart';
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
  String _name ;
  int _groupId;
  String _birthday;
  String _mobileNum;
  String _code;
  String _notes;

  final _formKey = GlobalKey<FormState>();
  bool  confirmButtonEnable = true;
  final _nameController = TextEditingController();
  final _groupController = TextEditingController();
  final _birthdateController = TextEditingController();
  final _mobileNumController = TextEditingController();
  final _codeController = TextEditingController();
  final _notesController = TextEditingController();

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
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
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
                            onPressed: () => _addProfilePicture()))
                  ],
                ),
              ),
            ),

            SizedBox(height: 10,),

            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Name Text Field
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: TextFormField(
                      decoration: InputDecoration(hintText: "Name"),
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      onChanged: null,
                      controller: _nameController,
                      validator: (nameString) {
                        return nameString.isEmpty ? "*Required" : null;
                      },
                      onSaved: (nameString) {_name = nameString;},
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
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
                        _groupId = groups[1].id;

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
                                    setState(() {
                                      // (+1) as we removed fist element "Admins" group
                                      _groupController.value = TextEditingValue(text: groups[value+1].name);
                                      _groupId = groups[value+1].id;
                                    });
                                }, 
                                children: (groups.map((group) {
                                  return Center(child: Text(group.name));
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
                    margin: EdgeInsets.symmetric(vertical: 5),
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
                                    _birthdateController.value = TextEditingValue(text: DateFormat('yyyy-MM-dd').format(date));
                                  });
                                },
                                
                              ),
                            );
                          }
                        );
                      },
                      validator: (date) {
                        return date.isEmpty ? "*Required" : null;
                      },
                      onSaved: (date) {_birthday = date;},
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: TextFormField(
                      decoration: InputDecoration(hintText: "Mobile"),
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      onChanged: null,
                      keyboardType: TextInputType.number,
                      controller: _mobileNumController,
                      validator: (mobileNum) {
                        if(mobileNum.isNotEmpty && mobileNum.length != 11)
                          return "*Non valid mobile number";
                        return null;
                      },
                      onSaved: (mobileNum) {_mobileNum = mobileNum;},
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: TextFormField(
                      decoration: InputDecoration(hintText: "Code"),
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      onChanged: null,
                      controller: _codeController,
                      onSaved: (code) {_code = code;},
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: TextFormField(
                      maxLines: 3,
                      decoration: InputDecoration(hintText: "\nNotes"),
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      onChanged: null,
                      onSaved: (notes) {_notes = notes;},
                      controller: _notesController,
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    width: double.infinity,
                    decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(10)),
                    child: FlatButton(
                      child: Text("Confirm",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        )
                      ),
                      onPressed: confirmButtonEnable ? () => _onConfirm() : null,
                    ),
                  ),

                  SizedBox(height: 20,)
                ],
              ),
            ),
          ],
        ),
      ))
    ]);
  }

  void _onConfirm() async {

    FormState form = _formKey.currentState;

    if (!form.validate())
      return;

    form.save();

    setState(() {
      confirmButtonEnable = false;
    });

    String errorMsg = await Provider.of<UsersProvider>(context,listen: false).addUser(_selectedImage, _name, _groupId, _birthday, _mobileNum, _code, _notes);

    setState(() {
      confirmButtonEnable = true;
    });

    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => new CupertinoAlertDialog(
              title: errorMsg.isEmpty? Text("User Added") : Text("Failed"),
              content: errorMsg.isEmpty? Text("Add another user?") : Text(errorMsg),
              actions: errorMsg.isEmpty? [
                CupertinoDialogAction(child: Text("Yes"), onPressed: () {
                  setState(() {
                    clearForm();
                    Navigator.of(context).pop();
                  });
                }
                ),
                CupertinoDialogAction(child: Text("No"), onPressed: () {
                  //TODO popUntil is better
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },)
              ] : 
              [
                CupertinoDialogAction(child: Text("OK"), onPressed: () {
                  Navigator.of(context).pop();
                },)
              ],
            ));
  }

  void clearForm() {
    //_selectedImage, 
    _name = _birthday = _mobileNum =  _code = _notes = "";
    _groupId = 0;
    
    _nameController.clear();
    _groupController.clear();
    _birthdateController.clear();
    _mobileNumController.clear();
    _codeController.clear();
    _notesController.clear();
    
  }

  void _addProfilePicture() {
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

          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 20, top: 20, bottom: 10),
                child: InkWell(
                  child: Row(
                    children: [
                    Icon(Icons.file_upload, size: 30,),
                    SizedBox(width: 10,),
                    Text("Upload Photo", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    ],
                  ),
                  onTap: () {
                    getImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, top: 10, bottom: 20),
                
                child: InkWell(
                  child: Row(
                    children: [
                    Icon(Icons.camera_alt,size: 30,),
                    SizedBox(width: 10,),
                    Text("Take Photo",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    ],
                  ),
                  onTap: () {
                    getImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          )   
        );
      }
    );
  }
}
