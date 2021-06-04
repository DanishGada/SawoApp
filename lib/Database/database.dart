import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sawo/Models/User.dart';
class database {
  List<User> list_of_users = [];

  getEventsFromFirestore() async {
    QuerySnapshot querySnapshot = await Firestore.instance.collection("Users")
        .getDocuments();
    for (int i = 0; i < querySnapshot.documents.length; i++) {
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
            else{temp.groups = [{'groupname' : a.data()['groups'][i]['groupname'] , 'member' : a.data()['groups'][i]['members']}];}
//            printuser(temp);
            i+=1;
          }
        }
        else{
          temp.groups = [{'groupname' : 'null' , 'member' : []}];
        }
        if(a.data()['data'].toString()!='null'){
          temp.data = {'name' :  a.data()['data']['name'], 'an' : a.data()['data']['an'] , 'dob' : a.data()['data']['dob'] , 'gender' : a.data()['data']['gender']};
        }
        else{
          temp.data ={'name' : 'null' , 'an' : 'XXXXX' , 'dob' : '........' , 'gender' : 'M?F'};
        }
        list_of_users.add(temp);
      }
    }
    return list_of_users;
  }
  get_database()async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    return await getEventsFromFirestore();

  }
}


