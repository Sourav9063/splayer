import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../VlcNewPage.dart';
import '../player.dart';

class FoldersVideos extends StatelessWidget {
  const FoldersVideos(
      {Key? key, required this.locationString, required this.videoList})
      : super(key: key);
  final String locationString;
  final List<String> videoList;

  @override
  Widget build(BuildContext context) {
    // Directory dir = Directory(locationString + '/');

    // List<String> videoList = dir
    //     .listSync(recursive: false, followLinks: false)
    //     .map((item) => item.path)
    //     .where((item) =>
    //         item.endsWith(".mp4") ||
    //         item.endsWith(".avi") ||
    //         item.endsWith(".mkv") ||
    //         item.endsWith(".MOV") ||
    //         item.endsWith(".m4v") ||
    //         item.endsWith(".webm"))
    //     .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(locationString.replaceRange(
            0, locationString.lastIndexOf('/') + 1, '')),
      ),
      body: Column(
        children: [
          Text(locationString + "/"),
          Expanded(
            child: ListView.builder(
                // cacheExtent: 10000,
                itemCount: videoList.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.white10,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                          onLongPress: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        // VlcPage(link: videoList[index]),
                                        VlcNewPlayer(
                                          location: videoList[index],
                                        )));
                          },
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      VideoPlayerScreen(link: videoList[index]),
                                ));
                          },
                          title: Text(videoList[index].replaceRange(
                              0, videoList[index].lastIndexOf('/') + 1, '')),
                          // trailing: Icon(Icons.video_library),
                          trailing: FutureBuilder<Uint8List?>(
                            future: VideoThumbnail.thumbnailData(
                              video: videoList[index],
                              // thumbnailPath: '/storage/emulated/0/temp',
                              imageFormat: ImageFormat.JPEG,
                              maxWidth: 300,
                              quality: 25,

                              timeMs: 10000,
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                // return Image.file(File(snapshot.data));

                                return Image.memory(snapshot.data!);
                              } else if (snapshot.hasError)
                                return Container(
                                  height: 1,
                                  width: 1,
                                );
                              return CircularProgressIndicator(
                                strokeWidth: 1,
                              );
                            },
                          )),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
