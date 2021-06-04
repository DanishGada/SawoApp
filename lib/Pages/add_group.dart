import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sawo/Database/database.dart';
import 'package:sawo/Models/User.dart';
import 'package:sawo/Pages/signup.dart';
import 'package:sawo/Widgets/MailGenerator.dart';
import 'HomeScreen.dart';
import 'add_group.dart';
import 'dashboard.dart';
class addgroup extends StatefulWidget {
  List f;
  User cur_user;
int carry;
  addgroup({this.cur_user,this.f,this.carry});
  @override
  _addgroupState createState() => _addgroupState(cur_user:cur_user , f:f,carry:carry);
}

class _addgroupState extends State<addgroup> {
  _addgroupState({this.cur_user,this.f,this.carry});
int carry;
  List f;
  List<User> list_of_users = [];
  User new_cur_user;
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
      print(a.data()['groups'].toString()=='null');
      if(a.data()['groups'].toString() != 'null'){

        int i=0;
        for(var x in a.data()['groups']){
          if(temp.groups.toString()!='null') temp.groups.add(x);
        else{temp.groups = [{'groupname' : a.data()['groups'][i]['groupname'] , 'member' : a.data()['groups'][i]['member']}];}
        printuser(temp);
        i+=1;
      }
      }
      if(a.data()['data'].toString()!='null'){
        temp.data = {'name' :  a.data()['data']['name'], 'an' : a.data()['data']['an'] , 'dob' : a.data()['data']['dob'] , 'gender' : a.data()['data']['gender']};
      }
      else {
        temp.data =
        {'name': 'null', 'an': 'XXXXX', 'dob': '........', 'gender': 'M?F'};
        list_of_users.add(temp);
      }
    }
    return list_of_users;
  }
  User cur_user;
  @override
  bool flag=true;
  bool flag2 = true;
  final group_name = TextEditingController();
  String _user_name ='';
  String result = '';
//
  List temp;
  getTextInputData() async {
    await getEventsFromFirestore();
    flag=true;
    flag2 =true;
    print('Now Checking....');

//    for(User x in list_of_users){printuser(x);}
    for(User p in list_of_users){
      if(p.id == cur_user.id){
        print('Found User');
        print(p.groups.toString());
        print(p.groups);
        print(p.groups.runtimeType);
        if(p.groups.toString() != 'null' ) {
          int i=0;
          print('noerrorhere');
          cur_user.groups =[];
          for(var x in p.groups){
            if(cur_user.groups.toString()!='null') cur_user.groups.add(x);
            else{cur_user.groups = [{'groupname' : x[i]['groupname'] , 'member' : x[i]['member']}];}
            i+=1;
          }
        }
      }
    }
//    for (User x in list_of_users)
//    {
//      print('${x.name} ${group_name.text}');
//      if (x.name == group_name.text)
//      {
//        target = x;
//        flag2=true;
//        break;
//      }
//    }
    print(cur_user.groups.toString());
    if(cur_user.groups.toString() == '[]' ||cur_user.groups.toString()== 'null'){
//      temp=[{'groupname' : '' , 'member' : ''}];
      print('No groups');
    }
    else {
//      temp = cur_user.groups;
    }
    print('friends  $temp');
    if(flag2) {
      if(cur_user.groups.toString() == '[]' || cur_user.groups.toString()== 'null'){
        cur_user.groups= [{'groupname' : '${group_name.text}' , 'member' : ''}];
        print('Adding Group');
        setState(() {
          new_cur_user = cur_user;
          result = 'Group added ${group_name.text}';
        });
      }
      else{
        cur_user.groups.add({'groupname' : group_name.text,'member' : List()}) ;
        print('Adding Friend');
        setState(() {
          new_cur_user = cur_user;
          result = 'New Group named ${group_name.text} has been Created';
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
    }

    flag = false;

    if (!flag2) {
      setState((){
        new_cur_user = cur_user;
        result = 'Check Username And Try again';
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back),
            tooltip: "Cancel and Return to List",
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomeScreen( cur_user : cur_user,carry:(cur_user.groups.toString() != 'null' ?  cur_user.groups.length : 0))));
            },
          ),
        title: Text('Create Group'),),
        body: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child: TextField(
                  controller: group_name,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name of New Group',
                  ),
                ),
              ),

              RaisedButton(
                onPressed: getTextInputData,
                color: Colors.orange,
                textColor: Colors.white,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Text('Create New Group'),
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


