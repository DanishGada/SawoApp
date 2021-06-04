import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sawo/Models/User.dart';
import 'package:sawo/Widgets/Tabs.dart';
import 'HomeScreen.dart';
import 'add_group.dart';
import 'add_members_to_selected_group.dart';
import 'inside.dart';
class dashboard extends StatefulWidget {
  User cur_user;
  List g;
  int carry ;
  bool param;
  dashboard({this.cur_user,this.g,this.carry,this.param});
  @override

  _dashboard createState() => _dashboard(cur_user: cur_user,g:g,carry:carry,param:param);
}
class _dashboard extends State<dashboard> {
  void initState()  {
    super.initState();
    if(param){Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomeScreen(cur_user : cur_user,carry: carry,)));
    };


  }
  User cur_user;
  List g;
  List f;
  int carry;
  bool param;
  _dashboard({this.cur_user,this.g,this.carry,this.param});
  TextEditingController nameController = TextEditingController();

  find(int index) async {
    if(index==0){
      f=[];
      return false;
    }
    print(cur_user.id);
    await Firebase.initializeApp();
    QuerySnapshot querySnapshot = await Firestore.instance.collection("Users").getDocuments();
    for (int i = 0; i < querySnapshot.documents.length; i++) {
      var a = querySnapshot.documents[i];
      if (a.id == cur_user.id) {
        f=a.data()['groups'][index]['member'];
        print(f);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount:   carry,
            itemBuilder: (BuildContext context, int index) {
              return Padding
                (
                padding: EdgeInsets.only(bottom: 16.0),
                child: Stack
                  (
                  children: <Widget>
                  [
                    /// Item card
                    Align
                      (
                      alignment: Alignment.topCenter,
                      child: SizedBox.fromSize
                        (
                          size: Size.fromHeight(172.0),
                          child: Stack
                            (
                            fit: StackFit.expand,
                            children: <Widget>
                            [
                              /// Item description inside a material
                              InkWell(
                                onTap: ()async{
                                  await find(index);
                                  Navigator.push(
                                      context, MaterialPageRoute(builder: (context) => show_friends1(cur_user : cur_user,f:f)));
                                },
                                child: Container
                                  (
                                  margin: EdgeInsets.only(top: 24.0),
                                  child: Material
                                    (
                                    elevation: 14.0,
                                    borderRadius: BorderRadius.circular(12.0),
                                    shadowColor: Color(0x802196F3),
                                    color: Colors.transparent,
                                    child: Container
                                      (
                                      decoration: BoxDecoration
                                        (
                                          gradient: LinearGradient
                                            (
                                              colors: [ Color(0xFFDA4453), Color(0xFF89216B) ]
                                          )
                                      ),
                                      child: Padding
                                        (
                                        padding: EdgeInsets.all(24.0),
                                        child: Column
                                          (
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>
                                          [
                                            /// Title and rating
                                            Column
                                              (
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>
                                              [
                                                carry > 0 ?Text('${cur_user.groups[index]['groupname']}' , style: TextStyle(color: Colors.white)):Text("Create Group"),
                                                Row
                                                  (
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: <Widget>
                                                  [
                                                    carry>0? Text('${(cur_user.groups[index]['member'].toString()!='null'?cur_user.groups[index]['member'].length : 0)}', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.w700, fontSize: 34.0)):Text("create Group"),
                                                    Icon(Icons.person, color: Colors.amber, size: 30.0),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            /// Infos
                                            Row
                                              (
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>
                                              [
                                                Text('Creator', style: TextStyle(color: Colors.white)),
                                                Padding
                                                  (
                                                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                                                  child: Text('of', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                                                ),
                                                Text('Group is', style: TextStyle(color: Colors.white)),
                                                Padding
                                                  (
                                                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                                                  child: Material
                                                    (
                                                    borderRadius: BorderRadius.circular(8.0),
                                                    color: Colors.green,
                                                    child: Padding
                                                      (
                                                      padding: EdgeInsets.all(4.0),
                                                      child: Text(' Danish Gada', style: TextStyle(color: Colors.white)),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              /// Item image
                              Align
                                (
                                alignment: Alignment.topRight,
                                child: Padding
                                  (
                                  padding: EdgeInsets.only(right: 16.0),
                                  child: SizedBox.fromSize
                                    (
                                    size: Size.fromRadius(54.0),
                                    child: Material
                                      (
                                      elevation: 20.0,
                                      shadowColor: Color(0x802196F3),
                                      shape: CircleBorder(),
                                      child: Image.asset('assets/unknown.jpg', width: 10,),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                      ),
                    ),
                    /// Review
                    Padding
                      (
                      padding: EdgeInsets.only(top: 160.0, right: 32.0,),
                      child: Material
                        (
                        elevation: 12.0,
                        color: Colors.white,
                        borderRadius: BorderRadius.only
                          (
                          topRight: Radius.circular(20.0),
                          bottomLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                        ),
                        child: Container
                          (
                          margin: EdgeInsets.symmetric(vertical: 4.0),
                          child: ListTile
                            (
                            leading: CircleAvatar
                              (
                              backgroundColor: Colors.purple,
                              child: Text('AI'),
                            ),

                            title: Row(
                              children: [
                                RaisedButton(
                                  onPressed: () {},
                                  textColor: Colors.white,
                                  padding: const EdgeInsets.all(0.0),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [ Color(0xFFDA4453), Color(0xFF89216B) ]
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(10.0),
                                    child:
                                    const Text('Request Data', style: TextStyle(fontSize: 15)),
                                  ),
                                ),SizedBox(width: 30,),
                                RaisedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context, MaterialPageRoute(builder: (context) => add_members_to_selected_group(cur_user : cur_user,index: index,carry:carry)));
//                                    if(cur_user.groups[index]['member'].toString()!='null') {
//                                      cur_user.groups[index]['member'].add(
//                                          'danish');
//                                    }
//                                    else{
//                                      cur_user.groups[index]['member'] = ['Danish'];
//                                    }
//                                    cur_user.groups[index]={'groupname' : cur_user.groups[index]['groupname'] , 'member' : cur_user.groups[index]['member']};
//                                    print(cur_user.groups[index]);
                                  },
                                  textColor: Colors.white,
                                  padding: const EdgeInsets.all(0.0),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [ Color(0xFFDA4453), Color(0xFF89216B) ]
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(10.0),
                                    child:
                                    const Text('Add Members', style: TextStyle(fontSize: 15)),
                                  ),
                                ),

                              ],
                            ),
                            subtitle: Text('This Group was Created for the following Purpose', maxLines: 2, overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
        )
    );
  }
}

