import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sawo/Database/database.dart';
import 'package:sawo/Models/User.dart';
import 'package:sawo/Pages/signup.dart';
import 'package:sawo/Widgets/bezierContainer.dart';
// import 'package:sawo_final/Pages/signup.dart';
// import 'package:sawo_final/Pages/HomeScreen.dart';
// import 'package:sawo_final/Widget/bezierContainer.dart';

import 'HomeScreen.dart';
import 'Home_1_Screen.dart';
class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final emailcontroller = TextEditingController();
  final passcontroller = TextEditingController();
  List  all_users = [];
  String temppass = 'null';
  var display_mail_error=false;
  var a;
  List<User> db;
  String id;
  User cur_user ;
  local_database()async{
    db = await database().get_database();
    print('Database : ${db}');
  }
  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.orange),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500,color: Colors.orange))
          ],
        ),
      ),
    );
  }
  Widget _entryField(String title, { bool isEmail = false ,bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,color: Colors.orange),
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            children: [
              if (isEmail)
                TextField(
                    controller: emailcontroller,
                    obscureText: isPassword,
                    decoration: InputDecoration(
                        hintText: "Email",
                        border: InputBorder.none,
                        fillColor: Color(0xfff3f3f4),
                        filled: true)),
              if(isPassword)
                TextField(
                    controller: passcontroller,
                    obscureText: isPassword,

                    decoration: InputDecoration(
                        hintText: "Password",
                        border: InputBorder.none,
                        fillColor: Color(0xfff3f3f4),
                        filled: true)),
            ],
          )
        ],
      ),
    );
  }
  present(var controller , var dic){
    try {
//      print(dic);
      for (var x in dic) {
        if (x['Emailid'] == controller) {
          temppass=x['pass'];
          return true;
        }
      }
    }
    catch(e) {
      print('errorr');
      return false;
    }
    return false;
  }
  getEventsFromFirestore() async {
    QuerySnapshot querySnapshot = await Firestore.instance.collection("Users")
        .getDocuments();
    for (int i = 0; i < querySnapshot.documents.length; i++) {
        a = querySnapshot.documents[i];
        all_users.add(a.data());
    }
  }
  bool check_Email_and_pass() {
    print(db[0].Email);
    for (User x in db) {
      print('${x.Email}  ${emailcontroller.text} ');
      if (x.Email == emailcontroller.text) {
        id=x.id;
        cur_user = x;
        temppass = x.pass;
        return true;
      }
      print(x.Email);
    }

    return false;
  }
  Widget _submitButton() {
    return InkWell(
        onTap: () async{

          WidgetsFlutterBinding.ensureInitialized();
          await Firebase.initializeApp();
          await local_database();
          var val = check_Email_and_pass();
//          print('$temppass  ${passcontroller.text} ');
          if(val){
            Navigator.pop(context);
              if(temppass == passcontroller.text){

                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(cur_user:cur_user,carry:( cur_user.groups.toString()!='null'?cur_user.groups.length : 0))));
              }
              else {print('Wrong password');}
          print('$temppass ${passcontroller.text}');}
          else{
            print('Wrong EmailID');}},

      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.orange.shade200,
                  offset: Offset(2, 3),
                  blurRadius: 5,
                  spreadRadius: 0.5)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xfffc9448), Color(0xfff6892b)])),
        child: Text(
          'Login',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _facebookButton() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff1959a9),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    topLeft: Radius.circular(5)),
              ),
              alignment: Alignment.center,
              child: Text('f',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.w400)),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff2872ba),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(5),
                    topRight: Radius.circular(5)),
              ),
              alignment: Alignment.center,
              child: Text('Log in with Facebook',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500)),
            ),
          ),
        ],
      ),
    );
  }
  Widget _signInButton(String p) {
    return OutlineButton(
      splashColor: Colors.grey,
      color: Colors.white,
      onPressed: () {},
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.orange),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/google_logo.jpg"), height: 25.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                '$p',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.orange,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget _gmail(String p) {
    return
      Column(

        children: [
          _facebookButton(),
          SizedBox(height: 10),
          _signInButton(p)
        ],
      );
  }
  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Don\'t have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,color: Colors.orange),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Register',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'T',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 80,
            fontWeight: FontWeight.w700,
            color: Color(0xffe46b10),
          ),
          children: [
            TextSpan(
              text: 'RI',
              style: TextStyle(color: Colors.orange, fontSize: 50),
            ),
            TextSpan(
              text: 'P',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 50),
            ),
          ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Email id" ,isEmail: true),
        _entryField("Password", isPassword: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
          color: const Color(0xF2000000),
          height: height,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: -height * .14,
                right: -MediaQuery.of(context).size.width * .4,
                child: BezierContainer(),),
              Positioned(
                top: height * .08,
                right: -MediaQuery.of(context).size.width * .4,
                child:  Image.asset('assets/images/sawo_logo.png',height: 40,
                  width: 500,),),
              Positioned(
                top: height * .05,
                right: MediaQuery.of(context).size.width * .15,
                child:  Text('Powered By'),),



              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * .17),
                      _title(),
                      SizedBox(height: 30),
                      _emailPasswordWidget(),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => HomeScreen()));
                        }, // handle your image tap here
                        child: _submitButton(),
                      ),

                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.centerRight,
                        child: Text('Forgot Password ?',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500,color: Colors.orange)),
                      ),
                      SizedBox(height: 10),
//                  _facebookButton(),
                      _gmail('Login with Gmail'),
                      SizedBox(height: 20),
                      _createAccountLabel(),
                    ],
                  ),
                ),
              ),
              Positioned(top: 40, left: 0, child: _backButton()),
            ],
          ),
        ));
  }

}