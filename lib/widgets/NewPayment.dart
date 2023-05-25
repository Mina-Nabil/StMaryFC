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
  bool _open = false;
  bool addEnabled = true;

  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          GestureDetector(
            child: Container(
              height: 50,
              color: _open ? Color.fromRGBO(254, 250, 241, 1) : Colors.orange,
              child: Stack(
                children: [
                  Center(
                      child: Text(
                    "New Payment",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _open ? Colors.orange : Colors.white),
                  )),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: _open ? Icon(FontAwesomeIcons.chevronUp, color: Colors.orange) : Icon(FontAwesomeIcons.chevronDown, color: Colors.white),
                      ))
                ],
              ),
            ),
            onTap: () {
              setState(() {
                _open = !_open;
              });
            },
          ),
          if (_open)
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
                      Flexible(
                        flex: 1,
                        child: TextField(
                            readOnly: true,
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.black, fontSize: 18),
                            decoration: InputDecoration(
                              hintText: "Date",
                              border: InputBorder.none,
                            ),
                            controller: _dateController,
                            onTap: () {
                              DatePicker.showPicker(context,
                                  showTitleActions: true,
                                  pickerModel: CustomPicker(currentTime: DateTime.now()),
                                  theme: DatePickerTheme(
                                      headerColor: Colors.orange,
                                      backgroundColor: Colors.orangeAccent[100],
                                      itemStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                                      doneStyle: TextStyle(color: Colors.white, fontSize: 16)), onChanged: (date) {
                                _dateController.value = TextEditingValue(text: DateFormat('yyyy-MM').format(date));
                              }, onConfirm: (date) {
                                _dateController.value = TextEditingValue(text: DateFormat('yyyy-MM').format(date));
                              });
                            }),
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
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.orange),
                    child:
                        TextButton(onPressed: (addEnabled) ?  addPayment : null, child: Text("Add", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20))),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void addPayment() async {
    setState(() {
      //disable add button
      addEnabled = false;
    });
    String amount = _amountController.value.text;
    String date = _dateController.value.text;
    String note = _noteController.value.text;

    String errorMsg = "";

    if (amount.isEmpty)
      errorMsg = "Please enter payment amount.";
    else if (double.tryParse(amount) == null)
      errorMsg = "Amount should be number.";
    else if (date.isEmpty) errorMsg = "Please enter payment date.";

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
      String errorMsg = await PaymentsHelper.addPayment(widget.id, double.parse(amount), note, 1, date: date);

      if (errorMsg.isEmpty) {
        _amountController.clear();
        _dateController.clear();
        _noteController.clear();
        setState(() {
          _open = !_open;
        });
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
}
