import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';


class SignUpScreen extends StatefulWidget {
  
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
 final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _addressController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Criar Conta"),
        centerTitle: true,
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model){
          if(model.isLoading)
            return  Center(child: CircularProgressIndicator());

          return  Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            TextFormField(
              controller: _nomeController,
              decoration: InputDecoration(
                hintText: "Nome Completo"
              ),
              validator: (text){
                if(text.isEmpty)
                return "O campo 'nome' não pode ficar vazio!";
              },
            ),
            SizedBox(height: 16),
             TextFormField(
              controller: _emailController, 
              decoration: InputDecoration(
                hintText: "Email"
              ),
              validator: (text){
                if(text.isEmpty || !text.contains("@"))
                return "Email inválido!";
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _passController,
              decoration: InputDecoration(
                hintText: "Senha"
              ),
              obscureText: true,
              validator: (text){
                if(text.isEmpty || text.length<6)
                return "Senha invalida";
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(
                hintText: "Endereço"
              ),
              validator: (text){
                if(text.isEmpty)
                return "Endereço invalido";
              },
            ),
            SizedBox(height: 16),
            SizedBox(height: 44,
            child: RaisedButton(
              child: Text("Criar Conta",
              style: TextStyle(
                fontSize: 18
                ),
              ),
              textColor: Colors.white,
              color: Theme.of(context).primaryColor, 
              onPressed: (){
                if(_formKey.currentState.validate()){
                  
                  Map<String, dynamic> userData = {
                    "name":  _nomeController.text, 
                    "email":  _emailController.text,
                    "address":  _addressController.text
                  };

                  model.signUp(
                    userData: userData,
                    pass: _passController.text,
                    onSuccess: _onSuccess,
                    onFail: _onFail
                    );
                }
              }, 
            ),
            ),
          ],
        ),
        );
        }
        ),
    );
  }

  void _onSuccess(){
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text("Usuário criado!"),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 2)
      )
      );
      Future.delayed(Duration(seconds: 2)).then((_){
        Navigator.of(context).pop();
      });
  }


    void _onFail(){
          _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text("Falha ao criar usuário!"),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 2)
      )
      );
    
  }
}

