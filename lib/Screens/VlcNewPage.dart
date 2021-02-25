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
        VlcPlayer(
          aspectRatio: videoRatio,
          controller: vlcPlayerController,
          placeholder: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        Center(
          child: RaisedButton(
            onPressed: () async {
              print(await vlcPlayerController.getVideoAspectRatio());
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
        // videoRatio =
        //     double.parse(await vlcPlayerController.getVideoAspectRatio());
        // print(await vlcPlayerController.getVideoAspectRatio());

        await vlcPlayerController.play();
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
