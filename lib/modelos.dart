import 'package:flutter/material.dart';

class ModeloProyectil{

  double x, y, radio,dirX, dirY;
  Color color;
  int dirHorizontal = 1;
  int dirVertical = 1;

  ModeloProyectil( this.x, this.y, this.radio, this.color, this.dirX, this.dirY );
}


// class ModeloProyectil {
//   double x, y, radio, dirX, dirY; // Añade dirX y dirY para la dirección
//   Color color;
//   // Otras propiedades

//   ModeloProyectil(
//     this.x,
//     this.y,
//     this.radio,
//     this.color,
//     this.dirX, // Dirección en el eje X
//     this.dirY, // Dirección en el eje Y
//   );
// }



