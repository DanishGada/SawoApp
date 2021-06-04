import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sawo/Database/database.dart';
import 'package:sawo/Models/User.dart';
import 'package:sawo/Pages/sentiment.dart';
import 'package:sawo/Widgets/CustomListTile.dart';
import 'package:sawo/Widgets/MailGenerator.dart';
import 'package:sawo/Widgets/Tabs.dart';
import 'package:sawo/Pages/add_friend.dart';

// import 'package:sawo_final/Widget/CustomListTile.dart';
// import 'package:sawo_final/Widget/MailGenerator.dart';
// import 'package:sawo_final/Widget/Tabs.dart';

import 'AddGroup.dart';
import 'Home_1_Screen.dart';
import 'Ocr_read.dart';
import 'add_group.dart';
import 'dashboard.dart';
// import 'maps_screen.dart';


class HomeScreen extends StatefulWidget {
  int carry =0;
  final User cur_user;
  HomeScreen({Key key, this.cur_user,this.carry}) : super(key: key);
  @override
  MyHomePageState createState() => MyHomePageState(cur_user: this.cur_user,carry:carry);
}

class MyHomePageState extends State<HomeScreen> {
  User cur_user;
  List f =[];
  List g = [];
  int carry=0;
  find() async {
    print(cur_user.id);
    await Firebase.initializeApp();
    QuerySnapshot querySnapshot = await Firestore.instance.collection("Users").getDocuments();
    for (int i = 0; i < querySnapshot.documents.length; i++) {
      var a = querySnapshot.documents[i];
      if (a.id == cur_user.id) {
        print('found user');
        f = (a.data()['friends'].toString()!='null'  ? a.data()['friends']: List());
        cur_user.groups=[];
        if(a.data()['groups'].toString() != 'null'){
          int i=0;
          for(var x in a.data()['groups']){
            if(cur_user.groups.toString()!='null') cur_user.groups.add(x);
            else{cur_user.groups = [{'groupname' : a.data()['groups'][i]['groupname'] , 'member' : a.data()['groups'][i]['members']}];}
//            printuser(cur_user);
            i+=1;
          }
        }
      }
    }
  }
  dash(){
    return dashboard(cur_user: cur_user,g:g,carry:carry,param: false,);
  }
  MyHomePageState({this.cur_user,this.carry});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getMailAppBar(),
      drawer: _getMailAccountDrawerr(),
      body: dash(),
      floatingActionButton: _getMailFloatingActionButton(),
    );
  }

  FloatingActionButton _getMailFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () async{
        await find();
        print(f);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => show_friends(cur_user: cur_user,f:f)),
        );
      },
      child: Icon(Icons.person),
      backgroundColor:  Color(0xFF89216B),
    );
  }

  AppBar _getMailAppBar() {
    return AppBar(
      backgroundColor:Colors.blueAccent,
      title: Text('${cur_user.name}'),
      actions: [
        Icon(Icons.file_download),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Icon(Icons.search),), Icon(Icons.more_vert),
      ],

    );
  }
  custom()async{
    await find();

    if(cur_user.groups.toString() == 'null'){
      int carry = 0 ;
    }
    else{
      int carry = cur_user.groups.length;
    }
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => addgroup(cur_user : cur_user,f:f,carry:carry)));
  }
  custum1()async{
    await find();
    print(f.length);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => addfriend(cur_user:cur_user,f:f)));
  }
  Drawer _getMailAccountDrawerr() {
    Text email = new Text(
      cur_user.Email,
      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0),
    );

    Text name = new Text(
      cur_user.name,
      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0),
    );

    return Drawer(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(gradient : LinearGradient(
                  colors: [ Color(0xFFDA4453), Color(0xFF89216B) ])),
              accountName: name,
              accountEmail: email,
              currentAccountPicture: Icon(
                Icons.account_circle,
                size: 50.0,
                color: Colors.black,
              ),
            ),
            Expanded(
              flex: 2,
              child: ListView(
                  children : <Widget>[
                    CustomListTile(Icons.map,'Maps',()=>{ }),
                    CustomListTile(Icons.network_locked,'Sentiment_Analysis',()=>{
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => sentiment()))
                    }),
                    CustomListTile(Icons.group_add,'Add Friend',()async=>{
                     await custum1()
                    }),
                    CustomListTile(Icons.group_add_rounded,'Add group',()=>{
                      custom()
                    }),
                    CustomListTile(Icons.scanner,'Ocr_Scanner',()=>{
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => Ocr_read(cur_user : cur_user)))
                    }
                    ),

                  ]

              ),
            )
          ],
        ));
  }


}