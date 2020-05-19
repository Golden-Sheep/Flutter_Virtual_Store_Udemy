

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model{
    UserModel user;

    List<CartProduct> products = [];

    String cupomCode;
    int discountPercentage = 0;

    CartModel(this.user){
      if(user.isLoggedIn())
      _loadCartItems();
    }

    bool isLoading = false;

    static CartModel of (BuildContext context) => ScopedModel.of<CartModel>(context);

    void incProduct(CartProduct cartProduct){
      cartProduct.quantity ++;
      Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart").document(cartProduct.cid).updateData(cartProduct.toMap());
      notifyListeners();
    }

    void decProduct(CartProduct cartProduct){
      cartProduct.quantity --;
      Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart").document(cartProduct.cid).updateData(cartProduct.toMap());
      notifyListeners();
    }

    void addCartItem(CartProduct cartProduct){
      products.add(cartProduct);

      Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart")
      .add(cartProduct.toMap()).then((doc){
        cartProduct.cid = doc.documentID;
      });

      notifyListeners();

    }

    void removeCartItem(CartProduct cartProduct){
      Firestore.instance.collection("users").document(user.firebaseUser.uid).
      collection("cart").document(cartProduct.cid).delete();

      products.remove(cartProduct);
      notifyListeners();

    }

    void _loadCartItems () async{
         QuerySnapshot query = await Firestore.instance.collection("users").
         document(user.firebaseUser.uid).
         collection("cart").getDocuments();

         products = query.documents.map((doc)=> CartProduct.fromDocument(doc)).toList();

         notifyListeners();
    }

    double getProductsPrice(){
      double price = 0.0;
      for(CartProduct c in products){
        if(c.productData != null){
          price = price + (c.quantity * c.productData.preco);
        }

      }
        return price;
    }

    void updatePrices(){
      notifyListeners();
    }

    double getDiscount(){
      return getProductsPrice() * discountPercentage / 100;
      }

    Future<String> finishOrder() async{
      if(products.length == 0 ) return null;

      isLoading = true;

      notifyListeners();

      double productsPrice = getProductsPrice();
      double discount = getDiscount();

      DocumentReference refOrders = await Firestore.instance.collection("orders").add({
        "clientId" : user.firebaseUser.uid,
        "products" : products.map((cartProdut) => cartProdut.toMap()).toList(),
        "discount" : discount,
        "productsPrice" : productsPrice,
        "totalPrice" : productsPrice - discount,
        "status" : 1
      });

     await Firestore.instance.collection("users").document(user.firebaseUser.uid).
      collection("orders").document(refOrders.documentID).setData({
        "orderId" : refOrders.documentID
      });

    QuerySnapshot query = await Firestore.instance.collection("users").document(user.firebaseUser.uid)
    .collection("cart").getDocuments();

    for(DocumentSnapshot doc in query.documents){
      doc.reference.delete();
    }


    products.clear();
    cupomCode = null;
    discountPercentage = 0;
    isLoading = false;
    notifyListeners();

    return refOrders.documentID;
    }



    void setCupom(String cupomCode, int cupomPorcent){
      this.discountPercentage =  cupomPorcent;
      this.cupomCode = cupomCode;
    }

}