// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_vlc_player/flutter_vlc_player.dart';
// import 'package:splayer/BackEnd/Times.dart';
// import 'package:splayer/Components/blurredDialogue.dart';
// import 'package:splayer/GlobalVar.dart';

// class VlcPage extends StatefulWidget {
//   final String link;

//   const VlcPage({Key key, @required this.link}) : super(key: key);
//   @override
//   State<StatefulWidget> createState() => VlcPageState();
// }

// class VlcPageState extends State<VlcPage> {
// //   String initUrl =
// //       "http://samples.mplayerhq.hu/MPEG-4/embedded_subs/1Video_2Audio_2SUBs_timed_text_streams_.mp4";

// // //  String initUrl = "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4";
// // //  String initUrl = "/storage/emulated/0/Download/Test.mp4";
// // //  String initUrl = "/sdcard/Download/Test.mp4";

// //   String changeUrl =
// //       "http://distribution.bbb3d.renderfarming.net/video/mp4/bbb_sunflower_1080p_30fps_normal.mp4";

//   bool local;
//   bool show = true;
//   Uint8List image;
//   VlcPlayerController _videoViewController;
//   bool isPlaying = true;
//   double sliderValue = 0.0;
//   double currentPlayerTime = 0;
//   double volumeValue = 100;

//   int numberOfCaptions = 0;
//   int numberOfAudioTracks = 0;
//   bool isBuffering = true;
//   bool getCastDeviceBtnEnabled = false;

//   double seekDis = 0;

//   double seekPosFirst = 0;

//   bool showSeek = false;

//   void scrnSetUp(double ratio) async {
//     await SystemChrome.setEnabledSystemUIOverlays([]);
//     if (ratio >= 1) {
//       await SystemChrome.setPreferredOrientations(
//           [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
//     } else {
//       await SystemChrome.setPreferredOrientations(
//           [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
//     }
//   }

//   // var _scaffoldKey = GlobalKey<ScaffoldState>();
//   void setResumeOnstart() async {
//     int second = await ResumeTime.getResumeTimeInSecond(widget.link);

//     if (second != null) _videoViewController.setTime(second * 1000);
//     _videoViewController.play();
//   }

//   void setResumeOnend() async {
//     Duration second = await _videoViewController.getDuration();
//     ResumeTime.setResumeTime(widget.link, second.inSeconds);
//   }

//   @override
//   void initState() {
//     local = !widget.link.startsWith('http');

//     _videoViewController = VlcPlayerController.(widget.link,
      
      
//    );

//     _videoViewController.addListener(() {
//       if (!this.mounted) return;
//       if (_videoViewController.initialized) {
//         sliderValue = _videoViewController.position.inSeconds.toDouble();
//         numberOfCaptions = _videoViewController.spuTracksCount;
//         numberOfAudioTracks = _videoViewController.audioTracksCount;
//         // print(_videoViewController.isPlaying());
//         switch (_videoViewController.playingState) {
//           case PlayingState.PAUSED:
//             setState(() {
//               isBuffering = false;
//             });
//             break;

//           case PlayingState.STOPPED:
//             setState(() {
//               isPlaying = false;
//               isBuffering = false;
//             });
//             break;
//           case PlayingState.BUFFERING:
//             setState(() {
//               isBuffering = true;
//             });
//             break;
//           case PlayingState.PLAYING:
//             setState(() {
//               isBuffering = false;
//             });
//             break;
//           case PlayingState.ERROR:
//             setState(() {});
//             print("VLC encountered error");
//             break;
//           default:
//             setState(() {});
//             break;
//         }
//       }
//     });

//     scrnSetUp(1.4);

//     super.initState();
//   }

//   @override
//   void dispose() {
//     setResumeOnend();
//     SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

//     SystemChrome.setPreferredOrientations(
//         [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
//     _videoViewController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setEnabledSystemUIOverlays([]);
//     return Scaffold(
//       // key: _scaffoldKey,
//       body: Builder(
//         builder: (context) {
//           return
//               //  _videoViewController.initialized
//               //     ?
//               Stack(
//             children: [
//               VlcPlayer(
//                 aspectRatio: scrnwidth / scrnheight,
//                 url: widget.link,
//                 isLocalMedia: local,
//                 controller: _videoViewController,
//                 // Play with vlc options
//                 options: [
//                   '--quiet',
// //                '-vvv',
//                   '--no-drop-late-frames',
//                   '--no-skip-frames',
//                   '--rtsp-tcp',
//                 ],
//                 hwAcc: HwAcc.DISABLED,
//                 // or {HwAcc.AUTO, HwAcc.DECODING, HwAcc.FULL}
//                 placeholder: Container(
//                   height: 250.0,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[CircularProgressIndicator()],
//                   ),
//                 ),
//               ),
//               Visibility(
//                 visible: showSeek,
//                 child: Center(
//                     child: Text(
//                   (seekDis * .25).toInt().toString(),
//                   textScaleFactor: 2.5,
//                 )),
//               ),
//               Positioned(
//                 top: 0,
//                 bottom: 0,
//                 left: 0,
//                 right: 0,
//                 child: GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       show = !show;
//                     });
//                   },
//                   onDoubleTap: () {
//                     playOrPauseVideo();
//                   },
// //TODO: Implement drag
//                   // onHorizontalDragStart: (details) {
//                   //   seekPosFirst = details.globalPosition.dx;
//                   //   setState(() {
//                   //     showSeek = true;
//                   //   });
//                   // },
//                   // onHorizontalDragEnd: (details) {
//                   //   seekPosFirst = 0.0;

//                   //   seekDis = 0.0;
//                   //   setState(() {
//                   //     showSeek = false;
//                   //   });
//                   // },
//                   // onHorizontalDragUpdate: (details) {
//                   //   print(details.delta.dx);
//                   //   setState(() {
//                   //     seekDis = details.globalPosition.dx - seekPosFirst;
//                   //     // sliderValue = seekDis * .25.toDouble();

//                   //     _videoViewController.setTime(
//                   //         (_videoViewController.position +
//                   //                 Duration(seconds: (seekDis * .25).toInt()))
//                   //             .inMilliseconds);
//                   //     // double tmpSlidervalue = sliderValue + seekDis;
//                   //     // tmpSlidervalue > 0
//                   //     //     ? sliderValue = tmpSlidervalue
//                   //     //     : sliderValue = 1;
//                   //   });

//                   // videoPlayerController.seekTo(
//                   //     videoPlayerController.value.position +
//                   //         Duration(seconds: (seekDis * .25).toInt()));

//                   // print(seekDis);
//                   // },

//                   // onScaleUpdate: (details) {
//                   //   if (details.scale > 1) {
//                   //     print("zoom");
//                   //     _videoViewController.setVideoAspectRatio(
//                   //         (scrnheight / scrnwidth).toString());
//                   //   }
//                   // },
//                 ),
//               ),
//               AnimatedOpacity(
//                 opacity: show ? 1 : 0,
//                 duration: Duration(milliseconds: 300),
//                 child: Visibility(
//                   visible: show,
//                   child: Stack(
//                     children: [
//                       Positioned(
//                         left: 0,
//                         right: 0,
//                         bottom: 0,
//                         // top: 0,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           mainAxisSize: MainAxisSize.max,
//                           children: [
//                             IconButton(
//                                 icon: isPlaying
//                                     ? Icon(
//                                         Icons.pause_circle_outline,
//                                         // size: scrnwidth * .05,
//                                       )
//                                     : Icon(Icons.play_circle_outline),
//                                 onPressed: () => {playOrPauseVideo()}),
//                             Expanded(
//                               flex: 5,
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 mainAxisSize: MainAxisSize.max,
//                                 children: [
//                                   Text(_videoViewController.getPosition()
//                                       .toString()
//                                       .replaceRange(
//                                           _videoViewController.position
//                                               .toString()
//                                               .lastIndexOf('.'),
//                                           _videoViewController.position
//                                               .toString()
//                                               .length,
//                                           '')),
//                                   Expanded(
//                                     child: SliderTheme(
//                                       data: SliderTheme.of(context).copyWith(
//                                           thumbColor: Colors.pink.shade400,
//                                           activeTrackColor: Colors.white,
//                                           inactiveTrackColor: Colors.white60,
//                                           thumbShape: RoundSliderThumbShape(),
//                                           tickMarkShape:
//                                               RoundSliderTickMarkShape(),
//                                           valueIndicatorColor: Colors.white38,
//                                           overlayColor: Colors.pink.shade400
//                                               .withOpacity(.3)),
//                                       child: Slider(
//                                         value: sliderValue,
//                                         divisions: 10000,
//                                         label: _videoViewController.position
//                                             .toString()
//                                             .replaceRange(
//                                                 _videoViewController.position
//                                                     .toString()
//                                                     .lastIndexOf('.'),
//                                                 _videoViewController.position
//                                                     .toString()
//                                                     .length,
//                                                 ''),
//                                         // inactiveColor: Colors.black54,

//                                         min: 0.0,
//                                         max: _videoViewController.duration ==
//                                                 null
//                                             ? (sliderValue + 1)
//                                             : _videoViewController
//                                                 .duration.inSeconds
//                                                 .toDouble(),
//                                         onChanged: (progress) {
//                                           print(progress);
//                                           setState(() {
//                                             sliderValue =
//                                                 progress.floor().toDouble();
//                                           });
//                                           //convert to Milliseconds since VLC requires MS to set time
//                                           _videoViewController.setTime(
//                                               sliderValue.toInt() * 1000);
//                                         },
//                                       ),
//                                     ),
//                                   ),
//                                   Text(_videoViewController.duration
//                                       .toString()
//                                       .replaceRange(
//                                           _videoViewController.duration
//                                               .toString()
//                                               .lastIndexOf('.'),
//                                           _videoViewController.duration
//                                               .toString()
//                                               .length,
//                                           '  ')),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

//                       // Row(
//                       //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       //   mainAxisSize: MainAxisSize.max,
//                       //   children: [
//                       //     Text("Volume Level"),
//                       //     Slider(
//                       //       min: 0,
//                       //       max: 100,
//                       //       value: volumeValue,
//                       //       onChanged: (value) {
//                       //         setState(() {
//                       //           volumeValue = value;
//                       //         });
//                       //         _videoViewController.setVolume(volumeValue.toInt());
//                       //       },
//                       //     ),
//                       //   ],
//                       // ),

//                       Center(
//                         child: Row(
//                           children: [
//                             FlatButton(
//                                 child: Text("+speed"),
//                                 onPressed: () =>
//                                     _videoViewController.setPlaybackSpeed(2.0)),
//                             FlatButton(
//                                 child: Text("Normal"),
//                                 onPressed: () =>
//                                     _videoViewController.setPlaybackSpeed(1)),
//                             FlatButton(
//                                 child: Text("-speed"),
//                                 onPressed: () =>
//                                     _videoViewController.setPlaybackSpeed(0.5)),
//                           ],
//                         ),
//                       ),
//                       Divider(height: 1),
//                       Container(
//                         padding: EdgeInsets.all(8.0),
//                         child: Column(
//                           children: [
//                             Text("position=" +
//                                 _videoViewController.position.inSeconds
//                                     .toString() +
//                                 ", duration=" +
//                                 _videoViewController.duration.inSeconds
//                                     .toString() +
//                                 ", speed=" +
//                                 _videoViewController.playbackSpeed.toString()),
//                             Text("ratio=" +
//                                 _videoViewController.aspectRatio.toString()),
//                             Text("size=" +
//                                 _videoViewController.size.width.toString() +
//                                 "x" +
//                                 _videoViewController.size.height.toString()),
//                             Text("state=" +
//                                 _videoViewController.playingState.toString()),
//                           ],
//                         ),
//                       ),
//                       Row(
//                         mainAxisSize: MainAxisSize.max,
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           RaisedButton(
//                             child: Text('Get Subtitle Tracks'),
//                             onPressed: () {
//                               _getSubtitleTracks();
//                             },
//                           ),
//                           RaisedButton(
//                             child: Text('Get Audio Tracks'),
//                             onPressed: () {
//                               _getAudioTracks();
//                             },
//                           )
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           )
//               // : Center(
//               //     child: CircularProgressIndicator(),
//               //   )
//               ;
//         },
//       ),
//     );
//   }

//   void playOrPauseVideo() {
//     String state = _videoViewController.playingState.toString();

//     if (state == "PlayingState.PLAYING") {
//       _videoViewController.pause();
//       setState(() {
//         isPlaying = false;
//       });
//     } else {
//       _videoViewController.play();
//       setState(() {
//         isPlaying = true;
//       });
//     }
//   }

//   void _getSubtitleTracks() async {
//     if (_videoViewController.playingState.toString() != "PlayingState.PLAYING")
//       return;

//     Map<dynamic, dynamic> subtitleTracks =
//         await _videoViewController.getSpuTracks();
//     //
//     if (subtitleTracks != null && subtitleTracks.length > 0) {
//       int selectedSubId = await showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return BlurredDialog(
//             height: scrnheight * .7,
//             width: scrnwidth * .6,
//             child: Container(
//               // width: double.maxFinite,
//               // height: 250,
//               child: Column(
//                 children: [
//                   Center(
//                     child: Text(
//                       "Select Subtitle",
//                       textScaleFactor: 1.4,
//                     ),
//                   ),
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: subtitleTracks.keys.length + 1,
//                       itemBuilder: (context, index) {
//                         return ListTile(
//                           title: Text(
//                             index < subtitleTracks.keys.length
//                                 ? subtitleTracks.values
//                                     .elementAt(index)
//                                     .toString()
//                                 : 'Disable',
//                           ),
//                           onTap: () {
//                             Navigator.pop(
//                               context,
//                               index < subtitleTracks.keys.length
//                                   ? subtitleTracks.keys.elementAt(index)
//                                   : -1,
//                             );
//                           },
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       );
//       if (selectedSubId != null)
//         await _videoViewController.setSpuTrack(selectedSubId);
//     }
//   }

//   void _getAudioTracks() async {
//     if (_videoViewController.playingState.toString() != "PlayingState.PLAYING")
//       return;

//     Map<dynamic, dynamic> audioTracks =
//         await _videoViewController.getAudioTracks();
//     //
//     if (audioTracks != null && audioTracks.length > 0) {
//       int selectedAudioTrackId = await showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return BlurredDialog(
//             height: scrnheight * .7,
//             width: scrnwidth * .6,
//             child: Container(
//               // width: double.maxFinite,
//               // height: 250,
//               child: Column(
//                 children: [
//                   Center(
//                     child: Text(
//                       "Select Audio",
//                       textScaleFactor: 1.4,
//                     ),
//                   ),
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: audioTracks.keys.length + 1,
//                       itemBuilder: (context, index) {
//                         return ListTile(
//                           title: Text(
//                             index < audioTracks.keys.length
//                                 ? audioTracks.values.elementAt(index).toString()
//                                 : 'Disable',
//                           ),
//                           onTap: () {
//                             Navigator.pop(
//                               context,
//                               index < audioTracks.keys.length
//                                   ? audioTracks.keys.elementAt(index)
//                                   : -1,
//                             );
//                           },
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       );
//       if (selectedAudioTrackId != null)
//         await _videoViewController.setAudioTrack(selectedAudioTrackId);
//     }
//   }
// }
