import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized( );


  await Firebase.initializeApp();


  runApp( BlackScreen());
}

class BlackScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        //fromRGBO(18, 18, 18, 1),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                  child: Image.asset('images/divya.png',

                    height: MediaQuery.of(context).size.height*0.1 ,
                  width:MediaQuery.of(context).size.width*0.15

                  )),
          Text(
            'Divya Shravya',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        Container(
          height: MediaQuery.of(context).size.height*0.05,
          width: MediaQuery.of(context).size.width*0.95,
          child: ElevatedButton(
            onPressed: () {
              // Button on pressed action
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0), // Adjust the radius as needed
              ),
            ),
            child: Text('Sign Up with Email'),
          ),
        )
        ]
        ),
      ),
    );
  }
}




