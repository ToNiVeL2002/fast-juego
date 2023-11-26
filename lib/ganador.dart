import 'package:flutter/material.dart';

class GanadorScreen extends StatelessWidget {
  
  const GanadorScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final datos = ModalRoute.of(context)!.settings.arguments as String;
    return  Scaffold(
      backgroundColor: Color(0xff2E305F),
      body: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('GANADOR $datos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50, color: Colors.pinkAccent),),

            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(62, 66, 107, 0.7)),
                textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(fontSize: 80, fontWeight: FontWeight.bold,) )
              ),
              onPressed: (){
                Navigator.pushReplacementNamed(context, 'pvpC');
              }, 
              child: Text('1 VS 1', style: TextStyle(color: Colors.pink),)
            ),

            SizedBox(height: 20,),

            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(62, 66, 107, 0.7)),
                textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(fontSize: 70, fontWeight: FontWeight.bold,) )
              ),
              onPressed: (){
                Navigator.pushReplacementNamed(context, 'pvpc');
              }, 
              child: Text('1 VS PC1', style: TextStyle(color: Colors.pink))
            ),

            SizedBox(height: 20,),

            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(62, 66, 107, 0.7)),
                textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(fontSize: 70, fontWeight: FontWeight.bold,) )
              ),
              onPressed: (){
                Navigator.pushReplacementNamed(context, 'pvpc2');
              }, 
              child: Text('1 VS PC2', style: TextStyle(color: Colors.pink))
            ),

            SizedBox(height: 20,),

            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(62, 66, 107, 0.7)),
                textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(fontSize: 70, fontWeight: FontWeight.bold,) )
              ),
              onPressed: (){
                Navigator.pushReplacementNamed(context, 'home');
              }, 
              child: Text('Home', style: TextStyle(color: Colors.pink))
            ),
          ],
        ),
      ),
    );
  }
}