import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_model.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/telas/Home_Screen.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScopedModel <UserModel>(
      model: UserModel(),
      child: ScopedModelDescendant<UserModel>(
        builder: (context, child, model){
          return ScopedModel<CartModel> (
        model: CartModel(model),
        child: MaterialApp(
      title: "Flutter's Clouthing",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Color.fromARGB(255, 4 , 100 , 141) // Definindo a cor primaria do app. cor dos botões etc..
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen()
      ),
        );
        },
      )
    );
  }
}

