import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:fast/modelos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:soundpool/soundpool.dart';

class Controller extends GetxController {
  var x = 50.0.obs;
  var y = 0.0.obs;
  var w = 60.0.obs;
  var h = 80.0.obs;
  var angulo = 0.0.obs;
  var radio = 100.0.obs;

  var x2 = 50.0.obs;
  var y2 = 0.0.obs;
  var w2 = 60.0.obs;
  var h2 = 80.0.obs;
  var angulo2 = 3.14.obs;
  var radio2 = 100.0.obs;

  var n1 = 0.obs;
  var n2 = 0.obs;

  var flagCambio = true.obs;
  var flagCambio2 = true.obs;

  var vProyectil = <ModeloProyectil>[].obs;
  
  var updateIndicator = 0.obs;

  bool _disposed = false;
  var gRand = Random();

  var screenSizeW = 0.0.obs;
  var screenSizeH = 0.0.obs;

  int dirNave = 1, modRand = 7;

  void updateScreenSize(double sizeW, double sizeH) {
    screenSizeW.value = sizeW;
    screenSizeH.value = sizeH;
  }

  // -------------------------------------------------------------

  void iniciarHilo() {
    Timer.periodic(const Duration(milliseconds: 70), (Timer timer) {
      if (_disposed) {
        timer.cancel();
      } else {
        mover();
      }
    });
  }

  void detectarColision(double x, double y, String a) {
    double radioNave = 27; // Radio de la nave

    for (int i = 0; i < vProyectil.length; i++) {
      double radioProyectil = vProyectil[i].radio; // Radio del proyectil
      double xNave = x + w / 2; // Coordenadas x de la nave
      double yNave = y + h / 8; // Coordenadas y de la nave

      // Cálculo de las coordenadas x e y para la nave y el proyectil
      double xProyectil = vProyectil[i].x;
      double yProyectil = vProyectil[i].y;

      // Cálculo de la distancia entre la nave y el proyectil
      double distancia = sqrt(pow(xProyectil - xNave, 2) + pow(yProyectil - yNave, 2));

      if (distancia < radioNave + radioProyectil) {
        _soundbutton2();
        if (a == 'n1') {
          n1++;
          this.x.value = 100 * gRand.nextDouble();
          vProyectil.clear();
        } else if (a == 'n2') {
          n2++;
          x2.value = 100 * gRand.nextDouble();
          vProyectil.clear();
        }
      }
    }
  }

  void detectarColisionesP() {
    for (int i = 0; i < vProyectil.length - 1; i++) {
      for (int j = i + 1; j < vProyectil.length; j++) {
        double distancia = sqrt(pow(vProyectil[j].x - vProyectil[i].x, 2) +
            pow(vProyectil[j].y - vProyectil[i].y, 2));
        double sumaRadios = vProyectil[i].radio + vProyectil[j].radio;

        if (distancia <= sumaRadios) {
          vProyectil.removeAt(j);
          vProyectil.removeAt(i);
          j--;
        }
      }
    }
  }

  void mover() {
    vProyectil.removeWhere((ele) {
      if (ele.x + ele.radio / 2 >= screenSizeW.value ||
          ele.x - ele.radio / 2 <= 0) {
        ele.dirX *= -1;
      }
      if (ele.y + ele.radio / 2 >= screenSizeH.value ||
          ele.y - ele.radio / 2 <= 0) {
        ele.dirY *= -1;
      }

      ele.x += ele.dirX * 10;
      ele.y += ele.dirY * 10;

      return ele.y - ele.radio / 2 <= 0 || ele.y + ele.radio / 2 >= screenSizeH.value;
    });

    detectarColision(x.value + screenSizeW.value / 2 - w.value / 2, y.value + screenSizeH.value - h.value * 1.5, 'n1');
    detectarColision((x2.value*-1) + screenSizeW.value / 2 - w2.value / 2, y2.value + h2.value, 'n2');
    detectarColisionesP();
  }

  @override
  void onInit() {
    iniciarHilo();
    super.onInit();
  }

  @override
  void onClose() {
    _disposed = true;
    super.onClose();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
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



  //-------------------------------------------------------------
  void moverIzquierdaNave1(double screen){
    if(flagCambio.value){
      if(x>(screen/2.5)*-1){
        x.value-=5;
      }
    }else{
      if(angulo.value>-1.2){
      angulo.value-=0.3;
      }
    }
  }

  void moverDerechaNave1(double screen){
    if(flagCambio.value){
      if(x<screen/2.5){
        x.value+=5;
        // print('x==+   $x angulo- ==$angulo');
      }
    }else{
      if(angulo<1.5){
        angulo.value+=0.3;
      }
    }
  }

  void cambioAnguloNave1(){
    flagCambio.value = !flagCambio.value;
  }

  void moverDerechaNave2(double screen){
    if (flagCambio2.value) {
      if (x2.value > (screen / 2.5) * -1) {
        x2.value -= 5;
      }
    } else {
      if (angulo2.value > 2) {
        angulo2.value -= 0.3;
      }
    }
  }

  void moverIzquierdaNave2(double screen){
    if (flagCambio2.value) {
      if (x2.value < screen / 2.5) {
        x2.value += 5;
      }
    } else {
      if (angulo2.value < 4.3) {
        angulo2.value += 0.3;
      }
    }
  }

  void cambioAnguloNave2(){
    flagCambio2.value = !flagCambio2.value;
  }

  void disparoNave1(){
    _soundbutton();
    double direccionX = cos(angulo.value-pi/2); // Dirección x basada en el ángulo
    double direccionY = sin(angulo.value-pi/2); // Dirección y basada en el ángulo
    
    vProyectil.add(
      ModeloProyectil(
        x.value + screenSizeW.value / 2 + w.value / 14,
        y.value + screenSizeH.value - h.value * 2,
        10,
        Colors.pinkAccent,
        direccionX, // Asigna la dirección x al proyectil
        direccionY, // Asigna la dirección y al proyectil
      ),
    );
    vProyectil.refresh();
  }

  void disparoNave2(){
    _soundbutton();
    double direccionX = cos(angulo2.value-pi/2); // Dirección x basada en el ángulo
    double direccionY = sin(angulo2.value-pi/2); // Dirección y basada en el ángulo
    vProyectil.add(
      ModeloProyectil(
        (x2.value*-1) + screenSizeW / 2 + w2 / 14,
        y2.value + h2.value * 2.5,
        10,
        Colors.lightBlue,
        direccionX, // Asigna la dirección x al proyectil
        direccionY, // Asigna la dirección y al proyectil
      ),
    );
    vProyectil.refresh();
  }
}

// ---------------------------
class Controller2 extends GetxController {
  var x = 50.0.obs;
  var y = 0.0.obs;
  var w = 60.0.obs;
  var h = 80.0.obs;
  var angulo = 0.0.obs;
  var radio = 100.0.obs;

  var x2 = 50.0.obs;
  var y2 = 0.0.obs;
  var w2 = 60.0.obs;
  var h2 = 80.0.obs;
  var angulo2 = 3.14.obs;
  var radio2 = 100.0.obs;

  var n1 = 0.obs;
  var n2 = 0.obs;

  var flagCambio = true.obs;
  var flagCambio2 = true.obs;

  var vProyectil = <ModeloProyectil>[].obs;
  
  var updateIndicator = 0.obs;

  bool _disposed2 = false;
  var gRand = Random();

  var screenSizeW = 0.0.obs;
  var screenSizeH = 0.0.obs;

  int dirNave = 1, modRand = 7;

  void updateScreenSize(double sizeW, double sizeH) {
    screenSizeW.value = sizeW;
    screenSizeH.value = sizeH;
  }

  // -------------------------------------------------------------

  void iniciarHilo() {
    Timer.periodic(const Duration(milliseconds: 70), (Timer timer) {
      if (_disposed2) {
        timer.cancel();
      } else {
        moverPC1();
      }
    });
  }

  void detectarColision(double x, double y, String a) {
    double radioNave = 27; // Radio de la nave

    for (int i = 0; i < vProyectil.length; i++) {
      double radioProyectil = vProyectil[i].radio; // Radio del proyectil
      double xNave = x + w / 2; // Coordenadas x de la nave
      double yNave = y + h / 8; // Coordenadas y de la nave

      // Cálculo de las coordenadas x e y para la nave y el proyectil
      double xProyectil = vProyectil[i].x;
      double yProyectil = vProyectil[i].y;

      // Cálculo de la distancia entre la nave y el proyectil
      double distancia = sqrt(pow(xProyectil - xNave, 2) + pow(yProyectil - yNave, 2));

      if (distancia < radioNave + radioProyectil) {
        _soundbutton2();
        if (a == 'n1') {
          n1++;
          this.x.value = 100 * gRand.nextDouble();
          vProyectil.clear();
        } else if (a == 'n2') {
          n2++;
          x2.value = 100 * gRand.nextDouble();
          vProyectil.clear();
        }
      }
    }
  }

  void detectarColisionesP() {
    for (int i = 0; i < vProyectil.length - 1; i++) {
      for (int j = i + 1; j < vProyectil.length; j++) {
        double distancia = sqrt(pow(vProyectil[j].x - vProyectil[i].x, 2) +
            pow(vProyectil[j].y - vProyectil[i].y, 2));
        double sumaRadios = vProyectil[i].radio + vProyectil[j].radio;

        if (distancia <= sumaRadios) {
          vProyectil.removeAt(j);
          vProyectil.removeAt(i);
          j--;
        }
      }
    }
  }

  void moverPC1() {
    vProyectil.removeWhere((ele) {
      if (ele.x + ele.radio / 2 >= screenSizeW.value ||
          ele.x - ele.radio / 2 <= 0) {
        ele.dirX *= -1;
      }
      if (ele.y + ele.radio / 2 >= screenSizeH.value ||
          ele.y - ele.radio / 2 <= 0) {
        ele.dirY *= -1;
      }

      ele.x += ele.dirX * 10;
      ele.y += ele.dirY * 10;

      return ele.y - ele.radio / 2 <= 0 || ele.y + ele.radio / 2 >= screenSizeH.value;
    });

    detectarColision(x.value + screenSizeW.value / 2 - w.value / 2, y.value + screenSizeH.value - h.value * 1.5, 'n1');
    detectarColision((x2.value*-1) + screenSizeW.value / 2 - w2.value / 2, y2.value + h2.value, 'n2');
    detectarColisionesP();

    // ------- para la nave
    // Mueve la nave en el eje X
    x2.value += dirNave * 8;

    if(x2.value%modRand==0){
      double direccionX = cos(angulo2.value-pi/2); // Dirección x basada en el ángulo
      double direccionY = sin(angulo2.value-pi/2); // Dirección y basada en el ángulo
      vProyectil.add(
        ModeloProyectil(
          (x2.value*-1) + screenSizeW / 2 + w2 / 14,
          y2.value + h2.value * 2.5,
          10,
          Colors.lightBlue,
          direccionX, // Asigna la dirección x al proyectil
          direccionY, // Asigna la dirección y al proyectil
        ),
      );
    }

    // Si la nave alcanza el borde derecho o izquierdo, cambia la dirección
    if (x2 >= screenSizeW/2-w.value || x2 <=(-screenSizeW/2)+w.value) {
      dirNave *= -1;
    }
  }

  @override
  void onInit() {
    iniciarHilo();
    super.onInit();
  }

  @override
  void onClose() {
    _disposed2 = true;
    super.onClose();
  }

  @override
  void dispose() {
    _disposed2 = true;
    super.dispose();
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



  //-------------------------------------------------------------
  void moverIzquierdaNave1(double screen){
    if(flagCambio.value){
      if(x>(screen/2.5)*-1){
        x.value-=5;
      }
    }else{
      if(angulo.value>-1.2){
      angulo.value-=0.3;
      }
    }
  }

  void moverDerechaNave1(double screen){
    if(flagCambio.value){
      if(x<screen/2.5){
        x.value+=5;
        // print('x==+   $x angulo- ==$angulo');
      }
    }else{
      if(angulo<1.5){
        angulo.value+=0.3;
      }
    }
  }

  void cambioAnguloNave1(){
    flagCambio.value = !flagCambio.value;
  }

  void disparoNave1(){
    // _soundbutton();
    double direccionX = cos(angulo.value-pi/2); // Dirección x basada en el ángulo
    double direccionY = sin(angulo.value-pi/2); // Dirección y basada en el ángulo
    
    vProyectil.add(
      ModeloProyectil(
        x.value + screenSizeW.value / 2 + w.value / 14,
        y.value + screenSizeH.value - h.value * 2,
        10,
        Colors.pinkAccent,
        direccionX, // Asigna la dirección x al proyectil
        direccionY, // Asigna la dirección y al proyectil
      ),
    );
    modRand = gRand.nextInt(20)+6;
    print(modRand);
    vProyectil.refresh();
  }
}


// ---------------------------
class Controller3 extends GetxController {
  var x = 50.0.obs;
  var y = 0.0.obs;
  var w = 60.0.obs;
  var h = 80.0.obs;
  var angulo = 0.0.obs;
  var radio = 100.0.obs;

  var x2 = 50.0.obs;
  var y2 = 0.0.obs;
  var w2 = 60.0.obs;
  var h2 = 80.0.obs;
  var angulo2 = 3.14.obs;
  var radio2 = 100.0.obs;

  var n1 = 0.obs;
  var n2 = 0.obs;

  var flagCambio = true.obs;
  var flagCambio2 = true.obs;

  var vProyectil = <ModeloProyectil>[].obs;
  
  var updateIndicator = 0.obs;

  bool _disposed3 = false;
  var gRand = Random();

  var screenSizeW = 0.0.obs;
  var screenSizeH = 0.0.obs;

  int dirNave = 1, modRand = 7, anguloNave=1;

  void updateScreenSize(double sizeW, double sizeH) {
    screenSizeW.value = sizeW;
    screenSizeH.value = sizeH;
  }

  // -------------------------------------------------------------

  void iniciarHilo() {
    Timer.periodic(const Duration(milliseconds: 70), (Timer timer) {
      if (_disposed3) {
        timer.cancel();
      } else {
        moverPC2();
      }
    });
  }

  void detectarColision(double x, double y, String a) {
    double radioNave = 27; // Radio de la nave

    for (int i = 0; i < vProyectil.length; i++) {
      double radioProyectil = vProyectil[i].radio; // Radio del proyectil
      double xNave = x + w / 2; // Coordenadas x de la nave
      double yNave = y + h / 8; // Coordenadas y de la nave

      // Cálculo de las coordenadas x e y para la nave y el proyectil
      double xProyectil = vProyectil[i].x;
      double yProyectil = vProyectil[i].y;

      // Cálculo de la distancia entre la nave y el proyectil
      double distancia = sqrt(pow(xProyectil - xNave, 2) + pow(yProyectil - yNave, 2));

      if (distancia < radioNave + radioProyectil) {
        _soundbutton2();
        if (a == 'n1') {
          n1++;
          this.x.value = 100 * gRand.nextDouble();
          vProyectil.clear();
        } else if (a == 'n2') {
          n2++;
          x2.value = 100 * gRand.nextDouble();
          vProyectil.clear();
        }
      }
    }
  }

  void detectarColisionesP() {
    for (int i = 0; i < vProyectil.length - 1; i++) {
      for (int j = i + 1; j < vProyectil.length; j++) {
        double distancia = sqrt(pow(vProyectil[j].x - vProyectil[i].x, 2) +
            pow(vProyectil[j].y - vProyectil[i].y, 2));
        double sumaRadios = vProyectil[i].radio + vProyectil[j].radio;

        if (distancia <= sumaRadios) {
          vProyectil.removeAt(j);
          vProyectil.removeAt(i);
          j--;
        }
      }
    }
  }

  void moverPC2() {
    vProyectil.removeWhere((ele) {
      if (ele.x + ele.radio / 2 >= screenSizeW.value ||
          ele.x - ele.radio / 2 <= 0) {
        ele.dirX *= -1;
      }
      if (ele.y + ele.radio / 2 >= screenSizeH.value ||
          ele.y - ele.radio / 2 <= 0) {
        ele.dirY *= -1;
      }

      ele.x += ele.dirX * 10;
      ele.y += ele.dirY * 10;

      return ele.y - ele.radio / 2 <= 0 || ele.y + ele.radio / 2 >= screenSizeH.value;
    });

    detectarColision(x.value + screenSizeW.value / 2 - w.value / 2, y.value + screenSizeH.value - h.value * 1.5, 'n1');
    detectarColision((x2.value*-1) + screenSizeW.value / 2 - w2.value / 2, y2.value + h2.value, 'n2');
    detectarColisionesP();

    // ------- para la nave
    // Mueve la nave en el eje X
    x2.value += dirNave * 8;
    if(x2.value%modRand==0){
      double direccionX = cos(angulo2.value-pi/2); // Dirección x basada en el ángulo
      double direccionY = sin(angulo2.value-pi/2); // Dirección y basada en el ángulo
      vProyectil.add(
        ModeloProyectil(
          (x2.value*-1) + screenSizeW / 2 + w2 / 14,
          y2.value + h2.value * 2.5,
          10,
          Colors.lightBlue,
          direccionX, // Asigna la dirección x al proyectil
          direccionY, // Asigna la dirección y al proyectil
        ),
      );

      // Para cambiar el angulo de la nabe enemiga
        if(angulo2.value>2 && anguloNave==1){
          angulo2.value -= 0.3;
        } else{
          anguloNave = -1;
        }
        if(angulo2.value<4.3 && anguloNave==-1){
          angulo2.value +=0.3;
        }else{
          anguloNave=1;
        }
    }

    // Si la nave alcanza el borde derecho o izquierdo, cambia la dirección
    if (x2 >= screenSizeW/2-w.value || x2 <=(-screenSizeW/2)+w.value) {
      dirNave *= -1;
    }
  }

  @override
  void onInit() {
    iniciarHilo();
    super.onInit();
  }

  @override
  void onClose() {
    _disposed3 = true;
    super.onClose();
  }

  @override
  void dispose() {
    _disposed3 = true;
    super.dispose();
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



  //-------------------------------------------------------------
  void moverIzquierdaNave1(double screen){
    if(flagCambio.value){
      if(x>(screen/2.5)*-1){
        x.value-=5;
      }
    }else{
      if(angulo.value>-1.2){
      angulo.value-=0.3;
      }
    }
  }

  void moverDerechaNave1(double screen){
    if(flagCambio.value){
      if(x<screen/2.5){
        x.value+=5;
        // print('x==+   $x angulo- ==$angulo');
      }
    }else{
      if(angulo<1.5){
        angulo.value+=0.3;
      }
    }
  }

  void cambioAnguloNave1(){
    flagCambio.value = !flagCambio.value;
  }

  void disparoNave1(){
    // _soundbutton();
    double direccionX = cos(angulo.value-pi/2); // Dirección x basada en el ángulo
    double direccionY = sin(angulo.value-pi/2); // Dirección y basada en el ángulo
    
    vProyectil.add(
      ModeloProyectil(
        x.value + screenSizeW.value / 2 + w.value / 14,
        y.value + screenSizeH.value - h.value * 2,
        10,
        Colors.pinkAccent,
        direccionX, // Asigna la dirección x al proyectil
        direccionY, // Asigna la dirección y al proyectil
      ),
    );
    modRand = gRand.nextInt(20)+6;
    print('++++++++--------++++++++-----------+++++++++---------$modRand');
    vProyectil.refresh();
  }
}

