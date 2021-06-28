import 'dart:async';
import 'package:ordermanager/Helpers/DbHelper.dart';
import 'package:ordermanager/Models/Companies.dart';
import 'package:ordermanager/Models/Customers.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ManageCustomer extends StatefulWidget {
  const ManageCustomer({Key? key}) : super(key: key);

  @override
  _ManageCustomerState createState() => _ManageCustomerState();
}

class _ManageCustomerState extends State<ManageCustomer> {
  Customers objCustomer = new Customers();
  TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 20.0);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //bool _autovalidate = false;
  bool _formWasEdited = false;
  List<Companies> _listCompanies = <Companies>[];
  String _selectedCompany = "Please select company";

  _ManageCustomerState() {
    objCustomer.orderCode = "KET-001122";
    objCustomer.status = 0;
    objCustomer.createdOn = (formatDate(DateTime.now(), [yyyy]) +
        formatDate(DateTime.now(), [mm]) +
        formatDate(DateTime.now(), [dd]));
    objCustomer.createdBy = "";
    objCustomer.modifiedBy = "";
    objCustomer.modifiedOn = (formatDate(DateTime.now(), [yyyy]) +
        formatDate(DateTime.now(), [mm]) +
        formatDate(DateTime.now(), [dd]));

    _listCompanies = <Companies>[];
    _listCompanies
        .add(Companies(documentID: '', companyName: 'Please select company'));
    _getCompanies();
  }

  Future<void> _getCompanies() async {
    DbHelper oDbHelper = new DbHelper();
    oDbHelper.getAllData("companies").then((snapshot) {
      snapshot.docs.forEach((f) => setState(() {
                print('${f.data()}}');
                //_listCompanies.add(Companies.fromJson(f.data()));
              })
          //, print('${f.data}}')
          );
    });
  }

  // final List<String> _allCompanies = <String>['Avani Textile', 'D4 Fashion', 'Zircon Creation'];
  // String _selectedCompany = 'Zircon Creation';

  Future<bool> _warnUserAboutInvalidData() async {
    final FormState? form = _formKey.currentState;
    if (form == null || !_formWasEdited || form.validate()) return true;

    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Pending to save'),
              content: const Text('Are you sure to leave?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('No'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  String? _requiredField(String? value) {
    _formWasEdited = true;
    if (value == null || value == "Please select company")
      return 'This field can not be empty.';
    return null;
  }

  void _handleSubmitted() {
    // Navigator.push(
    // context,
    // MaterialPageRoute(builder: (context) => MyHomePage()),
    // );

    final FormState? form = _formKey.currentState;
    if (form != null && !form.validate()) {
      //_autovalidate = true; // Start validating on every change.
      Fluttertoast.showToast(
          msg: 'Please fill required information',
          gravity: ToastGravity.BOTTOM);
    } else {
      form?.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Manage Customer'),
          backgroundColor: Colors.blueAccent,
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: _handleSubmitted,
              child: Text('SAVE',
                  style:
                      theme.textTheme.bodyText1?.copyWith(color: Colors.white)),
            ),
          ],
        ),
        body: Form(
            key: _formKey,
            //autovalidate: _autovalidate,
            onWillPop: _warnUserAboutInvalidData,
            child: Scrollbar(
                child: SingleChildScrollView(
                    dragStartBehavior: DragStartBehavior.down,
                    padding: const EdgeInsets.all(16.0),
                    child: DropdownButtonHideUnderline(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                          const SizedBox(height: 24.0),
                          Text("Order No: " + objCustomer.orderCode.toString()),
                          const SizedBox(height: 24.0),
                          TextFormField(
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              filled: false,
                              //hintText: 'Customer name',
                              labelText: 'Customer name *',
                            ),
                            maxLines: 1,
                            keyboardType: TextInputType.text,
                            onSaved: (String? value) {
                              objCustomer.customerName = value;
                            },
                            validator: _requiredField,
                          ),
                          const SizedBox(height: 24.0),
                          DropdownButtonFormField(
                            decoration: const InputDecoration(
                              labelText: 'Company name *',
                              hintText: 'Choose a company',
                              contentPadding: EdgeInsets.zero,
                            ),
                            validator: _requiredField,
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedCompany = newValue.toString();
                                objCustomer.companyName = newValue;
                              });
                            },
                            value: _selectedCompany,
                            items: _listCompanies.map<DropdownMenuItem<String>>(
                                (Companies oCompanies) {
                              return DropdownMenuItem<String>(
                                value: oCompanies.companyName,
                                child: Text(oCompanies.companyName.toString()),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 24.0),
                          TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              filled: false,
                              labelText: 'Order details *',
                            ),
                            maxLines: 3,
                            keyboardType: TextInputType.text,
                            onSaved: (String? value) {
                              objCustomer.orderDetails = value;
                            },
                            validator: _requiredField,
                          ),
                          const SizedBox(height: 24.0),
                          TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              filled: false,
                              labelText: 'Address *',
                            ),
                            maxLines: 3,
                            keyboardType: TextInputType.text,
                            onSaved: (String? value) {
                              objCustomer.address = value;
                            },
                            validator: _requiredField,
                          ),
                          const SizedBox(height: 24.0),
                          TextFormField(
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              filled: false,
                              labelText: 'Contact No. *',
                            ),
                            maxLines: 1,
                            keyboardType: TextInputType.number,
                            onSaved: (String? value) {
                              objCustomer.phoneNumber = value;
                            },
                            validator: _requiredField,
                          ),
                          const SizedBox(height: 24.0),
                          TextFormField(
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              filled: false,
                              labelText: 'City *',
                            ),
                            maxLines: 1,
                            keyboardType: TextInputType.text,
                            onSaved: (String? value) {
                              objCustomer.city = value;
                            },
                            validator: _requiredField,
                          ),
                          const SizedBox(height: 24.0),
                          TextFormField(
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              filled: false,
                              labelText: 'State/Country *',
                            ),
                            maxLines: 1,
                            keyboardType: TextInputType.text,
                            onSaved: (String? value) {
                              objCustomer.stateCountry = value;
                            },
                            validator: _requiredField,
                          ),
                          const SizedBox(height: 24.0),
                          TextFormField(
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              filled: false,
                              labelText: 'Postal Code *',
                            ),
                            maxLines: 1,
                            keyboardType: TextInputType.number,
                            onSaved: (String? value) {
                              objCustomer.postalCode = value;
                            },
                            validator: _requiredField,
                          ),
                          const SizedBox(height: 24.0),
                          ButtonTheme(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  textStyle: const TextStyle(fontSize: 20),
                                  elevation: 3.0,
                                  primary: Color.fromARGB(0, 255, 0, 255)),
                              child: Text('SUBMIT',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white)),
                              onPressed: _handleSubmitted,
                            ),
                          ),
                          const SizedBox(height: 24.0),
                        ]))))));
  }
}
