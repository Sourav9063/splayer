import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:splayer/GlobalVar.dart';

class VlcVideoPlayerPage extends StatefulWidget {
  VlcVideoPlayerPage({Key key, @required this.link}) : super(key: key);
  final String link;

  @override
  _VlcVideoPlayerPageState createState() => _VlcVideoPlayerPageState();
}

class _VlcVideoPlayerPageState extends State<VlcVideoPlayerPage> {
  VlcPlayerController vlcPlayerController;
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

  @override
  void initState() {
    scrnSetUp(1.5);
    vlcPlayerController = VlcPlayerController(
      onInit: () {
        vlcPlayerController.play();
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: () async {
                print(vlcPlayerController.audioTracksCount);

                try {
                  await vlcPlayerController.setVideoAspectRatio("1");
                } catch (e) {
                  print(e);
                }
              },
              onDoubleTap: () async {
                await vlcPlayerController.isPlaying()
                    ? vlcPlayerController.pause()
                    : vlcPlayerController.play();
              },
              onScaleUpdate: (details) async {
                print(details.toString());

                print(vlcPlayerController.aspectRatio);
              },
              child: Container(
                // color: Colors.white,
                child: VlcPlayer(
                  controller: vlcPlayerController,
                  aspectRatio: scrnheight / scrnwidth,
                  isLocalMedia: true,
                  url: widget.link,
                  placeholder: Center(child: CircularProgressIndicator()),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
