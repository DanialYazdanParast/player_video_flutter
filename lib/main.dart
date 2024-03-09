import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final VideoPlayerController _controller =
      VideoPlayerController.asset('assets/vid.mp4')
        ..initialize()
        ..setLooping(true)
        ..play();

  Timer? timer;

  @override
  void dispose() {
    _controller.dispose();
    timer?.cancel();
    super.dispose();
  }

  bool showControlPanel = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
          
            child: GestureDetector(
                onTap: () {
                  if (!showControlPanel) {
                    setState(() {
                      showControlPanel = true;
                    });
                    initControlPanelTimer();
                  }
                },
                child: VideoPlayer(_controller)),
          ),
      //    if (showControlPanel)
            VideoControlPanel(
              controller: _controller,
              gestureTapCallback: () {
                setState(() {
                  showControlPanel = false;
                });
                timer?.cancel();
              },
            )
        ],
      ),
    );
  }

  void initControlPanelTimer() {
    timer?.cancel();
    timer = Timer(const Duration(seconds: 2), () {
      setState(() {
        showControlPanel = false;
      });
    });
  }
}

class VideoControlPanel extends StatefulWidget {
  const VideoControlPanel({
    super.key,
    required VideoPlayerController controller,
    required this.gestureTapCallback,
  }) : _controller = controller;

  final VideoPlayerController _controller;
  final GestureTapCallback gestureTapCallback;

  @override
  State<VideoControlPanel> createState() => _VideoControlPanelState();
}

class _VideoControlPanelState extends State<VideoControlPanel> {
  late final Timer timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
    setState(() {});
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
        child: GestureDetector(
      onTap: widget.gestureTapCallback,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 16, top: 48, right: 16),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset(
                          'assets/1.jpg',
                          width: 60,
                        )),
                    const Padding(
                      padding: EdgeInsets.only(left: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Daniel Yazdan',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            '@ Daniel',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'کیک شکلاتی بخوریم',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    const Text(
                      'امروز',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    VideoProgressIndicator(
                      widget._controller,
                      allowScrubbing: true,
                      colors: VideoProgressColors(
                        playedColor: Colors.white,
                        backgroundColor: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _printDuration(widget._controller.value.position),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                          Text(
                            _printDuration(widget._controller.value.duration),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {},
                            iconSize: 24,
                            icon: const Icon(
                              CupertinoIcons.backward_fill,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                widget._controller.value.isPlaying ?  widget._controller.pause():  widget._controller.play();
                              });
                            },
                            iconSize: 56,
                            icon: Icon(
                              widget._controller.value.isPlaying
                                  ? CupertinoIcons.pause_circle_fill
                                  : CupertinoIcons.play_circle_fill,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            iconSize: 24,
                            icon: const Icon(
                              CupertinoIcons.forward_fill,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ]),
        ),
      ),
    ));
  }

  String _printDuration(Duration duration) {
    String negativeSign = duration.isNegative ? '-' : '';
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
    return "$negativeSign$twoDigitMinutes:$twoDigitSeconds";
  }
}
