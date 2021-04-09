import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:permission_handler/permission_handler.dart';

import 'package:splayer/GlobalVar.dart';
import 'package:splayer/Screens/GivenVlcpage.dart';
import 'package:splayer/Screens/player.dart';
import 'package:splayer/Screens/vlcPlayer.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'Screens/VlcNewPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Splayer',
      theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Color(0xff060621),
          accentColor: Color(0xff08f0f0),
          appBarTheme: AppBarTheme().copyWith(color: Colors.pinkAccent[400])),
      home: LocalFile(),
    );
  }
}

class LocalFile extends StatefulWidget {
  const LocalFile({Key key}) : super(key: key);

  @override
  _LocalFileState createState() => _LocalFileState();
}

class _LocalFileState extends State<LocalFile> {
  List videoList = [];
  List<String> folderNameList = [];
  bool permission = false;
  List<String> allAccessibleFolder = [];

  Future<void> getList() async {
    print("GetList called");
    // setState(() {
    //   loading = true;
    // });

    try {
      Directory dir = Directory('/storage/emulated/0/');
      permission = true;
      videoList = await dir
          .list(recursive: false, followLinks: false)
          .map((item) {
            return item.path;
          })
          .where((item) =>
              item.endsWith(".mp4") ||
              item.endsWith(".avi") ||
              item.endsWith(".mkv") ||
              item.endsWith(".MOV") ||
              item.endsWith(".m4v") ||
              item.endsWith(".webm"))
          .toList();
      allAccessibleFolder =
          await dir.list().map((FileSystemEntity event) => event.path).toList();

      // allAccessibleFolder.forEach((e) => print(e));
      allAccessibleFolder.removeWhere((element) => element.endsWith('Android'));

      // allAccessibleFolder.forEach((e) => print(e));
      allAccessibleFolder.forEach((element) async {
        // print(loadingFolder);
        try {
          Directory tmpDir = Directory(element);

          List<String> tmp = await tmpDir
              .list(recursive: true, followLinks: false)
              .map((e) => e.path)
              .where((item) =>
                  item.endsWith(".mp4") ||
                  item.endsWith(".avi") ||
                  item.endsWith(".mkv") ||
                  item.endsWith(".MOV") ||
                  item.endsWith(".m4v") ||
                  item.endsWith(".webm"))
              .toList();
          tmp.forEach((element) {
            // print(element);
            videoList.add(element);
            // print(videoList.length);
          });
        } catch (e) {
          // print(e);
        } finally {
          videoList.sort();
          Set<String> foldername = {};
          for (String loc in videoList) {
            loc = loc.replaceRange(loc.lastIndexOf('/'), loc.length, '');

            foldername.add(loc);
          }
          setState(() {
            folderNameList = foldername.toList();
            folderNameList.sort();
          });
        }
      });
    } catch (e) {
      print(e);
      permission = false;
    }
  }

  @override
  void initState() {
    super.initState();

    getList();
  }

  @override
  Widget build(BuildContext context) {
    mediaQuery = MediaQuery.of(context);
    scrnheight = mediaQuery.size.height;
    scrnwidth = mediaQuery.size.width;
    // print('Update');
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.all(3),
          child: Text("Splayer"),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.link),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => LinkPage()));
              })
        ],
      ),
      body: permission
          ? RefreshIndicator(
              onRefresh: getList,
              child: AnimationLimiter(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  itemCount: folderNameList.length,
                  itemBuilder: (context, index) {
                    return AnimationConfiguration.staggeredList(
                      duration: const Duration(milliseconds: 500),
                      position: index,
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FoldersVideos(
                                        locationString: folderNameList[index]),
                                  ));
                            },
                            title: Text(folderNameList[index].replaceRange(
                                0,
                                folderNameList[index].lastIndexOf('/') + 1,
                                '')),
                            leading: Icon(Icons.folder),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(child: Text("Storage permission needed")),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      await Permission.storage.request();

                      if (await Permission.storage.isGranted) {
                        getList();
                        setState(() {
                          permission = true;
                        });
                      }
                    },
                    child: Text("ALLOW"),
                  ),
                ),
              ],
            ),
    );
  }
}

class LinkPage extends StatelessWidget {
  const LinkPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String link = "Can't be null";
    TextEditingController controller;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: controller,
              onChanged: (value) {
                link = value;
              },
              minLines: 2,
              maxLines: 6,
              decoration: InputDecoration(
                  hintText: "Paste link",
                  labelText: "Video Link",
                  prefixIcon: Icon(Icons.link)),
            ),
            RaisedButton(
              onPressed: link == null
                  ? null
                  : () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VideoPlayerScreen(link: link),
                          ));
                    },
              child: Text("PLAY"),
            )
          ],
        ),
      ),
    );
  }
}

class FoldersVideos extends StatelessWidget {
  const FoldersVideos({Key key, this.locationString}) : super(key: key);
  final String locationString;

  @override
  Widget build(BuildContext context) {
    Directory dir = Directory(locationString + '/');

    List<String> videoList = dir
        .listSync(recursive: false, followLinks: false)
        .map((item) => item.path)
        .where((item) =>
            item.endsWith(".mp4") ||
            item.endsWith(".avi") ||
            item.endsWith(".mkv") ||
            item.endsWith(".MOV") ||
            item.endsWith(".m4v") ||
            item.endsWith(".webm"))
        .toList();
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
                          trailing: FutureBuilder(
                            future: VideoThumbnail.thumbnailData(
                              video: videoList[index],
                              // thumbnailPath: '/storage/emulated/0/temp',
                              imageFormat: ImageFormat.JPEG,
                              maxWidth: 300,
                              quality: 25,

                              timeMs: 100000,
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                // return Image.file(File(snapshot.data));
                                return Image.memory(snapshot.data);
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
