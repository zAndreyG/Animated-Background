import 'dart:math';
import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';
import 'package:simple_animations/simple_animations.dart';
import '../screensNames.dart';

class FancyBackgroundScreen extends StatefulWidget
{
  @override
  State<StatefulWidget> createState()
  {
    return FancyBackgroundScreenState();
  }
}

class FancyBackgroundScreenState extends State<FancyBackgroundScreen>
{
  @override
  Widget build(BuildContext context)
  {
    return Stack
    (
      children: <Widget>
      [
        Positioned.fill(child: Background()),

        onBottom(AnimatedWave(height: 180, speed: 1.0)),

        onBottom(AnimatedWave(height: 120, speed: 0.9, offset: pi)),

        onBottom(AnimatedWave(height: 220, speed: 1.2, offset: pi / 2)),

        Scaffold
        (
          backgroundColor: Colors.transparent,
          appBar: AppBar
          (
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            actions: <Widget>
            [
              PopupMenuButton<String>
              (
                color: Colors.white,
                onSelected: choiceAction,
                itemBuilder: (BuildContext context)
                {
                  return ScreensNames.choices.map((String choice) 
                  {
                    return PopupMenuItem<String>
                    (
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              )
            ],
          ),
        )
      ],
    );
  }

  onBottom(Widget child) => Positioned.fill
  (
    child: Align
    (
      alignment: Alignment.bottomCenter,
      child: child,
    ),
  );

  void choiceAction(String choice)
  {
    if(choice == ScreensNames.waveScreen)
    {
      Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    }
    else if(choice == ScreensNames.particleScreen)
    {
      Navigator.of(context).pushNamedAndRemoveUntil('/particles', (Route<dynamic> route) => false);
    }
    else
    {
      Navigator.of(context).pushNamed('/draw');
    }
  }
}

// Cores animadas no Background
class Background extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    //Lista de Cores e duraçao da Transição
    final tween = MultiTrackTween
    ([
      Track("color1").add(Duration(seconds: 3),
        ColorTween(begin: Colors.orange, end: Colors.lightBlue.shade900)),
      Track("color2").add(Duration(seconds: 3),
        ColorTween(begin: Color(0xffA83279), end: Colors.yellow.shade600))
    ]);
    
    //Controller da mudança de cores
    return ControlledAnimation
    (
      playback: Playback.MIRROR,
      tween: tween,
      duration: tween.duration,
      builder: (context, animation)
      {
        return Container
        (
          decoration: BoxDecoration
          (
            gradient: LinearGradient
            (
              begin: Alignment.topCenter,
              end:   Alignment.bottomCenter,
              colors: [animation["color1"], animation["color2"]]
            )
          ),
        );});}}

// Ondas do Background
class AnimatedWave extends StatelessWidget
{
  final double height;
  final double speed;
  final double offset;

  //Construtor
  AnimatedWave({this.height, this.speed, this.offset = 0.0});

  @override
  Widget build(BuildContext context)
  {
    var mediaQuery = MediaQuery.of(context);

    return Container
    (
      height: height,
      width: mediaQuery.size.width,
      child: ControlledAnimation
      (
        playback: Playback.LOOP,
        duration: Duration(milliseconds: (5000 / speed).round()),
        tween: Tween(begin: 0.0, end: 2 * pi),
        builder: (context, value)
        {
          return CustomPaint
          (
            foregroundPainter: CurvePainter(value + offset),
          );
        }
      ),
    );}}

// Movimentação das Ondas - Curva de Bézier
class CurvePainter extends CustomPainter
{
  final double value;

  CurvePainter(this.value);

  @override
  void paint(Canvas canvas, Size size)
  {
    final white = Paint()..color = Colors.white.withAlpha(60);
    final path = Path();

    final y1 = sin(value);
    final y2 = sin(value + pi / 2);
    final y3 = sin(value + pi);

    final startPointY = size.height * (0.5 + 0.4 * y1);
    final controlPointY = size.height * (0.5 + 0.4 * y2);
    final endPointY = size.height * (0.5 + 0.4 * y3);

    path.moveTo(size.width * 0, startPointY);
    path.quadraticBezierTo(size.width * 0.5, controlPointY, size.width, endPointY);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, white);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate)
  {
    return true;
  }
}