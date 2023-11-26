import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  
  const HomeScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2E305F),
      appBar: AppBar(
        title: const Text('FAST', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),),
        backgroundColor: const Color(0xff202333),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TextButton(
            //   style: ButtonStyle(
            //     backgroundColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(62, 66, 107, 0.7)),
            //     textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(fontSize: 80, fontWeight: FontWeight.bold,) )
            //   ),
            //   onPressed: (){
            //     Navigator.pushNamed(context, 'pvp');
            //   }, 
            //   child: const Text('1 VS 1', style: TextStyle(color: Colors.pink),)
            // ),

            // const SizedBox(height: 20,),

            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(62, 66, 107, 0.7)),
                textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(fontSize: 80, fontWeight: FontWeight.bold,) )
              ),
              onPressed: (){
                Navigator.pushNamed(context, 'pvpC');
              }, 
              child: const Text('1 VS 1C', style: TextStyle(color: Colors.pink),)
            ),

            const SizedBox(height: 20,),

            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(62, 66, 107, 0.7)),
                textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(fontSize: 70, fontWeight: FontWeight.bold,) )
              ),
              onPressed: (){
                Navigator.pushNamed(context, 'pvpc');
              }, 
              child: const Text('1 VS PC 1', style: TextStyle(color: Colors.pink))
            ),

            const SizedBox(height: 20,),

            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(62, 66, 107, 0.7)),
                textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(fontSize: 70, fontWeight: FontWeight.bold,) )
              ),
              onPressed: (){
                Navigator.pushNamed(context, 'pvpc2');
              }, 
              child: const Text('1 VS PC 2', style: TextStyle(color: Colors.pink))
            ),
          ],
        ),
      ),
    );
  }
}