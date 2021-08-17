import 'package:flutter/material.dart';
import 'package:upi/component.dart';
import 'package:upi/main.dart';
import 'package:upi_india/upi_india.dart';

class Payment extends StatefulWidget {
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: PaymentPage(),
    );
  }
}

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  Future<UpiResponse>? _transaction;
  UpiIndia upiIndia = UpiIndia();
  List<UpiApp>? apps;

  @override
  void initState() {
    upiIndia.getAllUpiApps(mandatoryTransactionId: false).then((value) {
      setState(() {
        apps = value;
      });
    }).catchError((e) {
      apps = [];
    });
    super.initState();
  }

  Future<UpiResponse> initiateTransaction(UpiApp app, double amount) async {
    return upiIndia.startTransaction(
      app: app,
      receiverUpiId: "ajbaptist18-2@okaxis",
      receiverName: 'John Baptist',
      transactionRefId: '8965987956',
      transactionNote: 'FOR TESTING PURPOSE',
      amount: amount,
    );
  }

  displayUpiApps() {
    if (apps == null)
      return Center(child: CircularProgressIndicator());
    else if (apps!.length == 0)
      return Center(
        child: Text(
          "NO UPI APPLICATIONS FOUND PLEASE INSTALL THAT.",
          style: header,
        ),
      );
    else
      return Wrap(
        children: apps!.map<Widget>((UpiApp app) {
          return GestureDetector(
            onTap: () {
              _transaction = initiateTransaction(app, amount);
              setState(() {});
            },
            child: SizedBox(
              height: 200,
              width: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image.memory(
                      app.icon,
                      height: 80,
                      width: 80,
                    ),
                  ),
                  Text(
                    app.name.toUpperCase(),
                    style: TextStyle(
                        color: Colors.teal, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('CHOOSE THE APP'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: displayUpiApps(),
          ),
          Expanded(
            child: FutureBuilder(
              future: _transaction,
              builder:
                  (BuildContext context, AsyncSnapshot<UpiResponse> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'ERROR OCCURED',
                        textAlign: TextAlign.center,
                        style: header,
                      ),
                    );
                  }

                  UpiResponse appRes = snapshot.data!;
                  String txnId = appRes.transactionId ?? 'NOT FOUND';
                  String status = appRes.status ?? 'NOT FOUND';

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        displayTransactionData('Transaction Id:', txnId),
                        displayTransactionData(
                            'Ref ID:', appRes.transactionId.toString()),
                        displayTransactionData('Status:', status.toUpperCase()),
                      ],
                    ),
                  );
                } else
                  return Center(
                    child: Text('PLEASE SELECT YOUR UPI APPLICATION'),
                  );
              },
            ),
          )
        ],
      ),
    );
  }
}
