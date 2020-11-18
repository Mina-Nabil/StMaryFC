import 'package:StMaryFA/providers/GroupsProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupsScreen extends StatefulWidget {
  @override
  _GroupsScreenState createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  //UI vars
  final double radius = 10;

  //Form Vars
  final _formKey = GlobalKey<FormState>();
  final TextEditingController grpName = new TextEditingController();
  void submitForm() {
    print("EDAS 3ala weshy");
    if (_formKey.currentState.validate()) {
      Provider.of<GroupsProvider>(context, listen: false).addGroup(grpName.value.text);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero).then((value) => Provider.of<GroupsProvider>(context, listen: false).loadGroups());
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> formWidgets = [
      GroupLabel("Add New"),
      Form(
        key: _formKey,
        child: Container(
          height: 80,
          child: TextFormField(
            controller: grpName,
            validator: (v) {
              return (v.length < 2) ? "Very Short Name" : null;
            },
            textAlign: TextAlign.left,
            style: TextStyle(color: Colors.black, fontSize: 24),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.add),
            ),
          ),
        ),
      ),
      Container(
        height: 50,
        // margin: EdgeInsets.symmetric(vertical: 5),
        child: FlatButton(
          padding: EdgeInsets.all(0),
          onPressed: submitForm,
          child: Container(
              decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(radius)),
              alignment: Alignment.center,
              child: FittedBox(child: Text("Add", style: TextStyle(fontFamily: "Anton", color: Colors.white, fontSize: 24)))),
        ),
      ),
    ];
    return Column(
      children: [
        Expanded(
          child: Container(
            // margin: EdgeInsets.symmetric(horizontal: 20, vertical:20),
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            child: ListView(
                children: []
                  ..addAll(formWidgets)
                  ..addAll([
                    GroupLabel("Groups"),
                    ...Provider.of<GroupsProvider>(context, listen: true).groups.map((e) => Container(
                          child: Text(e.name),
                        ))
                  ])),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    grpName.dispose();
    super.dispose();
  }
}

class GroupLabel extends StatelessWidget {
  final String label;
  const GroupLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        margin: EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.centerLeft,
        child: FittedBox(
            child: Text(
          label,
          style: TextStyle(fontSize: 24, fontFamily: "Anton"),
        )));
  }
}
