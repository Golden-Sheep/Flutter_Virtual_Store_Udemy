import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData {
  String categoria;
  String id;
  String title;
  double preco;
  String descricao;
  List images;
  List sizes;

  ProductData.fromDocument(DocumentSnapshot snapshot){
    id = snapshot.documentID;
    title = snapshot.data["title"];
    descricao = snapshot.data["descricao"];
    preco = snapshot.data["preco"] + 0.0;
    images = snapshot.data["images"];
    sizes = snapshot.data["sizes"];
  }


  Map<String, dynamic> toResumeMap(){
    return{
      "title": title,
      "descricao": descricao,
      "preco": preco
    };
  }
}