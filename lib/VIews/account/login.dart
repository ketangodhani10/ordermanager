import 'package:ordermanager/Helpers/Utility.dart';
import 'package:ordermanager/Models/LoginData.dart';
import 'package:ordermanager/VIews/home/index.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginData oLoginData = LoginData();
  TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 20.0);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //bool _autovalidate = false;
  bool rememberMe = false;
  bool _obscureText = true;

  String? _requiredField(String? value) {
    if (value == null || value.toString() == '')
      return 'This field can not be empty.';
    return null;
    // final RegExp nameExp = RegExp(r'^[A-Za-z ]+$');
    // if (!nameExp.hasMatch(value))
    //   return 'Please enter only alphabetical characters.';
  }

  @override
  initState() {
    super.initState();
    String? _uname = "", _pass = "";
    Utility().getStoredDataByKey("userName").then((onValue) {
      _uname = onValue;
    });
    Utility().getStoredDataByKey("password").then((onValue) {
      _pass = onValue;
    });

    if (_uname != null &&
        _pass != null &&
        _uname.toString().isNotEmpty &&
        _pass.toString().isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    }
  }

  void _handleSubmitted() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage()),
    );
    // var isConnectionAlive = await Utility().checkConnectivity();
    // if(isConnectionAlive)
    // {
    //   final FormState form = _formKey.currentState;
    //   if (!form.validate()) {
    //     _autovalidate = true;
    //     Fluttertoast.showToast(msg: 'Please fill required information', gravity: ToastGravity.BOTTOM);
    //   } else {

    //     Users oUsers = new Users();
    //     print(oLoginData.username);
    //     print(oLoginData.password);
    //     if(oLoginData.username.isEmpty){
    //     print('zzzzzzzzzzzzAAAAAAAAQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ');
    //     }
    //     var docs = await UserService().verifyUser(oLoginData.username, oLoginData.password);
    //     docs.documents.forEach((f) {
    //       setState(() {
    //         if(f.exists) {
    //          print('AAAAAAAAQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ');
    //          print(f.data);
    //         }
    //       });
    //     });

    //     if(docs.documents != null && docs.documents.length > 0) {
    //       oUsers = Users.fromJson(docs.documents[0].data);
    //       oUsers.documentID = docs.documents[0].documentID;
    //       print('10000000000000000000000');
    //       if(rememberMe)
    //       {
    //         Utility().signOut();
    //         Utility().signIn(oUsers.documentID, oUsers.fullName, oUsers.userName, oUsers.password, oUsers.role, oUsers.defaultCompanyName);
    //       }
    //       print('20000000000000000000000');

    //       Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()),);
    //     } else {
    //       Fluttertoast.showToast(msg: "Invalid user", gravity: ToastGravity.BOTTOM, backgroundColor: Colors.redAccent, textColor: Colors.white);
    //     }
    //   }
    // } else {
    //   Fluttertoast.showToast(msg: "You're not connected to a network", gravity: ToastGravity.BOTTOM);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Form(
                key: _formKey,
                //autovalidate: _autovalidate,
                child: Scrollbar(
                    child: SingleChildScrollView(
                        dragStartBehavior: DragStartBehavior.down,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              new Container(
                                height: 100.0,
                                width: 100.0,
                                child: Image.asset("images/logo.png",
                                    fit: BoxFit.contain),
                                margin:
                                    new EdgeInsets.fromLTRB(0, 15.0, 0, 60.0),
                              ),
                              const SizedBox(height: 25.0),
                              TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  filled: false,
                                  //icon: Icon(Icons.person),
                                  hintText: 'Username',
                                  //labelText: 'Username',
                                ),
                                maxLines: 1,
                                keyboardType: TextInputType.text,
                                onSaved: (String? value) {
                                  oLoginData.username = value;
                                },
                                validator: _requiredField,
                              ),
                              const SizedBox(height: 25.0),
                              TextFormField(
                                obscureText: _obscureText,
                                maxLines: 1,
                                keyboardType: TextInputType.text,
                                onSaved: (String? value) {
                                  oLoginData.password = value;
                                },
                                validator: _requiredField,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  filled: false,
                                  hintText: 'Password',
                                  suffixIcon: GestureDetector(
                                    dragStartBehavior: DragStartBehavior.down,
                                    onTap: () {
                                      setState(() {
                                        _obscureText = !_obscureText;
                                      });
                                    },
                                    child: Icon(
                                      _obscureText
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      semanticLabel: _obscureText
                                          ? 'show password'
                                          : 'hide password',
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 25.0),
                              ButtonTheme(
                                minWidth: MediaQuery.of(context).size.width,
                                height: 60.0,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      textStyle: const TextStyle(fontSize: 20),
                                      elevation: 3.0,
                                      primary: Color.fromARGB(0, 255, 0, 255)),
                                  child: Text('LOGIN',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white)),
                                  onPressed: _handleSubmitted,
                                ),
                              ),
                              const SizedBox(height: 25.0),
                              SwitchListTile(
                                value: rememberMe,
                                onChanged: (bool value) {
                                  setState(() {
                                    rememberMe = value;
                                  });
                                },
                                title: const Text('Remember Me'),
                                secondary: const Icon(Icons.lightbulb_outline),
                              ),
                              const SizedBox(height: 24.0),
                              Center(
                                child: Text(
                                  'Powered by Winsome Technosys ' +
                                      formatDate(DateTime.now(), [yyyy]),
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ),
                            ]))))));
  }
}
