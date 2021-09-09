import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splayer/BackEnd/Model/videoFolder.dart';
import 'package:splayer/BackEnd/Provider/ListOfFoldersProvider.dart';
import 'package:splayer/main.dart';

import '../../GlobalVar.dart';
import 'folder_video_list_screen.dart';

class ListOfFolderProviderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // context.read<ListOfFoldersProvider>().getVideoFolders();
    var listOfFolders = Provider.of<ListOfFoldersProvider>(context);
    return Scaffold(
      key: ScaffoldKeys.folderListPageScaffoldKey,
      body: RefreshIndicator(
        onRefresh: () async {
          // await context.read<ListOfFoldersProvider>().getVideoFolders();
          listOfFolders.getVideoFolders();
        },
        child: Container(
          // child: Consumer<ListOfFoldersProvider>(
          //   builder: (context, provider, child) => ListView.builder(
          //     itemCount: provider.listofVideoFolder.length,
          //     itemBuilder: (context, index) {
          //       return VideoTile(
          //         videoFolder: provider.listofVideoFolder[index],
          //       );
          //     },
          //   ),
          // ),

          child: FutureBuilder<List<VideoFolder>>(
            future: ListOfFolders.getVideoFolders(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return VideoTile(
                        videoFolder: snapshot.data![index],
                      );
                    },
                  );
                } else {
                  Center(
                    child: Text("There are no Video"),
                  );
                }
              } else if (snapshot.hasError) {
                return Center(
                  child: Icon(Icons.error),
                );
              }

              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }
}

class VideoTile extends StatelessWidget {
  const VideoTile({
    Key? key,
    required this.videoFolder,
  }) : super(key: key);
  final VideoFolder videoFolder;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white10, borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => FoldersVideos(
                    locationString: videoFolder.path,
                    videoList: videoFolder.insidePaths),
              ));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              Icon(
                Icons.folder,
                size: 50,
                color: Colors.white70,
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      videoFolder.name,
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      videoFolder.path,
                      style: TextStyle(color: Colors.white24),
                    )
                  ],
                ),
              ),
              Text(videoFolder.insidePaths.length.toString())
            ],
          ),
        ),
      ),
    );
  }
}

// Text(provider.folderList[index].replaceRange(
//                     0, provider.folderList[index].lastIndexOf('/') + 1, ''))
