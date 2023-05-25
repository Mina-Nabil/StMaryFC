import 'package:StMaryFA/helpers/PaymentsHelper.dart';
import 'package:StMaryFA/models/Payment.dart';
import 'package:StMaryFA/models/User.dart';
import 'package:StMaryFA/providers/UsersProvider.dart';
import 'package:StMaryFA/screens/FAScreen.dart';
import 'package:StMaryFA/screens/OverviewScreen.dart';
import 'package:StMaryFA/widgets/NewEventPayment.dart';
import 'package:StMaryFA/widgets/NewPayment.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class UserPaymentsScreen extends StatefulWidget {
  final double bottomScreenPadding = 50;

  UserPaymentsScreen(this.id, this.userName, {this.goToHistory});
  final int id;
  final String userName;
  final bool goToHistory;

  @override
  _UserPaymentsScreenState createState() => _UserPaymentsScreenState();
}

class _UserPaymentsScreenState extends State<UserPaymentsScreen> {
  int selectedpage = 0;
  PageController _controller = new PageController(initialPage: 0);
  User user;
  bool userLoaded = false;

  Future<bool> showConfirmDeletePaymentDialog(BuildContext context, paymentID, type) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop<bool>(false);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed: () async {
        bool res = false;
        if (type == 1)
          res = await PaymentsHelper.deleteUserPayment(paymentID);
        else if (type == 2) res = await PaymentsHelper.deleteEventPayment(paymentID);
        Navigator.of(context).pop<bool>(res);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete Payment"),
      content: Text("Are you sure you want to delete the payment?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void goTo(index) {
    _controller.animateToPage(index, duration: new Duration(milliseconds: 300), curve: Curves.linear);
  }

  void setUserLoaded() {
    setState(() {
      userLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) async {
      user = await Provider.of<UsersProvider>(context, listen: false).getUserById(widget.id);
      setUserLoaded();
      WidgetsBinding.instance.addPostFrameCallback((_) => widget.goToHistory ? goTo(1) : '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return FAScreen(
      padding: EdgeInsets.only(top: 15, left: 15, right: 15),
      appBar: AppBar(
        title: Text("${widget.userName}'s payments"),
      ),
      body: PageView(
        controller: _controller,
        onPageChanged: (i) {
          setState(() {
            selectedpage = i;
          });
        },
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: widget.bottomScreenPadding),
            child: Column(children: [
              NewPayment(widget.id, onPaymentAdd: () {
                setState(() {});
              }),

              Divider(),

              // Payments list
              FutureBuilder(
                  future: PaymentsHelper.getUserPayments(widget.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return Center(
                            child: Text(
                          "Something went wrong.\nPlease check internet connection and try again.",
                        ));
                      } else {
                        List<Payment> payments = snapshot.data as List<Payment>;
                        return Expanded(
                          child: ListView.builder(
                              itemCount: payments.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Dismissible(
                                    background: Container(
                                        color: Colors.red,
                                        padding: EdgeInsets.only(right: 20.0),
                                        alignment: Alignment.centerRight,
                                        child: FaIcon(FontAwesomeIcons.trashCan, color: Colors.white)),
                                    dismissThresholds: {DismissDirection.endToStart: 0.6},
                                    key: UniqueKey(),
                                    direction: DismissDirection.endToStart,
                                    confirmDismiss: (direction) => showConfirmDeletePaymentDialog(context, payments[index].id, 1),
                                    child: Card(
                                        margin: EdgeInsets.only(bottom: 1),
                                        child: ListTile(
                                          tileColor: Color.fromRGBO(254, 250, 241, 1),
                                          leading: Text("EGP ${payments[index].amount}"),
                                          subtitle: Text(payments[index].note),
                                          trailing: Text(payments[index].date),
                                        )));
                              }),
                        );
                      }
                    } else {
                      return Expanded(
                          child: Center(
                              child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        backgroundColor: Colors.orange,
                      )));
                    }
                  }),
            ]),
          ),

          //History Screen
          if (userLoaded) OverviewScreen(user),
          //Events page

          Padding(
            padding: EdgeInsets.only(bottom: widget.bottomScreenPadding),
            child: Column(
              children: [
                NewEventPayment(widget.id, onPaymentAdd: () {
                  setState(() {});
                }),

                Divider(),

                // Payments list
                FutureBuilder(
                    future: PaymentsHelper.getUserEventPayments(widget.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return Center(
                              child: Text(
                            "Something went wrong.\nPlease check internet connection and try again.",
                          ));
                        } else {
                          List<EventPayment> payments = snapshot.data as List<EventPayment>;
                          return Expanded(
                            child: ListView.builder(
                                itemCount: payments.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Dismissible(
                                      background: Container(
                                          color: Colors.red,
                                          padding: EdgeInsets.only(right: 20.0),
                                          alignment: Alignment.centerRight,
                                          child: FaIcon(FontAwesomeIcons.trashCan, color: Colors.white)),
                                      dismissThresholds: {DismissDirection.endToStart: 0.6},
                                      key: UniqueKey(),
                                      direction: DismissDirection.endToStart,
                                      confirmDismiss: (direction) =>
                                          showConfirmDeletePaymentDialog(context, payments[index].id, 2),
                                      child: Card(
                                          margin: EdgeInsets.only(bottom: 1),
                                          child: ListTile(
                                            tileColor: Color.fromRGBO(254, 250, 241, 1),
                                            leading: Text("EGP ${payments[index].amount}"),
                                            title: Text(payments[index].eventName),
                                            subtitle: Text(payments[index].note),
                                            trailing: Text(payments[index].date),
                                          )));
                                }),
                          );
                        }
                      } else {
                        return Expanded(
                            child: Center(
                                child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          backgroundColor: Colors.orange,
                        )));
                      }
                    }),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Theme(
        data: ThemeData(splashColor: Colors.transparent, highlightColor: Colors.transparent, primaryColor: Colors.orange),
        child: BottomNavigationBar(
          currentIndex: selectedpage,
          onTap: (i) => _controller.animateToPage(i, duration: Duration(milliseconds: 200), curve: Curves.linear),
          items: [
            BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.school), label: "Academy"),
            if (userLoaded) BottomNavigationBarItem(icon: Icon(Icons.notes), label: "History"),
            BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.campground), label: "Events"),
          ],
        ),
      ),
    );
  }
}
