import 'package:flutter/material.dart';
import 'package:upi/component.dart';
import 'package:upi/main.dart';
// import 'package:upi/main.dart';
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

  Widget displayUpiApps() {
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
            child: Container(
              height: 100,
              width: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image.memory(
                      app.icon,
                      height: 60,
                      width: 60,
                    ),
                  ),
                  Text(app.name.toUpperCase()),
                ],
              ),
            ),
          );
        }).toList(),
      );
  }

  String _upiErrorHandler(error) {
    switch (error) {
      case UpiIndiaAppNotInstalledException:
        return 'Requested app not installed on device';
      case UpiIndiaUserCancelledException:
        return 'You cancelled the transaction';
      case UpiIndiaNullResponseException:
        return 'Requested app didn\'t return any response';
      case UpiIndiaInvalidParametersException:
        return 'Requested app cannot handle the transaction';
      default:
        return 'YOU ARE CANCELED THE PAYMENT TRANSECTION';
    }
  }

  void _checkTxnStatus(String status) {
    switch (status) {
      case UpiPaymentStatus.SUCCESS:
        print('Transaction Successful');
        break;
      case UpiPaymentStatus.SUBMITTED:
        print('Transaction Submitted');
        break;
      case UpiPaymentStatus.FAILURE:
        print('Transaction Failed');
        break;
      default:
        print('Received an Unknown transaction status');
    }
  }

  Widget displayTransactionData(title, body) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$title: ".toUpperCase(), style: header),
          Flexible(
              child: Text(
            body.toString().toUpperCase(),
            style: value,
          )),
        ],
      ),
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
                        _upiErrorHandler(snapshot.error.runtimeType),
                        textAlign: TextAlign.center,
                        style: header,
                      ),
                    );
                  }

                  UpiResponse _upiResponse = snapshot.data!;
                  String txnId = _upiResponse.transactionId ?? 'NOT FOUND';
                  String status = _upiResponse.status ?? 'NOT FOUND';
                  _checkTxnStatus(status);

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        displayTransactionData('Transaction Id:', txnId),
                        displayTransactionData(
                            'Ref ID:', _upiResponse.transactionId.toString()),
                        displayTransactionData('Status:', status.toUpperCase()),
                      ],
                    ),
                  );
                } else
                  return Center(
                    child: Text(''),
                  );
              },
            ),
          )
        ],
      ),
    );
  }
}
