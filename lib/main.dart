import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Importa esta biblioteca

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adivina el numero',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Adivina el numero'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 10; // Intentos restantes
  final TextEditingController _controller = TextEditingController();
  int _helperText = 0;
  String _labelText = 'Ingresa un número y prueba tu suerte';
  int _numero = Random().nextInt(100);
  String _content = '';
  int _hintText = 100;
  int _prevValue = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _showCongratulationsDialog(int numero) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¡Felicidades!'),
          content: Text('¡Felicidades, encontraste el número $numero!'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showFailureDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Se acabaron los intentos'),
          content: const Text('Nimodo, no lo encontraste. Suerte para la otra.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Color _getCounterColor(int counter) {
    if (counter == 1) return const Color(0xFFD56F6F);
    if (counter == 2) return const Color(0xFFE98151);
    if (counter == 3 || counter == 4) return const Color(0xFFE9AE51);
    if (counter == 5 || counter == 6) return const Color(0xFFE9CA51);
    if (counter == 7 || counter == 8) return const Color(0xFFD9E951);
    if (counter == 9 || counter == 10) return const Color(0xFFA1E951);
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: _getCounterColor(_counter),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                'Intentos restantes: $_counter',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              onSubmitted: (String value) {
                setState(() {
                  if (value.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Por favor escribe algo en la cajita roja'),
                      ),
                    );
                  } else {
                    int? intValue = int.tryParse(value);
                    if (intValue == null) {
                      _content = 'Ingresa un número válido. Intentos restantes: $_counter';
                    } else if (intValue > _numero) {
                      _labelText = 'Intenta otra vez';
                      _content = 'Valor muy alto.';
                      _counter--;
                      _helperText = intValue;
                    } else if (intValue < _numero) {
                      _labelText = 'Valor muy bajo';
                      _content = 'Valor muy bajo';
                      _counter--;
                    } else {
                      _labelText = '¡Exacto!';
                      _content = '¡Felicitaciones, acertaste!';
                      _showCongratulationsDialog(_numero); // Mostrar alerta
                    }

                    if (_counter <= 0 && intValue != _numero) {
                      _content = 'Se acabaron los intentos. El número era $_numero.';
                      _labelText = 'Sin intentos';
                      _showFailureDialog(); // Mostrar alerta de fallo
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(_content),
                      ),
                    );
                  }
                });
              },
              autofocus: true,
              decoration: InputDecoration(
                //prefixIcon: const Icon(Icons.person_2_rounded),
               helperText: _helperText.toString(),
                border: const OutlineInputBorder(),
                hintText: "Ingresa el numero",
                counterText: _hintText.toString(),
                labelText: _labelText,
                filled: true,
                fillColor: Colors.blueGrey,
                constraints: const BoxConstraints(maxWidth: 200),
              ),
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: Colors.blueAccent,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))], // Restringe solo a números
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
