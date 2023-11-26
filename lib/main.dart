import 'package:fast/ganador.dart';
import 'package:fast/home.dart';
import 'package:fast/p_v_p_C.dart';
import 'package:fast/p_vs_pc_C.dart';
import 'package:fast/p_vs_pc_C2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      // systemNavigationBarColor: Colors.red
      // systemNavigationBarDividerColor: Colors.blue
      statusBarColor: Color.fromARGB(5, 20, 25, 0)
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'home',
      routes: {
        'home': ( _ ) => HomeScreen(),
        'pvpC': ( _ ) => PvPControlerScreen(),
        'pvpc': ( _ ) => PvPCControlerScreen(),
        'pvpc2': ( _ ) => PvPCC2ontrolerScreen(),
        'ganador': ( _ ) => GanadorScreen()
      },
    );
  }
}