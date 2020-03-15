import 'dart:math';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'waveBackground.dart';
import '../screensNames.dart';

class ParticleBackgroundScreen extends StatefulWidget
{
  @override
  State<StatefulWidget> createState()
  {
    return ParticleBackgroundScreenState();
  }
}

class ParticleBackgroundScreenState extends State<ParticleBackgroundScreen>
{
  @override
  Widget build(BuildContext context)
  {
    return Stack(children: <Widget>
    [
      Positioned.fill(child: Background()),

      //onBottom(AnimatedWave(height: 180, speed: 1.0)),
      //onBottom(AnimatedWave(height: 120, speed: 0.9, offset: pi)),

      Positioned.fill(child: Particles(30)),

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
    ]);
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

class Particles extends StatefulWidget
{
  final int numberOfParticle;

  Particles(this.numberOfParticle);

  @override
  ParticlesState createState() => ParticlesState();
}

class ParticlesState extends State<Particles>
{
  final Random random = Random();

  final List<ParticleModel> particles = [];

  @override
  void initState()
  {
    List.generate(widget.numberOfParticle, (index)
    {
      particles.add(ParticleModel(random));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context)
  {
    return Rendering
    (
      startTime: Duration(seconds: 30),
      onTick: _simulateParticles,
      builder: (context, time)
      {
        return CustomPaint(painter: ParticlePainter(particles, time));
      },
    );
  }

  _simulateParticles(Duration time)
  {
    particles.forEach((particle) => particle.maintainRestart(time));
  }
}


class ParticleModel
{
  Animatable tween;
  double size;
  AnimationProgress animationProgress;
  Random random;

  ParticleModel(this.random)
  {
    restart();
  }

  restart({Duration time = Duration.zero})
  {
    final startPosition = Offset(-0.2 + 1.4 * random.nextDouble(), 1.2);
    final endPosition = Offset(-0.2 + 1.4 * random.nextDouble(), -0.2);
    final duration = Duration(milliseconds: 3000 + random.nextInt(6000));

    tween = MultiTrackTween
    ([
      Track("x").add(
        duration, Tween(begin: startPosition.dx, end: endPosition.dx),
        curve: Curves.easeInOutSine),
      Track("y").add(
        duration, Tween(begin: startPosition.dy, end: endPosition.dy),
        curve: Curves.easeIn)
    ]);

    animationProgress = AnimationProgress(duration: duration, startTime: time);
    size = 0.2 + random.nextDouble() * 0.4;
  }

  maintainRestart(Duration time)
  {
    if(animationProgress.progress(time) == 1.0)
      restart(time: time);
  }
}


class ParticlePainter extends CustomPainter
{
  List<ParticleModel> particles;
  Duration time;

  ParticlePainter(this.particles, this.time);

  @override
  void paint(Canvas canvas, Size size)
  {
    final paint = Paint()..color = Colors.white.withAlpha(50);

    particles.forEach((particle)
    {
      var progress = particle.animationProgress.progress(time);
      final animation = particle.tween.transform(progress);
      final position =
          Offset(animation["x"] * size.width, animation["y"] * size.height);
      canvas.drawCircle(position, size.width * 0.2 * particle.size, paint);
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}