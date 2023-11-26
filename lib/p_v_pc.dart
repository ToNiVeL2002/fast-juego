import 'dart:async';
import 'dart:math';

import 'package:fast/modelos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'formas.dart'; 

import 'package:soundpool/soundpool.dart';

class PvPCScreen extends StatefulWidget {
  
  const PvPCScreen({Key? key}) : super(key: key);

  @override
  State<PvPCScreen> createState() => _PvPCScreenState();
}

class _PvPCScreenState extends State<PvPCScreen> {
  double x = -50, y = 0, w = 60, h = 80, angulo = 0, radio = 100;
  double x2 = 50, y2 = 0, w2 = 60, h2 = 80, angulo2 = pi, radio2 = 100;
  bool _disposed = false;
  int dirNave = 1, modRand = 7;

  int n1=0, n2=0;

  bool flagCambio = true, flagCambio2 = true;
  List<ModeloProyectil> vProyectil = [];
  
  var screen;
  var gRand = Random();

  @override
  void initState() {
    hilo();
  }

  Future hilo() async {
    Completer c = Completer();
    Timer(const Duration(milliseconds: 70), () {
      c.complete(mover());
    });

  }

  void detectarColision(double x, double y, String a) {
    double radioNave = 27; // Radio de la nave

    for (int i = 0; i < vProyectil.length; i++) {
      double radioProyectil = vProyectil[i].radio; // Radio del proyectil
      double xNave = x+w/2; // Coordenadas x de la nave
      double yNave = y+h/8; // Coordenadas y de la nave

      // Cálculo de las coordenadas x e y para la nave y el proyectil
      double xProyectil = vProyectil[i].x;
      double yProyectil = vProyectil[i].y;

      // Cálculo de la distancia entre la nave y el proyectil
      double distancia = sqrt(pow(xProyectil - xNave, 2) + pow(yProyectil - yNave, 2));

      if (distancia < radioNave + radioProyectil) {
        _soundbutton2();
        // Colisión detectada entre la nave y el proyectil actual
        // print('Colisión detectada entre la nave y el proyectil $a');
        // Puedes manejar la colisión de alguna manera aquí

        if(a =='n1'){
          n1++;
          x=100*gRand.nextDouble();
          vProyectil.clear();
        }else if(a=='n2'){
          n2++;
          x2=100*gRand.nextDouble();
          vProyectil.clear();
        }

        // print('$n1 -- $n2');
      }
    }
  }

  ganador(){
    if(n1>=3){
      Navigator.pushReplacementNamed(context, 'ganador', arguments: 'AZUL');
      n1=0;
      n2=0;
    }
    if(n2>=3){
      Navigator.pushReplacementNamed(context, 'ganador', arguments: 'ROJO');
      n1=0;
      n2=0;
    }
  }

  void detectarColisionesP() {
    for (int i = 0; i < vProyectil.length - 1; i++) {
      for (int j = i + 1; j < vProyectil.length; j++) {
        double distancia = sqrt(pow(vProyectil[j].x - vProyectil[i].x, 2) +
            pow(vProyectil[j].y - vProyectil[i].y, 2));
        double sumaRadios = vProyectil[i].radio + vProyectil[j].radio;

        if (distancia <= sumaRadios) {
          // Colisión detectada, elimina ambos proyectiles
          vProyectil.removeAt(j);
          vProyectil.removeAt(i);
          // Reduces j para considerar el cambio en el índice de la lista
          j--;
        }
      }
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  mover() {
    if(!_disposed){
      setState(() {
        vProyectil.removeWhere((ele) {
          // Restringe el proyectil si se va fuera de la pantalla
          if (ele.x + ele.radio / 2 >= screen.width || ele.x - ele.radio / 2 <= 0) {
            ele.dirX *= -1;
          }
          if (ele.y + ele.radio / 2 >= screen.height || ele.y - ele.radio / 2 <= 0) {
            ele.dirY *= -1;
          }

          ele.x += ele.dirX * 10; // Usa la dirección en el eje X
          ele.y += ele.dirY * 10; // Usa la dirección en el eje Y

          // Elimina el proyectil si toca la parte superior o inferior de la pantalla
          return ele.y - ele.radio / 2 <= 0 || ele.y + ele.radio / 2 >= screen.height;
        });

        // Mueve la nave en el eje X
        x2 += dirNave * 8;
        if(x2%modRand==0){
          double direccionX = cos(angulo2-pi/2); // Dirección x basada en el ángulo
          double direccionY = sin(angulo2-pi/2); // Dirección y basada en el ángulo
          // print('x = $direccionX');
          // print('y = $direccionY');
          vProyectil.add(
            ModeloProyectil(
              x2 + screen.width / 2 + w2 / 14,
              y2 + h2 * 2.5,
              10,
              Colors.lightBlue,
              direccionX, // Asigna la dirección x al proyectil
              direccionY, // Asigna la dirección y al proyectil
            ),
          );
        }

        // Si la nave alcanza el borde derecho o izquierdo, cambia la dirección
        if (x2 >= screen.width/2-w || x2 <=(-screen.width/2)+w) {
          dirNave *= -1;
          
        }

        hilo();
        detectarColision(x + screen.width/2-w/2, y+screen.height-h*1.5, 'n1');
        detectarColision(x2 + screen.width/2-w2/2, y2+h, 'n2');
        detectarColisionesP();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    screen = MediaQuery.of(context).size;

    return Scaffold(
      // backgroundColor: Colors.black,
      body: Stack(

        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/fondoPC.jfif'),
                fit: BoxFit.cover
              )
            ),
          ),
          
          CustomPaint(
            painter: NaveEspacial(x + screen.width/2-w/2, y+screen.height-h*1.5, w, h, Colors.red, angulo),
          ),

          CustomPaint(
            painter: NaveEspacial(x2 + screen.width/2-w2/2, y2+h, w2, h2, Colors.blue, angulo2),
          ),

          CustomPaint(
            painter: Proyectil(vProyectil),
          ),

          // ----------- ARRIVA 
          // DISPARO
          

          // CAMBIO DE ANGULO

          // FLECHAS

          // PUNTUACION
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('A--$n1', style: const TextStyle(color: Colors.white, fontSize: 30),),
                  Text('R--$n2', style: const TextStyle(color: Colors.white, fontSize: 30)),
                ],
              ),
            ),
          ),

          // ------------------ABAJO
          // FLECHAS
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: (){
                      setState(() {
                        ganador();
                        if(flagCambio){
                          if(x>(screen.width/2.5)*-1){
                            x-=5;
                            // print('x==-    $x angulo+ ==$angulo');
                            // print(screen.width/1.5);
                          }
                        }else{
                          if(angulo>-1.2){
                          angulo-=0.3;
                          }
                        }
                      });
                    }, 
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white,)
                  ),
                  IconButton(
                    onPressed: (){
                      setState(() {
                        ganador();
                        if(flagCambio){
                          if(x<screen.width/2.5){
                            x+=5;
                            // print('x==+   $x angulo- ==$angulo');
                          }
                        }else{
                          if(angulo<1.5){
                            angulo+=0.3;
                          }
                        }
                      });
                    }, 
                    icon: const Icon(Icons.arrow_forward_ios, color: Colors.white,)
                  ),
                ],
              ),
            ),
          ),

          // DISPARO
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: IconButton(
                    onPressed: () {
                      ganador();
                      _soundbutton();
                      // print(angulo);
                      double direccionX = cos(angulo-pi/2); // Dirección x basada en el ángulo
                      double direccionY = sin(angulo-pi/2); // Dirección y basada en el ángulo
                      // print('x = $direccionX');
                      // print('y = $direccionY');
                      vProyectil.add(
                        ModeloProyectil(
                          x + screen.width / 2 + w / 14,
                          y + screen.height - h * 2,
                          10,
                          Colors.pinkAccent,
                          direccionX, // Asigna la dirección x al proyectil
                          direccionY, // Asigna la dirección y al proyectil
                        ),
                      );
                      modRand = gRand.nextInt(40)+7;
                    },
                    icon: const Icon(Icons.wifi_tethering_rounded, color: Colors.white,)
                  )
            ),
          ),

          // CAMBIO DE ANGULO
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom:8, right: 50),
              child: IconButton(
                onPressed: (){
                  setState(() {
                    flagCambio = !flagCambio;
                  });
                }, 
                icon: const Icon(Icons.change_circle_outlined, color: Colors.white,)
              )
            ),
          ),
        ],
      ),
    );
  }
  
  Future<void> _soundbutton() async {
    Soundpool pool = Soundpool(streamType: StreamType.notification);

    int soundId = await rootBundle.load("assets/soundFX/disparo.mp3").then((ByteData soundData) {
                  return pool.load(soundData);
                });
    int streamId = await pool.play(soundId);
    
  }

  Future<void> _soundbutton2() async {
    Soundpool pool = Soundpool(streamType: StreamType.notification);

    int soundId = await rootBundle.load("assets/soundFX/mario-bros-die.mp3").then((ByteData soundData) {
                  return pool.load(soundData);
                });
    int streamId = await pool.play(soundId);
    
  }
  
}

