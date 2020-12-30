import 'package:StMaryFA/helpers/PaymentsHelper.dart';
import 'package:StMaryFA/models/Payment.dart';
import 'package:StMaryFA/screens/FAScreen.dart';
import 'package:StMaryFA/widgets/NewPayment.dart';
import 'package:flutter/material.dart';

class UserPaymentsScreen extends StatefulWidget {
  UserPaymentsScreen(this.id, this.userName);
  final int id;
  final String userName;
  @override
  _UserPaymentsScreenState createState() => _UserPaymentsScreenState();
}

class _UserPaymentsScreenState extends State<UserPaymentsScreen> {
  @override
  Widget build(BuildContext context) {
    return FAScreen(
      appBar: AppBar(title: Text("${widget.userName}'s payments"),),
      body: Column(
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
                                  title: Text("\$ ${payments[index].amount}"),
                                  subtitle: Text(payments[index].note),
                                  trailing: Text(payments[index].date),
                                )
                            );
                          }
                        ),
                      );
                    }
                  } else {
                    return CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),backgroundColor: Colors.orange,);
                  }
                }
              ),
        ]
      ),
    );
  }
}