import 'dart:async';
import 'package:ordermanager/VIews/account/login.dart';
import 'package:ordermanager/VIews/customers/awaitingtoconfirm.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:confirm_dialog/confirm_dialog.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  bool _showDrawerContents = true;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
  ); //..repeat(reverse: true);
  late Animation<double> _drawerContentsOpacity;
  late Animation<Offset> _drawerDetailsPosition;

  _MyHomePageState() {
    _drawerContentsOpacity = CurvedAnimation(
      parent: ReverseAnimation(_controller),
      curve: Curves.easeOut,
    );

    _drawerDetailsPosition = _controller.drive(_drawerDetailsTween);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    // // _controller = AnimationController(
    // //   vsync: this,
    // //   duration: const Duration(milliseconds: 200),
    // // );
    // _drawerContentsOpacity = CurvedAnimation(
    //   parent: ReverseAnimation(_controller),
    //   curve: Curves.fastOutSlowIn,
    // );
    // _drawerDetailsPosition = _controller.drive(_drawerDetailsTween);
  }

  static final Animatable<Offset> _drawerDetailsTween = Tween<Offset>(
    begin: const Offset(0.0, -1.0),
    end: Offset.zero,
  ).chain(CurveTween(
    curve: Curves.fastOutSlowIn,
  ));

  Future<bool> _exitApp(BuildContext context) async {
    bool _resExit = await confirm(context,
        title: Text('Logout'),
        content: Text('Confirm Logout?'),
        textOK: Text('Yes'),
        textCancel: Text('No'));
    if (_resExit) {
      return false;
      //exit(0);
    } else {
      Navigator.of(context).pop(false);
    }
    return false;
  }

  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void _showNotImplementedMessage() {
    SnackBar(
      content: Text('Yay! A SnackBar!'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
    // Navigator.pop(context); // Dismiss the drawer.
    // _scaffoldKey.currentState.showSnackBar(const SnackBar(
    //   content: Text("The drawer's items don't do anything"),
    // ));
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () => _exitApp(context),
        child: new Scaffold(
            appBar: new AppBar(
                title: new Text("OM-PS"), backgroundColor: Colors.blueAccent),
            body: Center(
                child: new Text("Welcome!!",
                    style: new TextStyle(fontSize: 35.0))),
            drawer: new Drawer(
              child: Column(
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountName: const Text(''),
                    accountEmail: const Text('Username'),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                    ),
                    margin: EdgeInsets.zero,
                    onDetailsPressed: () {
                      _showDrawerContents = !_showDrawerContents;
                      if (_showDrawerContents)
                        _controller.reverse();
                      else
                        _controller.forward();
                    },
                  ),
                  MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: Expanded(
                        child: ListView(
                          dragStartBehavior: DragStartBehavior.down,
                          padding: const EdgeInsets.only(top: 8.0),
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                // The initial contents of the drawer.
                                FadeTransition(
                                  opacity: _drawerContentsOpacity,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      new ListTile(
                                        title: new Text("Customers"),
                                        enabled: false,
                                        //leading: new Icon(Icons.supervised_user_circle),
                                        //onTap: () {
                                        //Navigator.of(context).pop();
                                        //Navigator.push(context, new MaterialPageRoute(builder: (context) => new LoginPage()));
                                        //},
                                      ),
                                      new Divider(),
                                      new ListTile(
                                        title: new Text("Awaiting to Confirm"),
                                        leading: new Icon(Icons.list,
                                            color: Colors.blueGrey),
                                        subtitle: new Text(
                                            "Pending for order confirmation"),
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) =>
                                                      new AwaitingtoConfirm()));
                                        },
                                      ),
                                      new ListTile(
                                        title: new Text("Awaiting to Payment"),
                                        leading: new Icon(Icons.verified_user,
                                            color: Colors.orangeAccent),
                                        subtitle: new Text(
                                            "Pending for payment confirmation"),
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) =>
                                                      new LoginPage()));
                                        },
                                      ),
                                      new ListTile(
                                        title: new Text("Confirmed"),
                                        leading: new Icon(Icons.monetization_on,
                                            color: Colors.greenAccent),
                                        subtitle: new Text(" "),
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) =>
                                                      new LoginPage()));
                                        },
                                      ),
                                    ],
                                  ),
                                ),

                                SlideTransition(
                                  position: _drawerDetailsPosition,
                                  child: FadeTransition(
                                    opacity: ReverseAnimation(
                                        _drawerContentsOpacity),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        ListTile(
                                          leading: const Icon(Icons.add),
                                          title: const Text('Add account'),
                                          onTap: _showNotImplementedMessage,
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.settings),
                                          title: const Text('Manage accounts'),
                                          onTap: _showNotImplementedMessage,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            )));
  }
}
