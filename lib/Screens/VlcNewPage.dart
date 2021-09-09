import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:provider/provider.dart';
import 'package:splayer/BackEnd/Times.dart';
import 'package:splayer/GlobalVar.dart';
import 'package:video_player/video_player.dart';

class VlcNewPlayer extends StatefulWidget {
  VlcNewPlayer({Key? key, required this.location}) : super(key: key);
  final String location;

  @override
  _VlcNewPlayerState createState() => _VlcNewPlayerState();
}

class _VlcNewPlayerState extends State<VlcNewPlayer> {
  late VlcPlayerController vlcPlayerController;
  double aspectR = (scrnheight / scrnwidth);
  double currentPosition = 0;
  bool firstFrameCall = false;

  @override
  void initState() {
    super.initState();
    vlcPlayerController = controllerSetUp(widget.location);

    vlcPlayerController.addListener(listner);
    vlcPlayerController.addOnInitListener(() {});
  }

  @override
  void dispose() async {
    super.dispose();
    await SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    setResumeOnend();
    // vlcPlayerController.removeListener(listner);
    await vlcPlayerController.dispose();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

  //   });
  // }

  VlcPlayerController controllerSetUp(String link) {
    // link = 'https://media.w3.org/2010/05/sintel/trailer.mp4';
    if (link.startsWith('http')) {
      print("Http");
      return VlcPlayerController.network(link);
    } else {
      print("File");
      var file = File(link);
      return VlcPlayerController.file(
        file,
        autoInitialize: true,
        autoPlay: true,
        options: VlcPlayerOptions(
          subtitle: VlcSubtitleOptions(
            [
              VlcSubtitleOptions.opacity(200),
              VlcSubtitleOptions.fontSize(50),
            ],
          ),
        ),
      );
    }
  }

  void scrnSetUp(double ratio) async {
    // print("aspect reaito");
    await SystemChrome.setEnabledSystemUIOverlays([]);
    if (ratio >= 1) {
      await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    } else {
      await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    }
    setState(() {});
    // setResumeOnstart();
  }

  listner() {
    if (!mounted) return;
    if (vlcPlayerController.value.isInitialized) {
      if (!firstFrameCall) {
        firstFrameFun();
      }
      // scrnSetUp(vlcPlayerController.value.aspectRatio);
      // print(vlcPlayerController.value.aspectRatio.toString() +
      //     "***************************************************************************************************************************");
      // print(vlcPlayerController.value.isPlaying.toString() +
      //     "***************************************************************************************************************************");
      // print(vlcPlayerController.value.toString() +
      // "***************************************************************************************************************************");
    }
  }

  Future<void> firstFrameFun() async {
    bool playing = vlcPlayerController.value.isPlaying;

    if (playing == false) {
      return;
    } else {
      firstFrameCall = true;
      await setResumeOnstart();
      print(vlcPlayerController.value.aspectRatio.toString() +
          "**********************************************************************************************************");
      scrnSetUp(vlcPlayerController.value.aspectRatio);
    }
  }

  Future<void> setResumeOnstart() async {
    int? second = await ResumeTime.getResumeTimeInSecond(widget.location);

    print(second.toString());
    print("**************************************************************");

    if (second != null) {
      await vlcPlayerController.seekTo(Duration(seconds: second));
      // setState(() {});
    }
  }

  setResumeOnend() {
    Duration second = vlcPlayerController.value.position;

    print(second.toString());
    ResumeTime.setResumeTime(widget.location, second.inSeconds);
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    return Scaffold(
      // backgroundColor: Colors.white,
      body: Stack(
        children: [
          Align(
              alignment: Alignment.center,
              child: VlcPlayer(
                controller: vlcPlayerController,

                // aspectRatio: vlcPlayerController.value.aspectRatio,
                aspectRatio: MediaQuery.of(context).size.aspectRatio,

                placeholder: Center(child: CircularProgressIndicator()),
              )),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () async {
                // setResumeOnstart();

                await vlcPlayerController.setVideoAspectRatio(
                    scrnwidth.floor().toString() +
                        ":" +
                        scrnheight.floor().toString());
                // setState(() {
                //   aspectR = scrnheight / scrnwidth;
                // });
              },
              child: Text("test"),
            ),
          ),
        ],
      ),
    );
  }

  // @override
  // bool get wantKeepAlive => true;
}
