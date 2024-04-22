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
      theme: ThemeData(),
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
  Offset? lastPosition;
  bool isRotationLocked = false;

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
        title: Text('Computador de Vôo'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                          MaterialPageRoute(
                              builder: (context) => Calculadora()),
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
                        setState(() {
                          isRotationLocked = !isRotationLocked;
                        });
                        showMessage(isRotationLocked ? 'Sistema Preso' : 'Sistema Desbloqueado');
                      },
                      child: Text('Prender'),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Center(
                  child: InteractiveViewer(
                    // boundaryMargin: EdgeInsets.all(100),
                    minScale: 0.1,
                    maxScale: 2.5,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 500,
                          height: 500,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage('assets/CDV1.jpeg'),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onScaleUpdate: (details) {
                            if (!isRotationLocked && lastPosition != null) {
                              Offset centerOfGestureDetector = Offset(
                                  424 / 2,
                                  424 /
                                      2); 
                              final Offset startPosition = lastPosition! -
                                  centerOfGestureDetector; 
                              final Offset currentPosition = details
                                      .localFocalPoint -
                                  centerOfGestureDetector; 

                              final startAngle = startPosition.direction;
                              final currentAngle = currentPosition.direction;

                              setState(() {
                                angle += currentAngle -
                                    startAngle; 
                              });
                            }
                            lastPosition = details.localFocalPoint;
                          },
                          onScaleEnd: (details) {
                            lastPosition = null;
                          },
                          child: Transform.rotate(
                            angle: angle,
                            child: Container(
                              width: 373,
                              height: 373,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage('assets/CDV.jpeg'),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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
