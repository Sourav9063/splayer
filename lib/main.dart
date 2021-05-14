import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:splayer/BackEnd/Provider/ListOfFoldersProvider.dart';
import 'package:splayer/BackEnd/Provider/storageProvider.dart';

import 'package:splayer/GlobalVar.dart';
import 'package:splayer/Screens/FolderPageWithProvider.dart';
import 'package:splayer/Screens/player.dart';
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
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => StorageStatusProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => ListOfFoldersProvider(),
          )
        ],
        child: FolderPageWithProvider(),
      ),
    );
  }
}

class LocalFile extends StatefulWidget {
  const LocalFile({Key? key}) : super(key: key);

  @override
  _LocalFileState createState() => _LocalFileState();
}

class _LocalFileState extends State<LocalFile> {
  List<String> videoList = [];
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
      // Directory dir1 = Directory("/sdcard/");
      // dir1.list();
      permission = true;
      // videoList = await dir
      //     .list(recursive: true, followLinks: false)
      //     .map((item) {
      //       return item.path;
      //     })
      //     .where((item) =>
      //         item.endsWith(".mp4") ||
      //         item.endsWith(".avi") ||
      //         item.endsWith(".mkv") ||
      //         item.endsWith(".MOV") ||
      //         item.endsWith(".m4v") ||
      //         item.endsWith(".webm"))
      //     .toList();
      allAccessibleFolder =
          await dir.list().map((FileSystemEntity event) => event.path).toList();

      // allAccessibleFolder.forEach((e) => print(e));
      allAccessibleFolder.removeWhere((element) => element.endsWith('Android'));

      // allAccessibleFolder.forEach((e) => print(e));
      allAccessibleFolder.forEach((element) async {
        // print(element);
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
            setState(() {
              videoList.add(element);
            });

            // print(videoList.length);
          });
        } catch (e) {
          // print(e);
        }
      });
      // videoList.sort();
      Set<String> foldername = {};

      for (String loc in videoList) {
        loc = loc.replaceRange(loc.lastIndexOf('/'), loc.length, '');

        foldername.add(loc);
      }

      setState(() {
        folderNameList = foldername.toList();

        print("Setstate called");
      });
      print(folderNameList);
    } catch (e) {
      print(e);
      setState(() {
        permission = false;
      });
    }
    print(permission);
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
                    print(folderNameList.length);
                    if (folderNameList.length == 0) {
                      return Center(
                        child: Text("There are no videos."),
                      );
                    }
                    return AnimationConfiguration.staggeredList(
                      duration: const Duration(milliseconds: 500),
                      position: index,
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: ListTile(
                            onTap: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) => FoldersVideos(
                              //           locationString: folderNameList[index]),
                              //     ));
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
                Center(child: Text("Storage permission is needed")),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      var storage = await Permission.storage.status;

                      if (storage.isDenied) {
                        await Permission.storage.request();
                      }

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
  const LinkPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String link = "Can't be null";
    TextEditingController? controller;
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
            ElevatedButton(
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

