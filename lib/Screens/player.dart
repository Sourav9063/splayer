import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:splayer/GlobalVar.dart';

import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  VideoPlayerScreen({Key key, @required this.link}) : super(key: key);
  final String link;

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController videoPlayerController;
  Orientation or;
  double videoRario = 16 / 9;
  bool show = false;
  ValueNotifier<Duration> passedTime = ValueNotifier(Duration(seconds: 0));

  void scrnSetUp(double ratio) async {
    await SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    if (ratio >= 1) {
      await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    } else {
      await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    }
  }

  //  = Orientation.landscape;
  @override
  void initState() {
    super.initState();

    if (widget.link.startsWith("http"))
      videoPlayerController = VideoPlayerController.network(widget.link);
    else {
      var file = File(widget.link);
      videoPlayerController = VideoPlayerController.file(file);
    }
    videoPlayerController.initialize().then((_) {
      videoPlayerController.play();
      videoPlayerController.setPlaybackSpeed(1.5);
      print(videoPlayerController.value.aspectRatio);
      videoRario = videoPlayerController.value.aspectRatio;
      scrnSetUp(videoPlayerController.value.aspectRatio);

      VideoPlayerOptions videoPlayerOptions =
          videoPlayerController.videoPlayerOptions;

      setState(() {});
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    videoPlayerController.dispose();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Stack(
            children: [
              Center(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      show = !show;
                    });
                  },
                  onDoubleTap: () {
                    setState(() {
                      videoPlayerController.value.isPlaying
                          ? videoPlayerController.pause()
                          : videoPlayerController.play();
                      show = !videoPlayerController.value.isPlaying;
                    });
                  },
                  onScaleUpdate: (details) {
                    // print(details.);

                    if (details.scale > 1) {
                      setState(() {
                        videoRario = (scrnwidth) / (scrnheight);
                      });
                    } else if (details.scale < 1) {
                      setState(() {
                        videoRario = videoPlayerController.value.aspectRatio;
                      });
                    }
                  },
                  child: AspectRatio(
                    // aspectRatio: videoPlayerController.value.aspectRatio,
                    aspectRatio: videoRario,
                    child: VideoPlayer(
                      videoPlayerController,
                    ),
                  ),
                ),
              ),
              AnimatedOpacity(
                duration: Duration(milliseconds: 300),
                opacity: show ? 1 : 0,
                child: Visibility(
                  visible: show,
                  child: Align(
                      alignment: Alignment(1, .9),
                      child: VideoProgressIndicator(
                        videoPlayerController,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        allowScrubbing: true,
                      )),
                ),
              ),
              Row(
                children: [
                  // Text(videoPlayerController.value.position.)
                  ValueListenableBuilder(
                    valueListenable:
                        ValueNotifier(videoPlayerController.value.position),
                    builder:
                        (BuildContext context, dynamic value, Widget child) {
                      print(value.toString());
                      return Container();
                    },
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
