import 'package:flutter/material.dart';
import 'package:upi/payment.dart';

double amount = 1;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: Intro(),
    );
  }
}

class Intro extends StatefulWidget {
  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('UPI MODEL APP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  amount = double.parse(value);
                  print(amount);
                });
              },
              decoration: InputDecoration(
                  // hintText: 'Enter The Receiver Name ',
                  labelText: 'Enter The Amount',
                  border: OutlineInputBorder()),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // ignore: unnecessary_null_comparison

          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Payment(),
              ));
        },
        child: Icon(Icons.arrow_forward_ios_sharp),
      ),
    );
  }
}
