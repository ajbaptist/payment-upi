import 'package:flutter/material.dart';

TextStyle header =
    TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red);

TextStyle value =
    TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: Colors.yellow);

displayTransactionData(title, body) {
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
