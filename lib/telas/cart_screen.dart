import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_model.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/telas/login_screen.dart';
import 'package:loja_virtual/telas/orders_screen.dart';
import 'package:loja_virtual/tiles/cart_tile.dart';
import 'package:loja_virtual/widgets/cart_price.dart';
import 'package:loja_virtual/widgets/discount_card.dart';
import 'package:scoped_model/scoped_model.dart';

class CartSreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meu Carrinho"),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 8),
            alignment: Alignment.center,
            child: ScopedModelDescendant<CartModel>(
              builder: (context,child,model){
                int qtdItens = model.products.length;
                return Text(
                  "${qtdItens ?? 0} ${qtdItens == 1 ? "ITEM": "ITENS"}"
                );
              },
            ),
          )
        ],
      ),
      body: ScopedModelDescendant<CartModel>(
        builder: (context, child, model){
          if(model.isLoading && UserModel.of(context).isLoggedIn()){
            return Center(
              child: CircularProgressIndicator(),
              );
            }
            else if (!UserModel.of(context).isLoggedIn()){
              return Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.remove_shopping_cart, size:  80, color: Theme.of(context).primaryColor),
                    SizedBox(height: 16),
                    Text("Faça o login para usar o carrinho",
                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                    ),
                     SizedBox(height: 16),
                     RaisedButton(
                       child: Text("Entrar", style: TextStyle(fontSize: 18)),
                       textColor: Colors.white,
                       color: Theme.of(context).primaryColor,
                       onPressed: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context)=> LoginScreen())
                        );   
                       },
                     )
                  ],
                ),
              );
            } else if (model.products == null || model.products.length == 0){
              return Center(
                child: Text("Nenhum produto no carrinho.",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                ),
              );
            } else{
              return ListView(
                children: <Widget>[
                  Column(
                    children: model.products.map(
                      (product){
                        return CartTile(product);
                      }
                    ).toList(),
                  ),
                  DiscountCard(),
                  CartPrice(() async{
                    String orderId = await model.finishOrder();
                    if(orderId != null)
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => OrderScreen(orderId))
                    );
                  })
                ],
              );
            }
          }
        ),
    );
  }
}