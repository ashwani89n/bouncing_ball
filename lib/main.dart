import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bouncing Ball',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  double ballPositionY = 0.0;
  double ballPositionX = 0.0;
  Color ballColor = Colors.black87; // Initial ball color

  double _colorValue = 0.0; // Initial value for the color slider
  double _speedValue = 0.1; // Initial value for the speed slider

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _controller.addListener(() {
      setState(() {
        ballPositionY = _animation.value.dy;
        ballPositionX = _animation.value.dx;
      });
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

    _animation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(0.0, 1.0),
    ).animate(_controller);
  }

  void startAnimation() {
    _controller.forward();
  }

  void stopAnimation() {
    _controller.stop();
  }

  void changeBallColor(double value) {
    setState(() {
      _colorValue = value;
      ballColor = Color.lerp(Colors.black, Colors.grey, _colorValue)!;
    });
  }

  void changeSpeed(double value) {
    setState(() {
      _speedValue = value;
      int durationInSeconds = (_speedValue * 10).toInt();
      if (durationInSeconds < 1) durationInSeconds = 1;
      _controller.duration = Duration(seconds: durationInSeconds);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bouncing Ball'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1.5),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: ballPositionX * 250,
                    top: ballPositionY * 250,
                    child: Ball(ballColor),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Slider(
                  value: _colorValue,
                  onChanged: changeBallColor,
                  min: 0.0,
                  max: 1.0,
                  activeColor:
                      Colors.black, // Color of the active part of the slider
                ),
                Slider(
                  value: _speedValue,
                  onChanged: changeSpeed,
                  min: 0.1,
                  max: 0.5,
                  activeColor:
                      Colors.black, // Color of the active part of the slider
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: startAnimation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Start',
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: stopAnimation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Stop'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class Ball extends StatelessWidget {
  final Color color;

  Ball(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
