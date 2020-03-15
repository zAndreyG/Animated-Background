import 'package:flutter/material.dart';
import 'screens/waveBackground.dart';
import 'screens/particleBackground.dart';
import 'screens/draw/draw.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp
    (
      initialRoute: '/',
      routes:
      {
        '/'          :  (context) => FancyBackgroundScreen(),
        '/particles' :  (context) => ParticleBackgroundScreen(),
        '/draw'      :  (context) => DrawScreen()
      },
    );
  }
}