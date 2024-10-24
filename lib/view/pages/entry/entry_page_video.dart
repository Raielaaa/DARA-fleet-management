import "package:flutter/material.dart";
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';

class EntryPage extends StatefulWidget {
  const EntryPage({Key? key});

  @override
  State<EntryPage> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("lib/assets/videos/light_animated_logo.mp4");

    _controller.addListener(() {
      setState(() {});
      if (_controller.value.position == _controller.value.duration) {
        Navigator.pushNamed(context, "entry_page_1");
      }
    });
    _controller.setLooping(false);
    _controller.initialize().then((_) {
      setState(() {});
      _controller.play(); // Start playing the video after initialization
    });
  }

  Future<void> loadImage(String imageUrl) async {
    try {
      await precacheImage(AssetImage(imageUrl), context);
    } catch(e) {
      debugPrint("Error@loadImage@entry_page_video.dart");
    }
  }


  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      color: const Color(0xffe8ebf2),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: _controller.value.isInitialized ?
          AspectRatio(
            aspectRatio: _controller.value.size.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : const CircularProgressIndicator(), // Show loading indicator while the video is initializing
      )
    ),
  );
}


  @override
  void dispose() {
    super.dispose();
    _controller.dispose(); // Dispose of the video controller
  }
}
