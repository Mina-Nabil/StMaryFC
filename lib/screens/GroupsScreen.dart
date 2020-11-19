import 'package:StMaryFA/providers/GroupsProvider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class GroupsScreen extends StatefulWidget {
  @override
  _GroupsScreenState createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  //UI vars
  final double radius = 10;

  void showGroupsDialog(context, String title, String msg) {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text(title),
              content: new Text(msg),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }

  //Form Vars
  final _formKey = GlobalKey<FormState>();
  final TextEditingController grpName = new TextEditingController();
  void submitForm() async {
    if (_formKey.currentState.validate()) {
      bool res = await Provider.of<GroupsProvider>(context, listen: false).addGroup(grpName.value.text);
      if (!res) {
        showGroupsDialog(context, "Warning", "Failed to Add Group - Check duplicate Name or internet connection");
      } else {
        showGroupsDialog(context, "Done", "New Group Added");
        grpName.clear();
        FocusScope.of(context).unfocus();
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero).then((value) => Provider.of<GroupsProvider>(context, listen: false).loadGroups());
  }

  void delGroup(id) async {
    Provider.of<GroupsProvider>(context, listen: false).delGroup(id);
  }

  void toggle(id) async {
    Provider.of<GroupsProvider>(context, listen: false).toggleGroup(id);
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
            padding: EdgeInsets.symmetric(horizontal: 25),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(25)), border: Border.all(color: Color.fromRGBO(79, 50, 0, 1))),
            child: ListView(
                children: []
                  ..addAll(formWidgets)
                  ..addAll([
                    GroupLabel("Groups"),
                    ...Provider.of<GroupsProvider>(context, listen: true).groups.map((e) => Container(
                          child: Card(
                            child: Dismissible(
                                background: Container(
                                    color: Colors.red,
                                    padding: EdgeInsets.only(right: 20.0),
                                    alignment: Alignment.centerRight,
                                    child: FaIcon(FontAwesomeIcons.trashAlt, color: Colors.white)),
                                dismissThresholds: {DismissDirection.endToStart: 0.6},
                                key: UniqueKey(),
                                onDismissed: (direction) => delGroup(e.id),
                                direction: (e.count == 0) ? DismissDirection.endToStart : null,
                                child: ListTile(
                                    tileColor: Color.fromRGBO(254, 250, 241, 1),
                                    trailing: Text("Kids: ${e.count}"),
                                    leading: IconButton(
                                        onPressed: () => toggle(e.id),
                                        icon: FaIcon(FontAwesomeIcons.solidFutbol, color: (e.isActive) ? Colors.green : Colors.red)),
                                    title: Text(e.name, style: TextStyle(fontSize: 18)))),
                          ),
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
