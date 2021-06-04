import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sawo/Database/database.dart';
import 'package:sawo/Models/User.dart';
import 'package:sawo/Pages/signup.dart';
import 'package:sawo/Widgets/MailGenerator.dart';

import 'HomeScreen.dart';
import 'dashboard.dart';

class add_members_to_selected_group extends StatefulWidget {
  User cur_user;
  int index;
  int carry;
  add_members_to_selected_group({this.cur_user,this.index,this.carry});
  @override
  _add_members_to_selected_group createState() => _add_members_to_selected_group(cur_user:cur_user,index: index,carry :carry);
}

class _add_members_to_selected_group extends State<add_members_to_selected_group> {
  List<User> list_of_users = [];
  int index;
int carry;
  getEventsFromFirestore() async {
    await Firebase.initializeApp();
    QuerySnapshot querySnapshot = await Firestore.instance.collection("Users").getDocuments();
    for (int i = 0; i < querySnapshot.documents.length; i++) {
      var a = querySnapshot.documents[i];
      User temp = User(id:a.id,Email: a.data()['Email'],name: a.data()['name'],pass:a.data()['pass']);
      if(a.data()['friends'].toString()=='[]'){
        print('handled');
      }
      else{
        temp.friends=a.data()['friends'];
      }
      if(a.data()['groups'].toString() != 'null'){
        temp.groups = a.data()['groups'];
      }
      else{
        temp.groups = [{'groupname' : '' , 'member' : List()}];
      }
      list_of_users.add(temp);

    }
    return list_of_users;
  }
  User cur_user;
  _add_members_to_selected_group({this.cur_user,this.index,this.carry});
  @override
  bool flag=true;
  bool flag2 = true;
  final Friend_username = TextEditingController();
  String _user_name ='';
  User target =null;
  String result = '';
  check_for_friend()async{
    bool add = true;
    if(cur_user.friends.toString() !='null'){
      for(String f in cur_user.friends){
        //Check if friend exists in friends
        if(f==Friend_username.text){
          //check if friend already in group
          print(index);
          print(cur_user.groups[0]);
          if(cur_user.groups[index]['member'].toString()!='null'){
            List Members =cur_user.groups[index]['member'];
            for(String m in Members){
              print(m==Friend_username.text);
              if(m==Friend_username.text){
                print('Friend already in group');
                add=false;
              }
            }
            if(add){
              cur_user.groups[index]['member'].add(Friend_username.text);
              await FirebaseFirestore.instance.collection('Users').document(
                  cur_user.id).set({
                'Email': cur_user.Email,
                'name': cur_user.name,
                'pass': cur_user.pass,
                'friends': cur_user.friends,
                'groups': cur_user.groups,
                'Data': cur_user.data
              });
            }
          }
          else{
            add=false;
            cur_user.groups[index]['member'] = [Friend_username.text];
            await FirebaseFirestore.instance.collection('Users').document(
                cur_user.id).set({
              'Email': cur_user.Email,
              'name': cur_user.name,
              'pass': cur_user.pass,
              'friends': cur_user.friends,
              'groups': cur_user.groups,
              'Data': cur_user.data
            });
          }

        }
        else{print('Could not find ${Friend_username.text}');}
      }
    }
    else{print('Add friends first');}
    //Add to Firebase
    if(!add){


    }


  }
  List temp;
  getTextInputData() async {
//    await getEventsFromFirestore();
    flag=true;
    flag2 =false;
    print('Now Checking....');
//    for(User x in list_of_users){printuser(x);}
//    for(User p in list_of_users){
//      if(p.id == cur_user.id){
//        print('Found User');
//        if(p.friends.toString() != '[]') {
//          cur_user.friends = p.friends;
//        }
//      }
//    }
//    for (User x in list_of_users)
//    {
//      print('${x.name} ${Friend_username.text}');
//      if (x.name == Friend_username.text)
//      {
//        target = x;
//        flag2=true;
//        break;
//      }
//    }
//
//    print(cur_user.friends.toString());
//    if(cur_user.friends.toString() == '[]' ||cur_user.friends.toString()== 'null'){
//      temp=[];
//      print('No Friends');
//    }
//    else {
//      temp = cur_user.friends;
//      for (var y in temp) {
//        print(cur_user.name);
//        print(y);
//        if (y == Friend_username.text) {
//          setState(() {
//            print('He is Already a Friend');
//            result = 'He is Already a Friend';
//          });
//          flag2 = false;
//        }
//      }
//    }
//    print('friends  $temp');
//
//    if(flag2) {
//      if(cur_user.friends.toString() == '[]' || cur_user.friends.toString()== 'null'){
//        cur_user.friends= [Friend_username.text];
//
//        print('Adding Friend');
//        setState(() {
//          result = 'Friend Req Sent to ${Friend_username.text}';
//        });
//      }
//      else{
//        cur_user.friends.add(Friend_username.text) ;
//        print('Adding Friend');
//        setState(() {
//          result = 'Friend Req Sent to ${Friend_username.text}';
//        });
//
//      }
//      await FirebaseFirestore.instance.collection('Users').document(
//          cur_user.id).set({
//        'Email': cur_user.Email,
//        'name': cur_user.name,
//        'pass': cur_user.pass,
//        'friends': cur_user.friends,
//        'groups': cur_user.groups,
//        'Data': cur_user.data
//      });
//      if(target.friends.toString() =='[]' || target.friends.toString()== 'null'){
//        target.friends = [cur_user.name];
//      }
//      else{target.friends.add(cur_user.name);}
//      await FirebaseFirestore.instance.collection('Users').document(
//          target.id).set({
//        'Email':target.Email,
//        'name': target.name,
//        'pass': target.pass,
//        'friends': target.friends,
//        'groups': target.groups,
//        'Data': target.data
//      });
//    }
//
//    flag = false;
//
//    if (!flag2) {
//      setState((){
//        result = 'Check Username And Try again';
//      });
//    }
  check_for_friend();
  printuser(cur_user);
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Friend'),
            leading: IconButton(icon: Icon(Icons.arrow_back),
              tooltip: "Cancel and Return to List",
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => HomeScreen(cur_user : cur_user,carry: carry,)));
              },
            )

        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Container(
                  width: 280,
                  padding: EdgeInsets.all(10.0),
                  child: TextField(

                    controller: Friend_username,
                    autocorrect: true,
                    decoration: InputDecoration(hintText: 'Username of Friend'),
                  )
              ),

              RaisedButton(
                onPressed: getTextInputData,
                color: Colors.orange,
                textColor: Colors.white,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Text('Add Friend'),
              ),

              Padding(
                  padding: EdgeInsets.all(8.0),
                  child :
                  Text("$result", style: TextStyle(fontSize: 20))
              )

            ],
          ),
        ));
  }
}


