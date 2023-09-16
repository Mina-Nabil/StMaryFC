import 'package:StMaryFA/helpers/PaymentsHelper.dart';
import 'package:StMaryFA/helpers/SmsHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SendSMS extends StatefulWidget {
  SendSMS(this.id);

  final int id;

  @override
  _SendSMSState createState() => _SendSMSState();
}

class _SendSMSState extends State<SendSMS> {
  bool addEnabled = true;

  final _formKey = GlobalKey<FormState>();
  final _msgController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          GestureDetector(
            child: Container(
              height: 50,
              color: Color.fromRGBO(254, 250, 241, 1),
              child: Stack(
                children: [
                  Center(
                      child: Text(
                    "Send Parent Message",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange),
                  )),
                ],
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  child: TextField(
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.black, fontSize: 18),
                    decoration: InputDecoration(
                      hintText: "Note",
                      border: InputBorder.none,
                    ),
                    controller: _msgController,
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.deepOrange),
                  child: TextButton(
                      onPressed: (addEnabled) ? sendMessage : null,
                      child: Text(addEnabled ? "Send Message" : "Sending...",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void sendMessage() async {
    setState(() {
      //disable add button
      addEnabled = false;
    });
    String msg = _msgController.value.text;

    String errorMsg = "";

    if (msg.isEmpty) errorMsg = "Please enter the message content.";

    if (errorMsg.isNotEmpty) {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) => new CupertinoAlertDialog(
                title: Text("Failed"),
                content: Text(errorMsg),
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

      setState(() {
        //disable add button
        addEnabled = true;
      });
    } else {
      String errorMsg = await SmsHelper.sendSms(widget.id, msg);

      if (errorMsg.isEmpty) {
        _msgController.clear();

        showCupertinoDialog(
            context: context,
            builder: (BuildContext context) => new CupertinoAlertDialog(
                  title: Text("Done"),
                  content: Text("Sent successfully"),
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
      } else {
        showCupertinoDialog(
            context: context,
            builder: (BuildContext context) => new CupertinoAlertDialog(
                  title: Text("Failed"),
                  content: Text(errorMsg),
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
      }
      setState(() {
        //enable add
        addEnabled = true;
      });
    }
  }
}
