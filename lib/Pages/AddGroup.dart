import 'package:flutter/material.dart';
import 'package:sawo/Models/Group.dart';
import 'package:sawo/Models/User.dart';

class AddGroup extends StatefulWidget {
  List f;
  User cur_user;
  @override
  AddGroup({this.cur_user,this.f});
  _addgroup createState() => _addgroup(cur_user:cur_user,f:f);
}

class _addgroup extends State<AddGroup> {
  User cur_user;
  List f;
  _addgroup({this.cur_user,this.f});
  TextEditingController nameController = TextEditingController();
  void addItemToList(){
    setState(() {
//      user_list.insert(0,temp1);
//      msgCount.insert(0, 0);
    });
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
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name of New Group',
                  ),
                ),
              ),
              RaisedButton(
                child: Container( padding: EdgeInsets.all(10),

                  child: Row(
                    children: [

                      Icon(Icons.add),
                      Text('Add Group'),
                    ],
                  ),
                ),
                onPressed: () {
                  addItemToList();
                },
              ),
              Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: [].length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          height: 70,
                          margin: EdgeInsets.all(2),
//                          color: msgCount[index]>=10? Colors.orange[400]:
//                          msgCount[index]>3? Colors.orangeAccent[100]: Colors.deepOrangeAccent,
                          child: Center(
                            child: Row(

                              children: [
                                Container(padding : EdgeInsets.symmetric(horizontal: 10,vertical: 5) ,child : CircleAvatar(radius : 25, child: Text([][index].groupname[0].toUpperCase()+[][index].groupname[1] ))),
                                Expanded(child: Container(
                                  child :Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10,),
                                      Text([][index].groupname, style: Theme.of(context)
                                        .textTheme
                                      .display1
                                      .copyWith(fontSize: 20)
                                      ),

//                                      Text(user_list[index].Email),
                                    ],
                                  ),

                                ))

                              ],
                            ),
                          ),
                        );
                      }
                  )
              )
            ]
        )
    );
  }
}