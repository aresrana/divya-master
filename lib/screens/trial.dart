
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth.dart';
import '../widgets/CustomDrawer.dart';


class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();

  }

  TextEditingController _getVin = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white60,
        endDrawerEnableOpenDragGesture: false,
        appBar: AppBar(
          backgroundColor: Colors.green,

          title: Container(
            margin: EdgeInsets.symmetric(horizontal: 10,vertical: 12),
            decoration: BoxDecoration(
              color:  Color.fromARGB(50, 255,255, 255),
              borderRadius: BorderRadius.all(Radius.circular(22.0)),

            ),


            child: Row (
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child : Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: TextFormField (

                          controller: _getVin,
                          decoration: InputDecoration (
                              border:  InputBorder.none,
                              hintText: "Search",
                              hintStyle: TextStyle(color: Colors.white),
                              icon:Icon (Icons.search,color: Colors.white,)
                          ),

                        )
                    )

                ),
                Expanded (

                    flex: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            onPressed: (){
                              _getVin.clear();
                              //CSD.buildActions(context);
                            },
                            icon: Icon(Icons.clear,color:Colors.white),
                          )
                        ],
                      ),
                    )
                ),
                IconButton(onPressed: signOut, icon: Icon(Icons.person))


              ],
            ),
          ),

          //Text(
          // 'Praise The Lord',
          //  style: TextStyle(color: Colors.yellow),
          //   ),
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.yellow,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),

          // actions: [
          //
          //   IconButton(
          //     icon: Icon(Icons.youtube_searched_for, color: Colors.yellow),
          //     onPressed: () {
          //       showSearch(
          //         context: context,
          //         delegate: CustomSearchDelegate()
          //       );
          //
          //
          //
          //     },
          //   )
          // ],
        ),
        body: Container(
            child: Text("Aresrana")

        )  ,
        drawer: Container(
          color: Colors.blueGrey,
            width: MediaQuery.of(context).size.width*0.45,
            child: Drawer(

                child: ListView(children: <Widget>[
                  DrawerHeader(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: <Color>[Colors.yellow, Colors.green]),
                        // image:DecorationImage(
                        //   fit:BoxFit.fill,
                        //   image:AssetImage('images/launch_image.png')
                        // )
                      ),
                      child: Container(

                        child: Column(
                          children: <Widget>[
                            Material(
                                borderRadius: BorderRadius.all(Radius.circular(50.0)),
                                child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Image.asset('images/launch_image.png',
                                        height: 80, width: 80))),
                            Padding(
                                padding: EdgeInsets.all(5),
                                child: Text('AutoMedis',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)))
                          ],
                        ),
                      )),
                  CustomDrawer(Icons.favorite, 'Favorite', () => {}),
                  CustomDrawer(Icons.share, 'Share', () => {}),
                  CustomDrawer(Icons.settings, 'Settings', () => {}),
                  CustomDrawer(Icons.star, 'Rate', () => {}),
                  CustomDrawer(Icons.arrow_left, 'Back', () => {} // Get.back()
                      ),
                ]))));
  }
}

