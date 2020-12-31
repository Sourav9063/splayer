import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:splayer/BackEnd/Times.dart';
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
  double seekPosFirst = 0.0;
  double seekDis = 0.0;
  bool showSeek = false;
  Orientation or;
  double videoRatio = 16 / 9;
  bool show = false;
  // ValueNotifier<Duration> passedTime = ValueNotifier(Duration(seconds: 0));
  double vSpeed = 1;

  void scrnSetUp(double ratio) async {
    await SystemChrome.setEnabledSystemUIOverlays([]);
    if (ratio >= 1) {
      await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    } else {
      await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    }
  }

  void setResumeOnstart() async {
    int second = await ResumeTime.getResumeTimeInSecond(widget.link);

    if (second != null) videoPlayerController.seekTo(Duration(seconds: second));
  }

  void setResumeOnend() async {
    Duration second = await videoPlayerController.position;
    ResumeTime.setResumeTime(widget.link, second.inSeconds);
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

      videoPlayerController.addListener(() {});
      videoRatio = videoPlayerController.value.aspectRatio;
      // videoPlayerController.
      scrnSetUp(videoPlayerController.value.aspectRatio);
      setResumeOnstart();

      setState(() {});
    });
  }

  @override
  void dispose() {
    setResumeOnend();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    videoPlayerController.dispose();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("update");
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
        backgroundColor: Colors.black,
        body: videoPlayerController.value.initialized
            ? Stack(
                overflow: Overflow.visible,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        print(await ResumeTime.getResumeTimeInSecond(
                            widget.link));
                        // print(videoPlayerController.value.)
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
                        seekPosFirst = details.globalPosition.dx;
                        setState(() {
                          showSeek = true;
                        });
                      },
                      onHorizontalDragEnd: (details) {
                        seekPosFirst = 0.0;
                        videoPlayerController.seekTo(
                            videoPlayerController.value.position +
                                Duration(seconds: (seekDis * .25).toInt()));
                        setState(() {
                          showSeek = false;
                        });
                        seekDis = 0.0;
                      },
                      onHorizontalDragUpdate: (details) {
                        setState(() {
                          seekDis = details.globalPosition.dx - seekPosFirst;
                        });
                        print(details.globalPosition.dx);
                      },
                      onScaleUpdate: (details) {
                        // print(details.);

                        if (details.scale > 1) {
                          setState(() {
                            videoRatio = (scrnwidth) / (scrnheight);
                          });
                        } else if (details.scale < 1) {
                          setState(() {
                            videoRatio =
                                videoPlayerController.value.aspectRatio;
                          });
                        }
                      },
                      child: AspectRatio(
                        // aspectRatio: videoPlayerController.value.aspectRatio,
                        aspectRatio: videoRatio,
                        child: Stack(
                          children: [
                            VideoPlayer(
                              videoPlayerController,
                            ),
                            Center(
                              child: ClosedCaption(
                                text: videoPlayerController.value.caption.text,
                              ),
                            )
                          ],
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
                              right: 0,
                              top: 0,
                              left: 0,
                              child: Container(
                                color: Colors.black45,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        // fit: BoxFit.fitWidth,
                                        child: Text(videoPlayerController
                                            .dataSource
                                            .replaceRange(
                                                0,
                                                videoPlayerController.dataSource
                                                        .lastIndexOf('/') +
                                                    1,
                                                '')),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                              icon: Icon(Icons.screen_rotation),
                                              onPressed: () async {
                                                if (mediaQuery.orientation ==
                                                    Orientation.portrait) {
                                                  await SystemChrome
                                                      .setPreferredOrientations([
                                                    DeviceOrientation
                                                        .landscapeLeft,
                                                    DeviceOrientation
                                                        .landscapeRight
                                                  ]);
                                                } else {
                                                  await SystemChrome
                                                      .setPreferredOrientations([
                                                    DeviceOrientation
                                                        .portraitDown,
                                                    DeviceOrientation.portraitUp
                                                  ]);
                                                }
                                              }),
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
                                                child: Text("1.25"),
                                                value: 1.25,
                                              ),
                                              DropdownMenuItem(
                                                child: Text("1.5"),
                                                value: 1.5,
                                              ),
                                              DropdownMenuItem(
                                                child: Text("1.75"),
                                                value: 1.75,
                                              ),
                                              DropdownMenuItem(
                                                child: Text("2"),
                                                value: 2,
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
                                          SizedBox(
                                            width: 10,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                            videoPlayerController.value.position
                                                .toString()
                                                .lastIndexOf('.'),
                                            videoPlayerController.value.position
                                                .toString()
                                                .length,
                                            ''),
                                    textScaleFactor: 1.05)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: showSeek,
                    child: Center(
                        child: Text(
                      (seekDis * .25).toInt().toString(),
                      textScaleFactor: 2.5,
                    )),
                  )
                ],
              )
            : Center(child: CircularProgressIndicator()));
  }
}

// // print(details.delta.distance.toString() + "pixel");
// int sec = dis.toInt();
// // print(details.localPosition.dy);
// print(dis.toString() + 'Seek');

// videoPlayerController.seekTo(
//     videoPlayerController.value.position +
//         Duration(seconds: sec));
// // setState(() {});

// print(details.delta.dx);
// if (details.delta.dx < 0) {
//   videoPlayerController.seekTo(
//       videoPlayerController.value.position -
//           Duration(seconds: 1));
// } else if (details.delta.dx > 0) {
//   videoPlayerController.seekTo(
//       videoPlayerController.value.position +
//           Duration(seconds: 1));
// }
