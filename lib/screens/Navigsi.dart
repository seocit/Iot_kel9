import 'package:flutter/material.dart';

import 'package:sensor/screens/home_screen.dart';

class ResponsiveNavBarPage extends StatelessWidget {
  ResponsiveNavBarPage({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
   
    

    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleSpacing: 0,
         
          title: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Water Level",
                  style: TextStyle(
                      color: Color.fromARGB(255, 127, 215, 235), fontWeight: FontWeight.bold),
                ),
                
              ],
            ),
          ),
          
        ),
        
        body: Center(
          child: ElevatedButton(onPressed: () {
            
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
          
           child: const Text(
            "Pantau Air",
             style: TextStyle(color: Color.fromARGB(255, 255 , 255, 255)) ,               ))
        ),
      ),
    );
  }


  
}






