import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Button Example',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _title = 'Button with Action';
  int x=0;
  void _changeTitle() {
    setState(() {
       x++;
      _title = '¡Título cambiado! $x veces';
    });
  }
  void _restarTitle(){
    setState((){
      x--;
      _title = '¡Título cambiado! $x veces';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _changeTitle,
              child: const Text('Sumar'),
            ),
            ElevatedButton(
              onPressed: _restarTitle,
              child: const Text('Restar'),
            ),
          ],
        ),
      ),
    );
  }
}
