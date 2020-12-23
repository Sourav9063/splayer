import 'package:flutter/material.dart';
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
  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(widget.link);
    videoPlayerController.initialize().then((_) {
      videoPlayerController.play();
      videoPlayerController.setPlaybackSpeed(1.5);
      VideoPlayerOptions videoPlayerOptions =
          videoPlayerController.videoPlayerOptions;

      setState(() {});
    });

    print(widget.link);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              videoPlayerController.value.isPlaying
                  ? videoPlayerController.pause()
                  : videoPlayerController.play();
            });
          },
          child: Icon(
            videoPlayerController.value.isPlaying
                ? Icons.pause
                : Icons.play_arrow,
          ),
        ),
        body: OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.portrait) {
              return Center(
                child: Text("Please trun to landscape"),
              );
            } else
              return videoPlayerController.value.initialized
                  ? Center(
                      child: AspectRatio(
                        aspectRatio: videoPlayerController.value.aspectRatio,
                        child: VideoPlayer(videoPlayerController,),
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    );
          },
        ));
  }
}
