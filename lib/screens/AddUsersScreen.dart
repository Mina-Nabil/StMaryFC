import 'dart:io';

import 'package:StMaryFA/models/Category.dart';
import 'package:StMaryFA/models/Group.dart';
import 'package:StMaryFA/models/User.dart';
import 'package:StMaryFA/providers/CategoriesProvider.dart';
import 'package:StMaryFA/providers/GroupsProvider.dart';
import 'package:StMaryFA/providers/UsersProvider.dart';
import 'package:StMaryFA/screens/HomeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

enum UserScreenMode { add, view, edit }

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();

  UserScreen() {
    user = User.empty();
    mode = UserScreenMode.add;
  }

  UserScreen.view(this.user, {this.extra}) {
    mode = UserScreenMode.view;
  }

  User user;
  UserScreenMode mode;
  Widget extra;
}

class _UserScreenState extends State<UserScreen> {
  File _selectedImage;
  int _selectedGroupId;
  int _selectedCategoryId;

  final _formKey = GlobalKey<FormState>();
  bool confirmButtonEnable = true;
  final _nameController = TextEditingController();
  final _groupController = TextEditingController();
  final _categoryController = TextEditingController();
  final _birthdateController = TextEditingController();
  final _mobileNumController = TextEditingController();
  final _codeController = TextEditingController();
  final _notesController = TextEditingController();

  getImage(ImageSource source) async {
    final _picker = ImagePicker();
    PickedFile image = await _picker.getImage(source: source);
    if (image != null) {
      ImageCropper ic = new ImageCropper();
      File croppedImage = await ic.cropImage(
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
  void initState() {
    super.initState();
    fillForm();
    if (widget.mode == UserScreenMode.add) {
      loadMaxID();
    }
  }

  void fillForm() {
    _nameController.value = TextEditingValue(text: widget.user.userName);
    _groupController.value = TextEditingValue(text: widget.user.groupName);
    _categoryController.value = TextEditingValue(text: widget.user.categoryName ?? "");
    _selectedGroupId = widget.user.groupId;
    _selectedCategoryId = widget.user.categoryId;
    _birthdateController.value = TextEditingValue(text: widget.user.birthDate ?? "");
    _mobileNumController.value = TextEditingValue(text: widget.user.mobileNum ?? "");
    _codeController.value = TextEditingValue(text: widget.user.code ?? "");
    _notesController.value = TextEditingValue(text: widget.user.notes ?? "");
  }

  void loadMaxID() {
    int newID;
    Future.delayed(Duration.zero).then((value) async {
      newID = await Provider.of<UsersProvider>(context, listen: false).getNewCode();
      if (newID > 0) _codeController.value = TextEditingValue(text: newID.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle fieldTextStyle = _viewMode()
        ? Theme.of(context).textTheme.bodyMedium.copyWith(color: Colors.black54)
        : Theme.of(context).textTheme.bodyMedium;
    return Column(children: [
      Expanded(
          child: Container(
        padding: EdgeInsets.only(top: 15, left: 15, right: 15),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            border: Border.all(color: Color.fromRGBO(79, 50, 0, 1))),
        child: Stack(children: [
          ListView(
            children: [
              //Photo
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.width / 3,
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
                            child: AspectRatio(
                          aspectRatio: 1.0,
                          child: _getProfilePictureWidget(),
                        )),
                      ),
                      if (!_viewMode())
                        Align(
                            alignment: Alignment.bottomRight,
                            child: IconButton(
                                icon: Icon(
                                  Icons.camera_alt,
                                ),
                                onPressed: () => _addProfilePicture()))
                    ],
                  ),
                ),
              ),

              SizedBox(
                height: 10,
              ),

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
                        style: fieldTextStyle,
                        onChanged: null,
                        readOnly: _viewMode(),
                        controller: _nameController,
                        validator: (nameString) {
                          return nameString.isEmpty ? "*Required" : null;
                        },
                        onSaved: (nameString) {
                          widget.user.userName = nameString;
                        },
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: TextFormField(
                        decoration: InputDecoration(
                            suffixIcon: Icon(
                              FontAwesomeIcons.chevronDown,
                              color: Theme.of(context).primaryColor,
                            ),
                            hintText: "Group"),
                        style: widget.user.type == 1
                            ? Theme.of(context).textTheme.bodyMedium.copyWith(color: Colors.black54)
                            : fieldTextStyle,
                        onChanged: null,
                        readOnly: true,
                        controller: _groupController,
                        onSaved: (_) {
                          widget.user.groupId = _selectedGroupId;
                          widget.user.groupName = _groupController.value.text;
                        },
                        onTap: (_viewMode() || widget.user.type == 1)
                            ? null
                            : () async {
                                if (Provider.of<GroupsProvider>(context, listen: false).groups.isEmpty) {
                                  await Provider.of<GroupsProvider>(context, listen: false).loadGroups();
                                }
                                //sublist(1) to remove first group (Admins)
                                List<Group> groups = Provider.of<GroupsProvider>(context, listen: false).groups.sublist(1);

                                int selectedGroupIndex;
                                if (widget.user.groupId != 0) {
                                  selectedGroupIndex = groups.indexWhere((group) => group.id == widget.user.groupId);
                                } else {
                                  selectedGroupIndex = 0;
                                }

                                Group selectedGroup = groups[selectedGroupIndex];

                                showModalBottomSheet(
                                    backgroundColor: Colors.transparent,
                                    context: context,
                                    builder: (_) {
                                      return Container(
                                        decoration: new BoxDecoration(
                                            color: Colors.orangeAccent[100],
                                            borderRadius: new BorderRadius.only(
                                                topLeft: const Radius.circular(25.0), topRight: const Radius.circular(25.0))),
                                        height: MediaQuery.of(context).size.height / 3,
                                        child: Column(children: [
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  _groupController.value = TextEditingValue(text: selectedGroup.name);
                                                  _selectedGroupId = selectedGroup.id;
                                                  Navigator.pop(context);
                                                });
                                              },
                                              child: Text(
                                                "Done",
                                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: CupertinoPicker(
                                              scrollController: FixedExtentScrollController(initialItem: selectedGroupIndex),
                                              itemExtent: MediaQuery.of(context).size.height / 16,
                                              onSelectedItemChanged: (value) {
                                                selectedGroup = groups[value];
                                              },
                                              children: (groups.map((group) {
                                                return Center(child: Text(group.name));
                                              }).toList()),
                                            ),
                                          ),
                                        ]),
                                      );
                                    });
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
                            suffixIcon: Icon(
                              FontAwesomeIcons.chevronDown,
                              color: Theme.of(context).primaryColor,
                            ),
                            hintText: "Category"),
                        style: widget.user.type == 1
                            ? Theme.of(context).textTheme.bodyMedium.copyWith(color: Colors.black54)
                            : fieldTextStyle,
                        onChanged: null,
                        readOnly: true,
                        controller: _categoryController,
                        onSaved: (_) {
                          widget.user.categoryId = _selectedCategoryId;
                          widget.user.categoryName = _categoryController.value.text;
                        },
                        onTap: (_viewMode() || widget.user.type == 1)
                            ? null
                            : () async {
                                if (Provider.of<CategoriesProvider>(context, listen: false).categories.isEmpty) {
                                  await Provider.of<CategoriesProvider>(context, listen: false).loadCategories();
                                }
                                
                                List<Category> categories = Provider.of<CategoriesProvider>(context, listen: false).categories;

                                int selectedCategoryIndex = 0;
                                if (widget.user.categoryId != null && widget.user.categoryId > 0) {
                                  selectedCategoryIndex = categories.indexWhere((catg) => catg.id == widget.user.categoryId);
                                } else {
                                  selectedCategoryIndex = 0;
                                }

                                Category selectedCatg = categories[selectedCategoryIndex];

                                showModalBottomSheet(
                                    backgroundColor: Colors.transparent,
                                    context: context,
                                    builder: (_) {
                                      return Container(
                                        decoration: new BoxDecoration(
                                            color: Colors.orangeAccent[100],
                                            borderRadius: new BorderRadius.only(
                                                topLeft: const Radius.circular(25.0), topRight: const Radius.circular(25.0))),
                                        height: MediaQuery.of(context).size.height / 3,
                                        child: Column(children: [
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  _categoryController.value = TextEditingValue(
                                                      text: selectedCatg.title == null ? "N/A" : selectedCatg.title);
                                                  _selectedCategoryId = selectedCatg.id;
                                                  Navigator.pop(context);
                                                });
                                              },
                                              child: Text(
                                                "Done",
                                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: CupertinoPicker(
                                              scrollController: FixedExtentScrollController(initialItem: selectedCategoryIndex),
                                              itemExtent: MediaQuery.of(context).size.height / 16,
                                              onSelectedItemChanged: (value) {
                                                selectedCatg = categories[value];
                                              },
                                              children: (categories.map((catg) {
                                                return Center(child: Text(catg.title));
                                              }).toList()),
                                            ),
                                          ),
                                        ]),
                                      );
                                    });
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
                        style: fieldTextStyle,
                        readOnly: true,
                        controller: _birthdateController,
                        onTap: _viewMode()
                            ? null
                            : () {
                                showModalBottomSheet(
                                    backgroundColor: Colors.transparent,
                                    context: context,
                                    builder: (_) {
                                      return Container(
                                        decoration: new BoxDecoration(
                                            color: Colors.orangeAccent[100],
                                            borderRadius: new BorderRadius.only(
                                                topLeft: const Radius.circular(25.0), topRight: const Radius.circular(25.0))),
                                        height: MediaQuery.of(context).size.height / 4,
                                        child: CupertinoDatePicker(
                                          backgroundColor: Colors.transparent,
                                          mode: CupertinoDatePickerMode.date,
                                          initialDateTime: DateTime.now(),
                                          minimumYear: 1980,
                                          onDateTimeChanged: (DateTime date) {
                                            print(date.toString());
                                            setState(() {
                                              _birthdateController.value =
                                                  TextEditingValue(text: DateFormat('yyyy-MM-dd').format(date));
                                            });
                                          },
                                        ),
                                      );
                                    });
                              },
                        validator: (date) {
                          return date.isEmpty ? "*Required" : null;
                        },
                        onSaved: (date) {
                          widget.user.birthDate = date;
                        },
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: TextFormField(
                        decoration: InputDecoration(hintText: "Mobile"),
                        style: fieldTextStyle,
                        onChanged: null,
                        readOnly: _viewMode(),
                        keyboardType: TextInputType.number,
                        controller: _mobileNumController,
                        validator: (mobileNum) {
                          if (mobileNum.isNotEmpty && mobileNum.length != 11) return "*Non valid mobile number";
                          return null;
                        },
                        onSaved: (mobileNum) {
                          widget.user.mobileNum = mobileNum;
                        },
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: TextFormField(
                        decoration: InputDecoration(hintText: "Code"),
                        style: fieldTextStyle,
                        onChanged: null,
                        readOnly: _viewMode(),
                        controller: _codeController,
                        validator: (code) {
                          return code.isEmpty ? "*Required" : null;
                        },
                        onSaved: (code) {
                          widget.user.code = code;
                        },
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: TextFormField(
                        minLines: 2,
                        maxLines: 4,
                        decoration: InputDecoration(hintText: "Notes", contentPadding: EdgeInsets.all(5)),
                        style: fieldTextStyle,
                        onChanged: null,
                        readOnly: _viewMode(),
                        onSaved: (notes) {
                          widget.user.notes = notes;
                        },
                        controller: _notesController,
                      ),
                    ),
                  ],
                ),
              ),

              if (widget.extra != null) Container(margin: EdgeInsets.symmetric(vertical: 5), child: widget.extra)
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: _getControlIconButton(),
          ),
          if (widget.mode == UserScreenMode.edit) /*Cancel Icon*/
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                padding: EdgeInsets.zero,
                alignment: Alignment.topLeft,
                icon: FaIcon(
                  FontAwesomeIcons.xmark,
                ),
                onPressed: () {
                  setState(() {
                    widget.mode = UserScreenMode.view;
                    fillForm();
                  });
                },
              ),
            ),
        ]),
      ))
    ]);
  }

  void _onConfirm() async {
    FormState form = _formKey.currentState;

    if (!form.validate()) return;

    form.save();

    setState(() {
      confirmButtonEnable = false;
    });

    String errorMsg;
    if (_editMode()) {
      errorMsg = await Provider.of<UsersProvider>(context, listen: false).editUser(_selectedImage, widget.user);
    } else {
      errorMsg = await Provider.of<UsersProvider>(context, listen: false).addUser(_selectedImage, widget.user);
    }

    setState(() {
      confirmButtonEnable = true;
    });

    if (errorMsg.isEmpty) {
      if (_editMode()) {
        showCupertinoDialog(
            context: context,
            builder: (BuildContext context) => new CupertinoAlertDialog(
                  title: Text("Done"),
                  actions: [
                    CupertinoDialogAction(
                      child: Text(
                        "OK",
                        style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  ],
                ));

        //switch to view mode
        widget.mode = UserScreenMode.view;
      } else {
        //add mode
        showCupertinoDialog(
            context: context,
            builder: (BuildContext context) =>
                new CupertinoAlertDialog(title: Text("User Added"), content: Text("Add another user?"), actions: [
                  CupertinoDialogAction(
                      child: Text("Yes"),
                      onPressed: () {
                        setState(() {
                          clearForm();
                          Navigator.of(context).pop();
                          loadMaxID();
                        });
                      }),
                  CupertinoDialogAction(
                    child: Text("No"),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                  )
                ]));
      }
    } else {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) => new CupertinoAlertDialog(
                title: Text("Failed"),
                content: Text(errorMsg),
                actions: [
                  CupertinoDialogAction(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ));
    }
  }

  void clearForm() {
    widget.user.clear();

    _nameController.clear();
    _groupController.clear();
    _categoryController.clear();
    _birthdateController.clear();
    _mobileNumController.clear();
    _codeController.clear();
    _notesController.clear();
  }

  Widget _getProfilePictureWidget() {
    if (_viewMode()) {
      return widget.user.imageLink != ""
          ? Image.network(
              widget.user.imageLink,
              fit: BoxFit.fill,
            )
          : Icon(
              Icons.person,
              size: 100,
            );
    } else if (_editMode()) {
      return _selectedImage != null
          ? Image.file(
              _selectedImage,
              fit: BoxFit.fill,
            )
          : widget.user.imageLink != ""
              ? Image.network(
                  widget.user.imageLink,
                  fit: BoxFit.fill,
                )
              : Icon(
                  Icons.person,
                  size: 100,
                );
    } else {
      // addMode
      return _selectedImage != null
          ? Image.file(
              _selectedImage,
              fit: BoxFit.fill,
            )
          : Icon(
              Icons.person,
              size: 80,
            );
    }
  }

  Widget _getControlIconButton() {
    if (_viewMode()) {
      // View Edit icon and convert to Edit mode onPress
      return IconButton(
        padding: EdgeInsets.zero,
        alignment: Alignment.topRight,
        icon: Icon(Icons.edit),
        onPressed: () => setState(() => widget.mode = UserScreenMode.edit),
      );
    } else {
      // Edit & Add modes
      return IconButton(
        padding: EdgeInsets.zero,
        alignment: Alignment.topRight,
        icon: FaIcon(FontAwesomeIcons.check),
        onPressed: _onConfirm,
      );
    }
  }

  void _addProfilePicture() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (_) {
          return Container(
              decoration: new BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius:
                      new BorderRadius.only(topLeft: const Radius.circular(25.0), topRight: const Radius.circular(25.0))),
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
                          Icon(
                            Icons.file_upload,
                            size: 30,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Upload Photo",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
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
                          Icon(
                            Icons.camera_alt,
                            size: 30,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Take Photo",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        getImage(ImageSource.camera);
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ));
        });
  }

  bool _viewMode() {
    return widget.mode == UserScreenMode.view;
  }

  bool _editMode() {
    return widget.mode == UserScreenMode.edit;
  }
}
