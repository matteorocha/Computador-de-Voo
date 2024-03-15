import 'package:flutter/material.dart';
import 'calculator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Computador de voo',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyWheelApp(),
    );
  }
}

class MyWheelApp extends StatefulWidget {
  @override
  _MyWheelAppState createState() => _MyWheelAppState();
}

class _MyWheelAppState extends State<MyWheelApp> {
  double angle = 0.0;
  double scale = 1.0;
  Offset? lastPosition;
  /* 
  String getAngleText() {
  return 'Ângulo: ${angle.toStringAsFixed(2)} graus';
  }
  */
  void showMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Mensagem"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('Fechar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double largura = size.width;
    double altura = size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Modelo Régua'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                //* Ajustar a dimensão das iamgens da régua
                Center(
                  child: InteractiveViewer(
                    boundaryMargin: EdgeInsets.all(400),
                    minScale: 0.5,
                    maxScale: 4.5,
                    child: GestureDetector(
                      onScaleUpdate: (details) {
                        if (lastPosition != null) {
                          final Offset centerOfGestureDetector = Offset(
                              424 / 2,
                              424 /
                                  2); //* Calcula a posição inicial do gesto em relação ao centro.
                          final Offset startPosition = lastPosition! -
                              centerOfGestureDetector; // * Obtém-se o ângulo da posição inicial em relação a x positivo.
                          final Offset currentPosition = details
                                  .localFocalPoint -
                              centerOfGestureDetector; // * Obtém-se o ângulo da posição central em relação a x positivo.

                          final startAngle = startPosition.direction;
                          final currentAngle = currentPosition.direction;

                          setState(() {
                            angle += currentAngle -
                                startAngle; //* Nesta parte ela atualiza o ângulo de rotação com base na diferença entre o ângulo inicial e o ângulo final.
                            scale = details.scale;
                          });
                        }
                        lastPosition = details.localFocalPoint;
                      },
                      onScaleEnd: (details) {
                        lastPosition = null;
                      },
                      // * Lado A
                      // * Aplicação do Zoom (Imagem fixa e Independente)
                      child: Transform.scale(
                        scale: scale,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 500,
                              height: 500,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      "assets/CDV1.png"), //* Aqui removi a escala circular e agora aparece em partes a imagem preta.
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            //* Lado B
                            Transform.rotate(
                              angle: angle,
                              child: Container(
                                width: 424,
                                height: 424,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: AssetImage("assets/CDV.png"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
