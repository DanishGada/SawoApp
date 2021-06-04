import 'package:flutter/material.dart';

import 'Data.dart';
import 'Group.dart';
class User{
  String id;
  String Email;
  String name;
  String pass;
  List<dynamic> friends = <String>[];
  List<Map<String , dynamic> >groups = [{'groupname' : 'null' , 'member' : List()}];
  Map<String, dynamic> data ={'name' : 'null' , 'an' : 'XXXXX' , 'dob' : '........' , 'gender' : 'M?F'};
  User({this.id,this.Email,this.name,this.pass ,this.friends, this.groups,this.data});

}
printuser(User x){
  print('name : ${x.name} \tEmail : ${x.Email} \tPass : ${x.pass} \tGroups :${x.groups} \tFriends : ${x.friends} \tData : ${x.data}');
}

class UserCard {
  String name='fdsfsa';
  String Email='fdsf sd';
  UserCard(this.name,this.Email);
  Widget userCard(name ,Email) {
    userCard(name, Email);
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              leading: Icon(Icons.album),
              title: Text('esese'),
              subtitle: Text('eseesdfdf'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('Request Data'),
                  onPressed: () {/* ... */},
                ),
                const SizedBox(width: 8),
                TextButton(
                  child: const Text('Remove Friend'),
                  onPressed: () {/* ... */},
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

