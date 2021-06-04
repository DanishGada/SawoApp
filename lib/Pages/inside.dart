import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sawo/Models/User.dart';

class show_friends1 extends StatefulWidget {
  User cur_user ;
  List f;
  show_friends1({this.cur_user,this.f});
  @override
  _show_friends1 createState() => _show_friends1(cur_user : cur_user , f:f);
}
class _show_friends1 extends State<show_friends1> {


  User cur_user ;
  List f;
  _show_friends1({this.cur_user,this.f});

  List<User> list_of_users = [];


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
                margin: EdgeInsets.all(2),
                color: Colors.blue,
                child: Center(
                  child: Row(
                    children: [
                      if(f[index]!='')
                        Container(padding : EdgeInsets.symmetric(horizontal: 10,vertical: 5) ,child : CircleAvatar(radius : 25, child: Text(f[index][0].toUpperCase() ),
                        ))
                      else
                        Container(padding : EdgeInsets.symmetric(horizontal: 10,vertical: 5) ,child : CircleAvatar(radius : 25, child: Text('Error'),
                        ))
                      ,
                      Expanded(child: Container(
                        child :Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10,),
                            Text(f[index], style: Theme.of(context)
                                .textTheme
                                .display1
                                .copyWith(fontSize: 20)
                            ),

                            Text(f[index]),
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

