import 'package:fast/modelos.dart';
import 'package:flutter/material.dart';

class NaveEspacial extends CustomPainter {
  double x, y, w, h, angulo;
  Color color;

  NaveEspacial(this.x, this.y, this.w, this.h, this.color, this.angulo);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..style = PaintingStyle.fill;

    Path m = Path();
    m.moveTo(x + w / 2, y-h/3);
    m.lineTo(x, y+h/3);
    m.lineTo(x, y + 2 * h / 3);
    m.lineTo(x + w / 2, y + h/2);
    m.lineTo(x + w, y + 2 * h / 3);
    m.lineTo(x + w, y + h / 3);
    m.close();

    paint.color = color;

    // Guarda la transformación actual del canvas
    canvas.save();

    // Calcula el centro de la nave
    Offset centro = Offset(x + w / 2, y + h / 2);

    // Realiza las transformaciones centradas en el centro de la nave
    canvas.translate(centro.dx, centro.dy);
    canvas.rotate(angulo);
    canvas.translate(-centro.dx, -centro.dy);

    // Dibuja la nave espacial
    canvas.drawPath(m, paint);

    // Restaura la transformación original del canvas
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class Proyectil extends CustomPainter{
  List<ModeloProyectil> vProyectil;

  Proyectil(this.vProyectil);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();

    vProyectil.forEach((element) {
      paint.color =element.color;
      paint.style = PaintingStyle.fill;
      canvas.drawCircle(Offset(element.x, element.y), element.radio, paint);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}



