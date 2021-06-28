import 'dart:io';
import 'package:ordermanager/Helpers/Utility.dart';
import 'package:ordermanager/Services/CustomerService.dart';
import 'package:ordermanager/Models/Customers.dart';
import 'package:ordermanager/VIews/customers/manage.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart' as prefixPdf;
//import 'package:pdf/widgets.dart' as prefixWidget;
import 'package:printing/printing.dart';
import 'dart:async';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class AwaitingtoConfirm extends StatefulWidget {
  const AwaitingtoConfirm({Key? key}) : super(key: key);

  @override
  _AwaitingtoConfirmState createState() => _AwaitingtoConfirmState();
}

class _AwaitingtoConfirmState extends State<AwaitingtoConfirm> {
  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();
  List<Customers> _list = <Customers>[];
  DateTime selectedDate = DateTime.now();
  ValueChanged<DateTime>? selectDate;
  //GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  ProcessingDBDataState _processingDBDataState = ProcessingDBDataState.waiting;

  _AwaitingtoConfirmState() {
    // for(int i=1;i<=3;i++){
    //   //documentID: "1",
    //   final objCustomer = Customers(companyName: 'Avani Fashion', orderCode: 'Emp-001107', customerName: 'James Martine ' + i.toString(),
    //   phoneNumber: '9876543210', orderDetails: 'Silver Grey',
    //   address: '41, Northwind street, Opp. Universal studio', city: 'Calgary', stateCountry: 'Alberta, USA', postalCode: '98005',
    //   status: 0, createdBy: "1", createdOn: DateTime.now().toString(), modifiedBy: "1", modifiedOn: DateTime.now().toString());

    //   _list.add(objCustomer);
    // }
  }

  @override
  void initState() {
    super.initState();
    _getData();
    //print("initState");
  }

  Future<void> _getData() async {
    try {
      startLoader();
      initList();

      var isConnectionAlive = await Utility().checkConnectivity();
      if (isConnectionAlive) {
        var _dt = (formatDate(selectedDate, [yyyy]) +
            formatDate(selectedDate, [mm]) +
            formatDate(selectedDate, [dd]));
        var docs = await CustomerService().getByStatusAndDate(0, _dt);
        docs.docs.forEach((f) {
          setState(() {
            print('${f.data()}}');
            // if (f.exists) {
            //   var _obj = Customers.fromJson(f.data());
            //   _obj.documentID = f.id;
            //   _list.add(_obj);
            // }
          });
        });

        stopLoader();
        sortList();
      } else {
        initList();
        stopLoader();
        Fluttertoast.showToast(
            msg: "You're not connected to a network",
            gravity: ToastGravity.BOTTOM);
      }
    } catch (e) {
      initList();
      stopLoader();
      Fluttertoast.showToast(msg: e.toString(), gravity: ToastGravity.BOTTOM);
    }
  }

  void startLoader() {
    setState(() {
      _processingDBDataState = ProcessingDBDataState.waiting;
    });
  }

  void stopLoader() {
    setState(() {
      _processingDBDataState = ProcessingDBDataState.done;
    });
  }

  void sortList() {
    setState(() {
      if (_list.length > 0) {
        _list.sort((a, b) {
          return a.customerName
              .toString()
              .toLowerCase()
              .compareTo(b.customerName.toString().toLowerCase());
        });
      }
    });
  }

  Future<void> initList() async {
    setState(() {
      _list = <Customers>[];
    });
  }

// Future<void> _handleRefresh() {
//     final Completer<void> completer = Completer<void>();
//     Timer(const Duration(seconds: 3), () {
//       completer.complete();
//     });
//     return completer.future.then<void>((_) {
//     });
// }

  void _handleConfirmation(Customers item) {
    setState(() {
      _list.remove(item);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2019, 10),
      lastDate: DateTime(9999),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      await _getData();
    }
  }

  _prepareHTMLData() async {
    String _dataHTML = "<html><head><style>";
    _dataHTML +=
        "td, th { border: 1px solid #dddddd; text-align: left; padding: 2px; }";
    _dataHTML +=
        "</style></head><body style=\"font-size: 12px; padding: 0; width: 99%; text-align: center;\">";
    _dataHTML +=
        "<h3>Awaiting to customer's confirmation for order</h3><table style=\"font-family: arial, sans-serif; border-collapse: collapse; width: 100%;\"><tr>";
    _dataHTML +=
        "<th style=\"width:22%;\">Customer Name</th><th style=\"width:8%;\">Contact</th>";
    _dataHTML +=
        "<th style=\"width:8%;\">Code</th><th style=\"width:62%;\">Address</th></tr>";

    for (var item in _list) {
      _dataHTML += "<tr>";
      _dataHTML += "<td>" + item.customerName.toString() + "</td>";
      _dataHTML += "<td>" + item.phoneNumber.toString() + "</td>";
      _dataHTML += "<td>" + item.orderCode.toString() + "</td>";
      _dataHTML += "<td>" +
          item.address.toString() +
          ", " +
          item.city.toString() +
          ", " +
          item.stateCountry.toString() +
          "-" +
          item.postalCode.toString() +
          "</td>";
      _dataHTML += "</tr>";
    }

    _dataHTML += "</table></body></html>";

    return _dataHTML;
  }

  _shareData() async {
    if (_list.length > 0) {
      String finalHTMLData = await _prepareHTMLData();
      Directory tempDir = await getTemporaryDirectory();
      var fileName = "Awaitingconfirm_" +
          formatDate(selectedDate, [dd]).toString() +
          '_' +
          formatDate(selectedDate, [mm]).toString() +
          '_' +
          formatDate(selectedDate, [yyyy]).toString();
      var generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
          finalHTMLData, tempDir.path.toString(), fileName);
      //List<int> byt = generatedPdfFile.readAsBytesSync();
      var fileToDelete =
          File(tempDir.path.toString() + "/" + fileName + ".pdf");
      fileToDelete.deleteSync();
      await Printing.sharePdf(
          bytes: generatedPdfFile.readAsBytesSync(),
          filename: fileName + ".pdf");
    }
  }

  _printData() async {
    if (_list.length > 0) {
      String finalHTMLData = await _prepareHTMLData();
      await Printing.layoutPdf(
          onLayout: (prefixPdf.PdfPageFormat format) async =>
              await Printing.convertHtml(
                  format: prefixPdf.PdfPageFormat.letter, html: finalHTMLData),
          name: "Awaitingconfirm_" +
              formatDate(selectedDate, [dd]).toString() +
              '_' +
              formatDate(selectedDate, [mm]).toString() +
              '_' +
              formatDate(selectedDate, [yyyy]).toString());
    }
  }

  Widget loadingView() => Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
            'Awaiting to Confirm - ' +
                formatDate(selectedDate, [M]).toString() +
                ', ' +
                formatDate(selectedDate, [dd]).toString(),
            style: new TextStyle(fontSize: 18.0)),
        backgroundColor: Colors.blueAccent,
        // actions: <Widget>[
        //   //action on top like context menu
        //   // IconButton(
        //   //   alignment: Alignment.centerRight,
        //   //   icon: const Icon(Icons.refresh),
        //   //   tooltip: 'Refresh',
        //   //   onPressed: //_getData,
        //   //   () async {
        //   //     await _getData();
        //   //     //_refreshIndicatorKey.currentState.show();
        //   //   }
        //   // ),
        // ],
      ),
      body: RefreshIndicator(
        //key: _refreshIndicatorKey,
        //onRefresh: _getData, //_handleRefresh,
        onRefresh: () async {
          await _getData();
        },
        child: Scrollbar(
          child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 6.0),
              itemCount: _list.length,
              itemBuilder: (context, index) {
                switch (_processingDBDataState) {
                  case ProcessingDBDataState.waiting:
                    {
                      //_refreshIndicatorKey.currentState.show();
                      return loadingView();
                      //break;
                    }
                  case ProcessingDBDataState.done:
                    {
                      final item = _list[index];
                      return Dismissible(
                        key: ObjectKey(item),
                        direction: DismissDirection.startToEnd,
                        onDismissed: (DismissDirection direction) {
                          _handleConfirmation(item);
                        },
                        confirmDismiss:
                            (DismissDirection dismissDirection) async {
                          return await confirm(context,
                              title: Text('Confirm Order'),
                              content: Text('Are you sure to confirm?'),
                              textOK: Text('Yes'),
                              textCancel: Text('No'));
                        },
                        background: Container(
                          color: Colors.lightBlue,
                          child: const ListTile(
                            leading: Icon(Icons.verified_user,
                                color: Colors.orangeAccent, size: 30.0),
                          ),
                        ),
                        child: ListTile(
                          isThreeLine: true,
                          dense: false,
                          leading: ExcludeSemantics(
                              child: CircleAvatar(
                                  child: Text(item.customerName
                                      .toString()
                                      .substring(0, 1)
                                      .toUpperCase()))), //show Avtar
                          title: Text(item.customerName.toString()),
                          subtitle: Text(item.phoneNumber.toString() +
                              "  # " +
                              item.orderCode.toString() +
                              "\n" +
                              item.companyName
                                  .toString()), //+ " : " + item.city + "-" + item.postalCode
                          key: Key(item.documentID.toString()),
                          trailing: IconButton(
                              alignment: Alignment.topRight,
                              padding: EdgeInsets.zero,
                              icon: Icon(Icons.call, color: Colors.green),
                              onPressed: () {
                                if (item.phoneNumber != null &&
                                    item.phoneNumber != "")
                                  launch("tel:" + item.phoneNumber.toString());
                              }),
                          onTap: () {},
                        ),
                      );
                      //break;
                    }
                  // case ProcessingDBDataState.none:
                  // {
                  //   break;
                  // }
                }
                //return loadingView();
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(new MaterialPageRoute<Null>(
              builder: (BuildContext context) => ManageCustomer(),
              fullscreenDialog: true));
        },
        child: Icon(Icons.add, semanticLabel: 'Action'),
        backgroundColor: Colors.lightBlue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white70,
        shape: CircularNotchedRectangle(),
        child: Row(children: <Widget>[
          IconButton(
            alignment: Alignment.centerRight,
            icon: const Icon(Icons.date_range),
            color: Colors.blue,
            tooltip: 'Select Date',
            onPressed: () {
              //setState(() {
              _selectDate(context);
              //});
            },
          ),
          IconButton(
            alignment: Alignment.centerRight,
            icon: const Icon(Icons.print),
            color: Colors.blue,
            tooltip: 'Print',
            onPressed: () {
              _printData();
            },
          ),
          IconButton(
            alignment: Alignment.centerRight,
            icon: const Icon(Icons.share),
            color: Colors.blue,
            tooltip: 'Share',
            onPressed: () {
              _shareData();
            },
          ),
        ]),
      ),
    );
  }
}
