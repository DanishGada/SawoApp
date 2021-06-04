import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sawo/Models/User.dart';
import 'encrypt.dart';
import 'package:flutter_string_encryption/flutter_string_encryption.dart';
class Ocr_read extends StatefulWidget {
  User cur_user;
  Ocr_read({this.cur_user});
  @override
  _Ocr_readState createState() => _Ocr_readState(cur_user:cur_user);
}

class _Ocr_readState extends State<Ocr_read> {
  User cur_user;
  _Ocr_readState({this.cur_user});
  @override
  bool isInitialized =false;
  void initState() {
    super.initState();
    FlutterMobileVision.start().then((x) => setState(() {}));
  }
  File global_image = null;
  _saveDoc(BuildContext context) async{
    File image = await ImagePicker.pickImage(source: ImageSource.camera,maxHeight: 680 , maxWidth: 970.0);
    this.setState(() async{
      global_image = image;
    }
    );
  }
//  _encrypt(String x)async{
//    return await Encrypt(x);
//  }


  _StartScan() async {
    List<OcrText> texts = [];
    try {
      texts = await FlutterMobileVision.read(
        flash: false,
        autoFocus: true,
        multiple: true,
        showText: true,
        fps: 0.025,
        waitTap:  true,
      );
    }catch(e)
    {
      texts.add(new OcrText('Failed to recognize text.'));
    }

    List<String> name = ['@'];
    var gender = '@';
    var dob = '@';
    List<String> an = ['@'];
    for (OcrText text in texts){
//      print(text.value);
      print(text.value + 'hiiii');

      if (text.value.contains('Male') && gender == '@')
      {
        // print('gender');
        gender = 'Male';
      }
      if (text.value.contains('Female') && gender == '@')
      {
        // print('gender');
        gender = 'Female';
      }
      if (text.value.split('/').length > 2 && dob == '@'){
        // print('dob');
        var a = text.value.split(':');
        dob = a[1];
        // print(dob);
      }
      if (text.value.split(' ').length >= 3){
        // print('somethign');
        var temp = text.value[0];
        if (isNumeric(temp) && an[0] == '@'){
          an = text.value.split(' ').sublist(0, 3);
          // print('an');
        }
        else{
          if (text.value.split(' ')[1] != 'of' && name[0] == '@'){
            print('name');
            name = text.value.split(' ').sublist(0, 3);
          }
        }
      }
      print(name);
      print(an);
      print(dob);
      print(gender);
      String name1 = name.join();

      String an1 = an.join();
      cur_user.data = {'name' : name1 , 'an' : an1 , 'dob' : dob , 'gender' : gender};

      await Firebase.initializeApp();
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
  Widget _decide(){
    if (global_image == null) {
      return Text('No Image');
    }
    else{
      Image.file(global_image,width: 400,height: 400);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Documents'),
      ),

      body: Column(
        children:<Widget> [
          Center(child: const Text('Press the Button to Start Scanning Document')),
//            global_image!='null'? Image.file(global_image,width: 400,height: 400):Text('No Image'),
        ],
      ),
      floatingActionButton: SpeedDial(
        icon :Icons.account_box,
        backgroundColor: Colors.orangeAccent,
        animatedIcon: AnimatedIcons.menu_close,
        children :[
          SpeedDialChild(
            child : Icon(Icons.camera_alt),
            label: 'Ocr Document',
            backgroundColor: Colors.orange,
            onTap: () =>  _StartScan (),
          ),
          SpeedDialChild(
            child : Icon(Icons.save),
            label: 'Save Document',
            backgroundColor: Colors.orange,
            onTap: () => _saveDoc(context),
          ),
        ],
      ),


    );
  }

  bool isNumeric(String s) {
    if(s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }


}