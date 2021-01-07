import 'package:StMaryFA/helpers/PaymentsHelper.dart';
import 'package:StMaryFA/models/Payment.dart';
import 'package:StMaryFA/screens/FAScreen.dart';
import 'package:StMaryFA/widgets/NewEventPayment.dart';
import 'package:StMaryFA/widgets/NewPayment.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserPaymentsScreen extends StatefulWidget {
  UserPaymentsScreen(this.id, this.userName);
  final int id;
  final String userName;
  @override
  _UserPaymentsScreenState createState() => _UserPaymentsScreenState();
}

class _UserPaymentsScreenState extends State<UserPaymentsScreen> {
  int selectedpage = 0;
  PageController _controller = new PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return FAScreen(
      padding: EdgeInsets.only(top: 15, left: 15, right: 15),
      appBar: AppBar(title: Text("${widget.userName}'s payments"),),
      body: PageView(
        controller: _controller,
        onPageChanged: (i) {
          setState(() {
            selectedpage = i;
          });
        },
        children:[
          Column(
            children: [
              NewPayment(widget.id, onPaymentAdd: () {setState(() {});}),

              Divider(),

              // Payments list
              FutureBuilder(
                future: PaymentsHelper.getUserPayments(widget.id),
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.done) {
                    if(snapshot.hasError) {
                      return Center(child: Text("Something went wrong.\nPlease check internet connection and try again.",));
                    } else {
                      List<Payment> payments = snapshot.data as List<Payment>;
                      return Expanded(
                        child: ListView.builder(
                          itemCount: payments.length,
                          itemBuilder: (BuildContext context,int index) {
                            return Card(
                              margin: EdgeInsets.only(bottom: 1),
                                child: ListTile(
                                  tileColor: Color.fromRGBO(254, 250, 241, 1),
                                  leading: Text("EGP ${payments[index].amount}"),
                                  subtitle: Text(payments[index].note),
                                  trailing: Text(payments[index].date),
                                )
                            );
                          }
                        ),
                      );
                    }
                  } else {
                    return Expanded(child: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),backgroundColor: Colors.orange,)));
                  }
                }
              ),
            ]
          ),

        //Events page
        Column(
          children: [
            NewEventPayment(widget.id, onPaymentAdd: () {setState(() {});}),

            Divider(),

            // Payments list
            FutureBuilder(
              future: PaymentsHelper.getUserEventPayments(widget.id),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.done) {
                  if(snapshot.hasError) {
                    return Center(child: Text("Something went wrong.\nPlease check internet connection and try again.",));
                  } else {
                    List<EventPayment> payments = snapshot.data as List<EventPayment>;
                    return Expanded(
                      child: ListView.builder(
                        itemCount: payments.length,
                        itemBuilder: (BuildContext context,int index) {
                          return Card(
                            margin: EdgeInsets.only(bottom: 1),
                            child: ListTile(
                                tileColor: Color.fromRGBO(254, 250, 241, 1),
                                leading: Text("EGP ${payments[index].amount}"),
                                title: Text(payments[index].eventName),
                                subtitle: Text(payments[index].note),
                                trailing: Text(payments[index].date),
                            )
                          );
                        }
                      ),
                    );
                  }
                } else {
                  return Expanded(child: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),backgroundColor: Colors.orange,)));
                }
              }
            ),
          ],
        ),
        
        ],

      ),
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          primaryColor: Colors.orange
        ),
        child: BottomNavigationBar(
          currentIndex: selectedpage,
          onTap: (i) => _controller.animateToPage(i, duration: Duration(milliseconds: 200), curve: Curves.linear),
          items: [
            BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.school),label: "Academy"),
            BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.campground),label: "Events"),
            
          ],
        ),
      ),
    );
  }
}