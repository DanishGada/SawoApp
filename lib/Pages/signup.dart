import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sawo/Database/database.dart';
import 'package:sawo/Models/Data.dart';
import 'package:sawo/Models/Group.dart';
import 'package:sawo/Models/User.dart';
import 'package:sawo/Widgets/bezierContainer.dart';
// import 'package:sawo_final/Widget/bezierContainer.dart';

import '../read.dart';
import 'HomeScreen.dart';
import 'loginPage.dart';
class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}
class _SignUpPageState extends State<SignUpPage> {
  final emailcontroller = TextEditingController();
  final passcontroller = TextEditingController();
  final usercontroller  = TextEditingController();
  bool invallid_email = false;
  bool invallid_pass = false;
  List <String> current_user_email = [];
  List <String> current_user_username = [];
  List<User> db;
  List<String> friends=<String>[];
  List<Map<String ,dynamic>> groups = [{'groupname': '', 'members': []}];
  Map<String, dynamic> data ={'name' : 'null' , 'an' : 'XXXXX' , 'dob' : '........' , 'gender' : 'M?F'};
  User cur_user;
  local_database()async{
    db = await database().get_database();
    print(db);
    return db;
  }
  bool checkemail() {
    for (User x in db) {
      if (x.Email == emailcontroller.text) {
        return true;
      }
    }
      return false;

  }
  bool checkusername(){
      for (User x in db) {
        if (x.name == usercontroller.text) return true;
      }
      return false;
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
  Widget _entryField(String title, {bool isPassword = false, bool isEmail = false , bool isUsername = false}) {
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
              if (isUsername)
        TextField(
        controller: usercontroller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: "Username",
            border: InputBorder.none,
            fillColor: Color(0xfff3f3f4),
            filled: true)),
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
  Widget _submitButton() {
    return InkWell(
      onTap: () async{
        setState(() {
          invallid_pass = false;
          invallid_email = false;
        });
        WidgetsFlutterBinding.ensureInitialized();
        await Firebase.initializeApp();
        await local_database();
        bool val = checkusername() || checkemail();
        if(!emailcontroller.text.contains('@')){
          print('Does not contain @');
          setState(() {
            invallid_email = true;
            val = true;
            emailcontroller.clear();
          });
        }
        if(passcontroller.text.length<3){
          setState(() {
            invallid_pass = true;
            val = true;
//            passcontroller.clear();
          });

        }
        if(!val) {
          FirebaseFirestore.instance
              .collection('Users')
              .add({
            'Email': emailcontroller.text,
            'name': usercontroller.text,
            'pass': passcontroller.text,
            'friends': List(),
            'groups': groups,
            'Data': data,
          });
          cur_user = User(name: usercontroller.text,
              Email: emailcontroller.text,
              pass: passcontroller.text,
              friends: [],
              groups: groups,
              data: data);
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => LoginPage()));
        }
//          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
        else{
          if(!checkusername()){print('Email already taken');}
          if(!checkemail()){print('username already taken');}
        }
      },
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
                  blurRadius: 10,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xfffbb448), Color(0xfff7892b)])),
        child: Text(
          'Register Now',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
    );
  }
  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,color:Colors.orange),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Login',
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
    );}
  Widget _gmail(String p) {
    return
      Column(

        children: [
          SizedBox(height: 10),
          _signInButton(p)
        ],
      );}
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
        _entryField("Username" , isUsername : true),

        _entryField("Email id" , isEmail : true),
        invallid_email ? Text('Invalid Email',style: TextStyle(color: Colors.white),) : SizedBox(height: 1,),
        _entryField("Password", isPassword: true),
        invallid_pass ? Text('Please Enter a Valid Password',style: TextStyle(color: Colors.white),) : SizedBox(height: 1,),

      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        color:const Color(0xF2000000),
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
                    SizedBox(height: height * .2),
                    _title(),
                    SizedBox(
                      height: 50,
                    ),
                    _emailPasswordWidget(),
                    SizedBox(
                      height: 20,
                    ),
                    _submitButton(),
                    SizedBox(height: 20),
                    _gmail("Sign Up with Google"),
                    SizedBox(height: 20),
                    _loginAccountLabel(),

                  ],
                ),
              ),
            ),
            Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }
}