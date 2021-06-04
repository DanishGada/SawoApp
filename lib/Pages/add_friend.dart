import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sawo/Database/database.dart';
import 'package:sawo/Models/User.dart';
import 'package:sawo/Pages/signup.dart';
import 'package:sawo/Widgets/MailGenerator.dart';

class addfriend extends StatefulWidget {
  User cur_user;
  List f;
  addfriend({this.cur_user,this.f});
  @override
  _addfriendState createState() => _addfriendState(cur_user:cur_user,f:f);
}

class _addfriendState extends State<addfriend> {
  List f;
  List<User> list_of_users = [];
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
        int j=0;
        cur_user.groups =[];
        for(var x in a.data()['groups']){
          if(cur_user.groups.toString()!='null') cur_user.groups.add(x);
          else{cur_user.groups = [{'groupname' : x[j]['groupname'] , 'member' : x[j]['members']}];}
          j+=1;
        }
      }
      else{
        temp.groups = [{'groupname' : '' , 'member' : List()}];
      }

      if(a.data()['data'].toString()!='null'){
        temp.data = {'name' :  a.data()['data']['name'], 'an' : a.data()['data']['an'] , 'dob' : a.data()['data']['dob'] , 'gender' : a.data()['data']['gender']};
      }
      else {
        temp.data =
        {'name': 'null', 'an': 'XXXXX', 'dob': '........', 'gender': 'M?F'};
      }
      list_of_users.add(temp);

    }
    return list_of_users;
  }
  User cur_user;
  _addfriendState({this.cur_user,this.f});
  @override
  bool flag=true;
  bool flag2 = true;
  final Friend_username = TextEditingController();
  String _user_name ='';
  User target =null;
  String result = '';

  List temp;
  getTextInputData() async {
    await getEventsFromFirestore();
    flag=true;
    flag2 =false;
    print('Now Checking....');
//    for(User x in list_of_users){printuser(x);}
    for(User p in list_of_users){
      if(p.id == cur_user.id){
        print('Found User');
        if(p.friends.toString() != '[]') {
          cur_user.friends = p.friends;
      }
      }
    }
    for (User x in list_of_users)
    {
      print('${x.name} ${Friend_username.text}');
      if (x.name == Friend_username.text)
      {
        target = x;
        flag2=true;
        break;
      }
    }

    print(cur_user.friends.toString());
        if(cur_user.friends.toString() == '[]' ||cur_user.friends.toString()== 'null'){
          temp=[];
          print('No Friends');
        }
        else {
          temp = cur_user.friends;
          for (var y in temp) {
            print(cur_user.name);
            print(y);
            if (y == Friend_username.text) {
              setState(() {
                print('He is Already a Friend');
                result = 'He is Already a Friend';
              });
              flag2 = false;
            }
          }
        }
        print('friends  $temp');

        if(flag2) {
          if(cur_user.friends.toString() == '[]' || cur_user.friends.toString()== 'null'){
            cur_user.friends= [Friend_username.text];

            print('Adding Friend');
            setState(() {
              result = 'Friend Req Sent to ${Friend_username.text}';
            });
          }
          else{
            cur_user.friends.add(Friend_username.text) ;
            print('Adding Friend');
            setState(() {
              result = 'Friend Req Sent to ${Friend_username.text}';
            });

          }
          await FirebaseFirestore.instance.collection('Users').document(
              cur_user.id).set({
            'Email': cur_user.Email,
            'name': cur_user.name,
            'pass': cur_user.pass,
            'friends': cur_user.friends,
            'groups': cur_user.groups,
            'Data': cur_user.data
          });
          if(target.friends.toString() =='[]' || target.friends.toString()== 'null'){
            target.friends = [cur_user.name];
          }
          else{target.friends.add(cur_user.name);}
          await FirebaseFirestore.instance.collection('Users').document(
              target.id).set({
            'Email':target.Email,
            'name': target.name,
            'pass': target.pass,
            'friends': target.friends,
            'groups': target.groups,
            'Data': target.data
          });
        }

        flag = false;

    if (!flag2) {
      setState((){
        result = 'Check Username And Try again';
      });
    }
    }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Friend'),
        actions: [
          Icon(Icons.add_alarm),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),),
        ],

      ),
        body: Column(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
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
                  ),
//                  Expanded(
//                    child: ListView.builder(
//                        padding: const EdgeInsets.all(8),
//                        itemCount: f.length,
//                        itemBuilder: (context, int index) {
//                          return Container(
//                            height: 70,
//                            margin: EdgeInsets.all(2),
//                            color: Colors.blue,
//                            child: Center(
//                              child: Row(
//                                children: [
//                                  if(f[index]!='')
//                                    Container(padding : EdgeInsets.symmetric(horizontal: 10,vertical: 5) ,child : CircleAvatar(radius : 25, child: Text(f[index][0].toUpperCase() ),
//                                    ))
//                                  else
//                                    Container(padding : EdgeInsets.symmetric(horizontal: 10,vertical: 5) ,child : CircleAvatar(radius : 25, child: Text('Error'),
//                                    ))
//                                  ,
//                                  Expanded(child: Container(
//                                    child :Column(
//                                      crossAxisAlignment: CrossAxisAlignment.start,
//                                      children: [
//                                        SizedBox(height: 10,),
//                                        Text(f[index], style: Theme.of(context)
//                                            .textTheme
//                                            .display1
//                                            .copyWith(fontSize: 20)
//                                        ),
//
//                                        Text(f[index]),
//                                      ],
//                                    ),
//
//                                  ))
//
//                                ],
//                              ),
//                            ),
//                          );
//                        }
//                    ),
//                  ),

                ],
              ),
            ),
          ],
        ));
  }
}


