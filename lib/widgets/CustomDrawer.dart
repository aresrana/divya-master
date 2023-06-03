import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  IconData icon;
  String text;
  Function GoTap;

  CustomDrawer(this.icon, this.text, this.GoTap);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
        child: Container(
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey))),
            child: InkWell(
                splashColor: Colors.yellow,
                //onTap: GoTap,
                child: Container(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(icon),
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                text,
                                style: TextStyle(fontSize: 16.0),
                              ))
                        ],
                      ),
                      Icon(Icons.arrow_right)
                    ],
                  ),
                ))));
  }
}
