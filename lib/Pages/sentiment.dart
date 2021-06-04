import 'dart:convert';

import 'package:flutter/material.dart';
import 'sentiment_response.dart';

import 'package:http/http.dart' as http;
class sentiment extends StatefulWidget {
  @override
  _sentimentState createState() => _sentimentState();
}
class Value {
  final String title;
  Value({this.title});
  factory Value.fromJson(Map<String, dynamic> json) {
    print(json['Value']);
    String p = '${json['Value']}';
    return Value( title : p);
  }
}
class _sentimentState extends State<sentiment> {

  Future<Value> fetchAlbum(String x) async {
    x= 'http://3c63a7994083.ngrok.io/' + x;
    final response = await http.get(x);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(Value.fromJson(jsonDecode(response.body)));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
  String ans ='';


  fun()async {
    myController.text;
    Value futureAlbum =  await fetchAlbum('${myController.text}');
    ans = (futureAlbum.title);
  }
  final myController = TextEditingController();

  bool _loading= true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
  appBar:AppBar(
    title: Text('Add Friend'),
    actions: [
      Icon(Icons.add_alarm),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),),
    ],

  ),

      body : Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops : [0.004,1],
            colors : [
              Colors.orange,
              Colors.deepOrange,
            ]
          )
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24 ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height/6,),
              Text('Sentimental Analysis',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 28,
              ),
              ),
              SizedBox(height: 10,),
              Container(
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                    color : Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7
                      )
                    ]
                ),
                child: Column(
                  children: [
                    Container(
                      child: Center(
                        child : _loading ? Container(width: 300,child: Column(children: [
                          TextField(
                            controller: myController,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: Colors.black,fontSize: 21),
                              labelText: 'Enter a Search term' ,
                            ),
                          ),
                          SizedBox(height: 30,),
                         Container(width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: ()async{
                                  await fun();
                                  setState(() {
                                    _loading = false;
                                  });
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width-100,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(horizontal: 24 , vertical:  17),
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text('Find Emotions',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18
                                  ),
                                  ),
                                ),
                              )
                            ],
                          ),
                         )
                        ]
                        )
                        ):Container(child : Text('${ans}'))
                      )
                    )

                  ],
                ),
              )
            ],
          ),
        ),
      ),

    );
  }
}
