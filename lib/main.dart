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
    return Scaffold(
      appBar: AppBar(
        title: Text('Modelo Régua'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Calculadora()),
                      );
                    },
                    child: Text('Conversões'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showMessage(
                          'Ativar "Prender" tem a função de travar a régua para ajudar na obtenção de resultados, você pode desativá-la ao clicar novamente(isto não afeta o ZOOM).'
                          'Ao utilizar "conversões", você poderá selecionar qual tipo de conversão de unidades da régua irá utilizar, isto irá interagir com a régua e te enviará para o valor convertido');
                    },
                    child: Text('Ajuda'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showMessage('Sistema Preso');
                    },
                    child: Text(
                        'Prender'), // * Aplicar o sistema de prender o zoom
                  ),
                  // ElevatedButton(
                    // onPressed: () {},
                     // child: Text(getAngleText()),
                  // ),
                ],
              ),
              SizedBox(height: 10),

              // * Lado A
              // * Aplicação do Zoom (Imagem fixa e Independente)
              Center(
                child: InteractiveViewer(
                  boundaryMargin: EdgeInsets.all(100),
                  minScale: 0.5,
                  maxScale: 1.6,
                  child: GestureDetector(
                    onScaleUpdate: (details) {
                      if (lastPosition != null) {
                        final Offset centerOfGestureDetector = Offset(424 / 2, 424 / 2); //* Calcula a posição inicial do gesto em relação ao centro.
                        final Offset startPosition = lastPosition! - centerOfGestureDetector; // * Obtém-se o ângulo da posição inicial em relação a x positivo.
                        final Offset currentPosition = details.localFocalPoint - centerOfGestureDetector; // * Obtém-se o ângulo da posição central em relação a x positivo.

                        final startAngle = startPosition.direction;
                        final currentAngle = currentPosition.direction;

                        setState(() {
                          angle += currentAngle - startAngle; //* Nesta parte ela atualiza o ângulo de rotação com base na diferença entre o ângulo inicial e o ângulo final.
                          scale = details.scale;
                        });
                      }
                      lastPosition = details.localFocalPoint;
                    },
                    onScaleEnd: (details) {
                      lastPosition = null;
                    },
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
                                image: AssetImage("assets/CDV1.png"), //* Aqui removi a escala circular e agora aparece em partes a imagem preta.
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
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

              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              title: Text('Opção 1'),
              onTap: () {
                showMessage('Nenhuma lógica para Opção 1 ainda :/');
              },
            ),
            ListTile(
              title: Text('Opção 2'),
              onTap: () {
                showMessage('Nenhuma lógica para Opção 2 ainda :/');
              },
            ),
          ],
        ),
      ),
    );
  }
}
