import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:splayer/GlobalVar.dart';

class VlcNewPlayer extends StatefulWidget {
  VlcNewPlayer({Key key, @required this.location}) : super(key: key);
  final String location;

  @override
  _VlcNewPlayerState createState() => _VlcNewPlayerState();
}

class _VlcNewPlayerState extends State<VlcNewPlayer> {
  VlcPlayerController vlcPlayerController;
  double videoRatio = scrnheight / scrnwidth;
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    scrnSetUp(videoRatio);
    loadFromLocation(widget.location);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    vlcPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: VlcPlayer(
            aspectRatio: videoRatio,
            controller: vlcPlayerController,
            placeholder: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
        Center(
          child: ElevatedButton(
            child: Text("Ratio"),
            onPressed: () async {
              var ratio = await vlcPlayerController.getVideoAspectRatio();
              print(ratio);
            },
          ),
        ),
      ],
    );
  }

//methods
  Future<void> loadFromLocation(String location) async {
    File file = File(location);

    vlcPlayerController = VlcPlayerController.file(
      file,
      onInit: () async {
        await vlcPlayerController.play();
        String aspectratio = await vlcPlayerController.getVideoAspectRatio();
        videoRatio = double.parse(aspectratio);
        print(aspectratio);
        print(videoRatio);
        await scrnSetUp(videoRatio);
        // setState(() {});
      },
    );
  }

  Future<void> scrnSetUp(double ratio) async {
    if (ratio >= 1) {
      await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    } else {
      await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    }
  }
}
