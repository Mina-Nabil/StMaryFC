import 'package:StMaryFA/providers/UsersProvider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AttendanceList extends StatefulWidget {
  const AttendanceList(this.id, this.year, this.month);

  final int id;
  final String year;
  final String month;

  @override
  State<AttendanceList> createState() => _AttendanceListState();
}

class _AttendanceListState extends State<AttendanceList> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((_) async {
      await Provider.of<UsersProvider>(context, listen: false)
          .loadAttendanceDetails(widget.id.toString(), widget.year, widget.month);
      print(Provider.of<UsersProvider>(context, listen: false).attendanceDetails);
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (isLoading)
          Center(
            child: CircularProgressIndicator(color: Colors.orange),
          ),
        if (!isLoading)
          Center(
            child: Container(
                     decoration: BoxDecoration(color: Color.fromARGB(255, 255, 239, 218), borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))),
                padding: EdgeInsets.only(top: 30),
                child: Column(
                  children: [
                    Container(
                      height: 30,
                      child: Text(widget.month + ' ' + widget.year + ' Attendance'),
                    ),
                    Container(
                        height: 440,
                        child: ListView(
                            children: Provider.of<UsersProvider>(context, listen: false)
                                .attendanceDetails
                                .map((e) => ListTile(
                                      leading: Icon(FontAwesomeIcons.circleArrowRight),
                                      title: Text(e),
                                    ))
                                .toList())),
                  ],
                )),
          )
      ],
    );
  }
}
