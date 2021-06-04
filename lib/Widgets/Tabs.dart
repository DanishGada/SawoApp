import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sawo/Models/User.dart';

class show_friends extends StatefulWidget {
  User cur_user ;
  List f;
  show_friends({this.cur_user,this.f});
  @override
  _show_friends createState() => _show_friends(cur_user : cur_user , f:f);
}
class _show_friends extends State<show_friends> {


  User cur_user ;
  List f;
  _show_friends({this.cur_user,this.f});

  List<User> list_of_users = [];

  find() async {
    print(cur_user.id);
    await Firebase.initializeApp();
    QuerySnapshot querySnapshot = await Firestore.instance.collection("Users")
        .getDocuments();
    for (int i = 0; i < querySnapshot.documents.length; i++) {
      var a = querySnapshot.documents[i];
      if (a.id == cur_user.id) {
        print('found user');
        String temp = a.data()['friends'];
        try {
          f = temp.split('@');
        }
        catch (e) {
          f = [];
        }
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('All My Friends'),
          backgroundColor: Colors.orangeAccent,
        ),
        body: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: f.length.toString()!='null'?f.length : 0,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 70,
                margin: EdgeInsets.all(10),
                color: Colors.teal,
                child: Center(
                  child: Row(
                    children: [

                  if(f[index]!='')
                      Container(padding : EdgeInsets.symmetric(horizontal: 10,vertical: 5) ,child : CircleAvatar(radius : 25, child: Image.asset('assets/unknown.jpg', height: 60.0, ),),)
                  else
                    Container(padding : EdgeInsets.symmetric(horizontal: 10,vertical: 5) ,child : CircleAvatar(radius : 25, child: Text('Error'),
                    ))
                      ,
                      Expanded(child: Container(

                        child :Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10,),
                            Text('Name  : ${f[index]}', style: Theme.of(context)
                                .textTheme
                                .display1
                                .copyWith(fontSize: 20)
                            ),

                            Text('Email          : ${f[index]}@gmail.com'),
                          ],
                        ),

                      ))

                    ],
                  ),
                ),
              );
            }
        )
    );
  }
}

