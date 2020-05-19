import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {

  final String orderId;

  OrderScreen(this.orderId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pedido Realizado"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.check,
            color: Theme.of(context).primaryColor,
            size: 80,
            ),
            Text("Pedido Feito!",
            style: TextStyle(fontWeight: FontWeight.bold)
            ),
            Text("Codigo do Pedido: $orderId", style: TextStyle(fontSize: 16))
          ],
        ),
      ),
    );
  }
}