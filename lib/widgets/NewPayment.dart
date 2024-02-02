import 'package:StMaryFA/helpers/PaymentsHelper.dart';
import 'package:StMaryFA/widgets/CustomDatePicker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class NewPayment extends StatefulWidget {
  NewPayment(this.id, {this.onPaymentAdd});

  final int id;
  final Function onPaymentAdd;
  @override
  _NewPaymentState createState() => _NewPaymentState();
}

class _NewPaymentState extends State<NewPayment> {
  bool addEnabled = true;
  bool _isSettlment = false;

  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

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
                    "New Payment",
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
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: TextFormField(
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.black, fontSize: 18),
                        decoration: InputDecoration(
                          hintText: "Amount",
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.number,
                        controller: _amountController,
                      ),
                    ),
                  ],
                ),
                Container(
                  child: TextField(
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.black, fontSize: 18),
                    decoration: InputDecoration(
                      hintText: "Note",
                      border: InputBorder.none,
                    ),
                    controller: _noteController,
                  ),
                ),
                Container(
                  color: Color.fromRGBO(254, 250, 241, 1),
                  child: Row(
                    children: [
                      ButtonBar(
                        children: [
                          Radio(
                            value: false,
                            groupValue: _isSettlment,
                            onChanged: (val) => selectRadioState(val),
                            activeColor: Colors.orange,
                            toggleable: true,
                          ),
                          FittedBox(child: Text("Payment")),
                          Radio(
                            value: true,
                            groupValue: _isSettlment,
                            onChanged: (val) => selectRadioState(val),
                            activeColor: Colors.orange,
                            toggleable: true,
                          ),
                          FittedBox(child: Text("Settlment")),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.orange),
                  child: TextButton(
                      onPressed: (addEnabled) ? addPayment : null,
                      child: Text("Add", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20))),
                ),
                Container(
                  color: Color.fromRGBO(254, 250, 241, 1),
                  padding: EdgeInsets.all(2),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.deepOrange),
                  child: TextButton(
                      onPressed:
                          (addEnabled) ? () => confirmThen("Send SMS", "Are you sure you want to send SMS?", sendReminder) : null,
                      child: Text("Send Reminder",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20))),
                ),
                Container(
                  color: Color.fromRGBO(254, 250, 241, 1),
                  padding: EdgeInsets.all(2),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.deepOrange),
                  child: TextButton(
                      onPressed: (addEnabled)
                          ? () => confirmThen("Send SMS", "Are you sure you want to send SMS?", sendLastUpdate)
                          : null,
                      child: Text("Send Last Balance Update",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  selectRadioState(bool val) {
    setState(() {
      _isSettlment = val;
    });
  }

  void confirmThen(title, message, Function callback) async {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => new CupertinoAlertDialog(
              title: Text(title),
              content: Text(message),
              actions: [
                CupertinoDialogAction(
                  child: Text(
                    "Yes",
                    style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    callback();
                  },
                ),
                CupertinoDialogAction(
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ));
  }

  void addPayment() async {
    setState(() {
      //disable add button
      addEnabled = false;
    });
    String amount = _amountController.value.text;
    String note = _noteController.value.text;

    String errorMsg = "";

    if (amount.isEmpty)
      errorMsg = "Please enter payment amount.";
    else if (double.tryParse(amount) == null) errorMsg = "Amount should be number.";

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
    } else {
      String errorMsg = await PaymentsHelper.addPayment(widget.id, double.parse(amount), note, 1, isSettlment: _isSettlment);

      if (errorMsg.isEmpty) {
        _amountController.clear();
        _noteController.clear();

        widget.onPaymentAdd();
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

  void sendReminder() async {
    setState(() {
      //disable add button
      addEnabled = false;
    });

    String errorMsg = await PaymentsHelper.sendBalanceReminder(widget.id);

    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => new CupertinoAlertDialog(
              title: Text(errorMsg.isEmpty ? "Done" : "Failed"),
              content: Text(errorMsg.isEmpty ? "Message Sent" : errorMsg),
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
      //enable add
      addEnabled = true;
    });
  }

  void sendLastUpdate() async {
    setState(() {
      //disable add button
      addEnabled = false;
    });

    String errorMsg = await PaymentsHelper.sendLastUpdate(widget.id);

    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => new CupertinoAlertDialog(
              title: Text(errorMsg.isEmpty ? "Done" : "Failed"),
              content: Text(errorMsg.isEmpty ? "Message Sent" : errorMsg),
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
      //enable add
      addEnabled = true;
    });
  }
}
