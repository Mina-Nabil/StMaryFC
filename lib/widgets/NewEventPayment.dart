import 'package:StMaryFA/helpers/PaymentsHelper.dart';
import 'package:StMaryFA/models/Event.dart';
import 'package:StMaryFA/providers/EventsProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class NewEventPayment extends StatefulWidget {
  NewEventPayment(this.id, {this.onPaymentAdd});
  
  final int id;
  final Function onPaymentAdd;
  @override
  _NewPaymentState createState() => _NewPaymentState();
}

class _NewPaymentState extends State<NewEventPayment> {
  
  bool _open = false;

  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _eventController = TextEditingController();
  final _noteController = TextEditingController();
  
  Event _event;
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
                      child: Text("New Payment",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _open ? Colors.orange : Colors.white),
                      )
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: _open ? Icon(FontAwesomeIcons.chevronUp, color: Colors.orange) :
                                       Icon(FontAwesomeIcons.chevronDown, color: Colors.white) ,
                      )
                    )
                  ],
                ),
              ),
              onTap: () {
                setState(() {
                  _open = !_open;
                });
              },
            ),
            if(_open)
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
                            hintText: "Event",
                            border: InputBorder.none,
                          ),
                          controller: _eventController,
                          onTap: () {
                            showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context, 
                              builder: (_) {
                                Event selectedEvent;
                                return Container(
                                  decoration: new BoxDecoration(
                                    color: Colors.orangeAccent[100],
                                    borderRadius: new BorderRadius.only(
                                      topLeft: const Radius.circular(15.0),
                                      topRight: const Radius.circular(15.0))
                                  ),
                                  height: MediaQuery.of(context).size.height/3,
                                  child: Column(
                                    children:[
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: FlatButton(
                                          onPressed: (){
                                            setState(() {
                                              _eventController.value = TextEditingValue(text: selectedEvent.name);
                                              _event = selectedEvent;
                                               Navigator.pop(context);
                                            });
                                          }, 
                                          child: Text("Done", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold ),),
                                        ),
                                      ),
                                      Expanded(
                                        child: FutureBuilder(
                                        future: Provider.of<EventsProvider>(context, listen: false).events == null? Provider.of<EventsProvider>(context, listen: false).loadEvents() : null,
                                        builder: (context, snapshot) {
                                          if(snapshot.connectionState == ConnectionState.waiting) {
                                            return Container(
                                              child: Center(
                                                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),backgroundColor: Colors.orange,)),
                                            );
                                          } else {
                                            List<Event> events = Provider.of<EventsProvider>(context, listen: false).events;
                                            //initial selection
                                            selectedEvent = events[0];
                                            return Container(
                                              child: CupertinoPicker(
                                                itemExtent:  MediaQuery.of(context).size.height/16, 
                                                onSelectedItemChanged: (i) {
                                                  selectedEvent = events[i];
                                                },
                                                
                                                children: (events.map((event) {
                                                  return Center(child: Text(event.name));
                                                }).toList()),
                                              ),
                                            );
                                          }
                                        },
                                    ),
                                      ),
                                  ]
                                  ),
                                );
                              }
                            );
                            
                          }
                        ),
                      ),
                    ],
                  ),

                  Container(
                    child: TextField(
                      textAlign: TextAlign.left,
                      style:  TextStyle(color: Colors.black, fontSize: 18),
                      decoration: InputDecoration(
                        hintText: "Note",
                        border: InputBorder.none,
                      ),
                      controller: _noteController,
                    ),
                  ),

                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.orange,),
                    child: FlatButton(
                      onPressed: addPayment,
                      child: Text("Add", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20))
                    ),
                  ),
                ],
              ),
            ),


        ],
      ),
    );
  }

  void addPayment() async {
    String amount = _amountController.value.text;
    String note   = _noteController.value.text;

    String errorMsg = "";

    if(amount.isEmpty)
      errorMsg = "Please enter payment amount.";
    else if(double.tryParse(amount) == null)
      errorMsg = "Amount should be number.";
    else if(_eventController.value.text.isEmpty)
      errorMsg = "Please selected event.";

    if(errorMsg.isNotEmpty) {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) => new CupertinoAlertDialog(
          title: Text("Failed"),
          content: Text(errorMsg),
          actions: [
            CupertinoDialogAction(
              child: Text("OK", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ));
    } else {

      String errorMsg = await PaymentsHelper.addPayment(widget.id, double.parse(amount), note, 2, eventId: _event.id);
      if(errorMsg.isEmpty){
        _amountController.clear();
        _eventController.clear();
        _noteController.clear();
        setState(() {
          _open = !_open;
          _event = null;
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
              child: Text("OK", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ));
      }



    }
  }
}
