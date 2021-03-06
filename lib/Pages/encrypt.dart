import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_string_encryption/flutter_string_encryption.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TextEditingController pass = TextEditingController();

  var key = "null";
  String encryptedS,decryptedS;

  var password = "null";

  PlatformStringCryptor cryptor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Password Encrypt"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: TextField(
                controller: pass,
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                        color: Colors.red
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                          color: Colors.blue[400]
                      )
                  ),
                  isDense: true,                      // Added this
                  contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                ),
                cursorColor: Colors.white,
              ),
            ),
            RaisedButton(
              onPressed: (){
                Encrypt();
              },
              child: Text("Encrypt"),
            ),
            RaisedButton(
              onPressed: (){
                Decrypt();
              },
              child: Text("Decrypt"),
            ),
          ],
        ),
      ),
    );
  }

// method to Encrypt String Password
  Future<String> Encrypt() async{

    cryptor = PlatformStringCryptor();
    final salt = await cryptor.generateSalt();
    password = pass.text;
    key = await cryptor.generateKeyFromPassword(password, salt);
    // here pass the password entered by user and the key
    encryptedS = await cryptor.encrypt(password, key);
    return(encryptedS);
  }


// method to decrypt String Password
  void Decrypt() async{
    try{
      //here pass encrypted string and the key to decrypt it
      decryptedS = await cryptor.decrypt(encryptedS, key);
      print(decryptedS);
    }
    on MacMismatchException{

    }
  }

}