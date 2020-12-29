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
  double seekPos = 0.0;
  double dis;
  Orientation or;
  double videoRario = 16 / 9;
  bool show = false;
  ValueNotifier<Duration> passedTime = ValueNotifier(Duration(seconds: 0));
  double vSpeed = 1;

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

  File file;
  //  = Orientation.landscape;
  @override
  void initState() {
    super.initState();

    if (widget.link.startsWith("http"))
      videoPlayerController = VideoPlayerController.network(widget.link);
    else {
      file = File(widget.link);
      videoPlayerController = VideoPlayerController.file(file);
    }
    videoPlayerController.initialize().then((_) {
      videoPlayerController.play();

      videoRario = videoPlayerController.value.aspectRatio;
      scrnSetUp(videoPlayerController.value.aspectRatio);

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
    print("update");
    return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: videoPlayerController.value.initialized
              ? Stack(
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
                        onHorizontalDragStart: (details) {
                          seekPos = details.globalPosition.dy;
                          setState(() {
                            show = true;
                          });
                        },
                        onHorizontalDragEnd: (details) {
                          setState(() {
                            show = false;
                          });
                        },
                        onHorizontalDragUpdate: (details) {
                          dis = details.globalPosition.dy - seekPos;
                          // // print(details.delta.distance.toString() + "pixel");
                          // int sec = dis.toInt();
                          // // print(details.localPosition.dy);
                          // print(dis.toString() + 'Seek');

                          // videoPlayerController.seekTo(
                          //     videoPlayerController.value.position +
                          //         Duration(seconds: sec));
                          // // setState(() {});
                          print(details.delta.dx);
                          if (details.delta.dx < 0) {
                            videoPlayerController.seekTo(
                                videoPlayerController.value.position -
                                    Duration(seconds: 1));
                          } else if (details.delta.dx > 0) {
                            videoPlayerController.seekTo(
                                videoPlayerController.value.position +
                                    Duration(seconds: 1));
                          }
                        },
                        onScaleUpdate: (details) {
                          // print(details.);

                          if (details.scale > 1) {
                            setState(() {
                              videoRario = (scrnwidth) / (scrnheight);
                            });
                          } else if (details.scale < 1) {
                            setState(() {
                              videoRario =
                                  videoPlayerController.value.aspectRatio;
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
                        child: Stack(
                          children: [
                            Positioned(
                                right: 10,
                                top: 0,
                                child: Row(
                                  children: [
                                    Text('Speed:  '),
                                    DropdownButton(
                                      value: vSpeed,
                                      dropdownColor: Colors.black38,
                                      underline: Container(),
                                      items: [
                                        DropdownMenuItem(
                                          child: Text("0.5"),
                                          value: .5,
                                        ),
                                        DropdownMenuItem(
                                          child: Text("0.75"),
                                          value: .75,
                                        ),
                                        DropdownMenuItem(
                                          child: Text("1"),
                                          value: 1.0,
                                        ),
                                        DropdownMenuItem(
                                          child: Text("1.5"),
                                          value: 1.5,
                                        ),
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          vSpeed = value;
                                        });

                                        videoPlayerController
                                            .setPlaybackSpeed(value);
                                      },
                                    ),
                                  ],
                                )),
                            Align(
                                alignment: Alignment(1, .9),
                                child: VideoProgressIndicator(
                                  videoPlayerController,
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  allowScrubbing: true,
                                )),
                            Align(
                              alignment: Alignment(.9, .95),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Text(videoPlayerController.value.position.)
                                  ValueListenableBuilder(
                                    valueListenable: videoPlayerController,
                                    builder: (BuildContext context,
                                        VideoPlayerValue value, Widget child) {
                                      // print(value.toString());
                                      return Text(
                                        value.position.toString().replaceRange(
                                            value.position
                                                .toString()
                                                .lastIndexOf('.'),
                                            value.position.toString().length,
                                            ''),
                                        textScaleFactor: 1.05,
                                      );
                                    },
                                  ),
                                  Text(
                                      videoPlayerController.value.duration
                                          .toString()
                                          .replaceRange(
                                              videoPlayerController
                                                  .value.position
                                                  .toString()
                                                  .lastIndexOf('.'),
                                              videoPlayerController
                                                  .value.position
                                                  .toString()
                                                  .length,
                                              ''),
                                      textScaleFactor: 1.05)
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : CircularProgressIndicator(),
        ));
  }
}
