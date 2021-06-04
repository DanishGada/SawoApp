import 'package:flutter/material.dart';
class CustomListTile extends StatelessWidget {
  IconData icon;
  String text;
  Function ontap;
  CustomListTile(this.icon,this.text,this.ontap);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0,0,8.0,0),
      child: InkWell(
          onTap: ontap,
          splashColor: Colors.orangeAccent,
          child: Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Row(
                  children: [
                    Icon(icon),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("$text",style: TextStyle(
                          fontSize: 18.0
                      ),
                      ),
                    ),

                  ],
                ),
                Icon(Icons.arrow_forward),
              ],
            ),
          )

      ),
    );
  }

}

