import 'package:fast/controlador.dart';
import 'package:fast/formas.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PvPControlerScreen extends StatelessWidget {
  
  final Controller controller = Get.put(Controller());
  
  PvPControlerScreen({Key? key}) : super(key: key);

  var screen;
  
  @override
  Widget build(BuildContext context) {

    ganador(){
      if(controller.n1>=3){
        Navigator.pushReplacementNamed(context, 'ganador', arguments: 'AZUL');
        controller.n1.value=0;
        controller.n2.value=0;
      }
      if(controller.n2.value>=3){
        Navigator.pushReplacementNamed(context, 'ganador', arguments: 'ROJO');
        controller.n1.value=0;
        controller.n2.value=0;
      }
    }
    
    screen = MediaQuery.of(context).size;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints){
          controller.updateScreenSize(constraints.maxWidth, constraints.maxHeight);

          return Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/fondoWar.jfif'),
                    fit: BoxFit.cover
                  )
                ),
              ),
              
              Obx(() => CustomPaint(
                painter: NaveEspacial(controller.x.value + screen.width / 2 - controller.w.value / 2,
                      controller.y.value + screen.height - controller.h.value * 1.5,
                      controller.w.value, controller.h.value, Colors.red, controller.angulo.value),
              ),),

              Obx(() => CustomPaint(
                painter: NaveEspacial((controller.x2.value*-1) + screen.width / 2 - controller.w2.value / 2,
                      controller.y2.value + controller.h2.value,
                      controller.w2.value, controller.h2.value, Colors.blue, controller.angulo2.value),
              ),),

              Obx(() {
                if (controller.vProyectil.isNotEmpty) {
                  return CustomPaint(
                    painter: Proyectil(controller.vProyectil),
                  );
                } else {
                  return Container();
                }
              }),
              
              // ----------- ARRIVA 
              // DISPARO
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top:60, left: 8),
                  child: IconButton(
                    onPressed: () {
                      controller.disparoNave2();
                      ganador();
                    },
                    icon: const Icon(Icons.wifi_tethering_rounded, color: Colors.white,)
                  )
                ),
              ),

              // CAMBIO DE ANGULO
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top:60, left: 50),
                  child: IconButton(
                    onPressed: (){
                      controller.cambioAnguloNave2();
                    }, 
                    icon: const Icon(Icons.change_circle_outlined, color: Colors.white,)
                  )
                ),
              ),

              // FLECHAS
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          controller.moverIzquierdaNave2(screen.width);
                          ganador();
                        },
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.white,),
                      ),
                      IconButton(
                        onPressed: () {
                          controller.moverDerechaNave2(screen.width);
                          ganador();
                        },
                        icon: const Icon(Icons.arrow_forward_ios, color: Colors.white,),
                      ),
                    ],
                  ),
                ),
              ),

              // PUNTUACION
              Obx(() => Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('A--${controller.n1.value}', style: const TextStyle(color: Colors.white, fontSize: 30),),
                      Text('R--${controller.n2.value}', style: const TextStyle(color: Colors.white, fontSize: 30)),
                    ],
                  ),
                ),
              ),),

              // ------------------ABAJO -----------------------------------------------------------
              // FLECHAS
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 8),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: (){
                          controller.moverIzquierdaNave1(screen.width);
                          ganador();
                        }, 
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.white,)
                      ),
                      IconButton(
                        onPressed: (){
                          controller.moverDerechaNave1(screen.width);
                          ganador();
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
                      controller.disparoNave1();
                      ganador();
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
                      controller.cambioAnguloNave1();
                    }, 
                    icon: const Icon(Icons.change_circle_outlined, color: Colors.white,)
                  )
                ),
              ),
            ],
          );
        }
      )
    );
  }
}