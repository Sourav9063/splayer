import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:splayer/BackEnd/Model/videoFolder.dart';
import 'package:splayer/GlobalVar.dart';

class ListOfFoldersProvider extends ChangeNotifier {
  List<String> _allVideoDir = [];
  // List<String> _folderList = [];
  List<VideoFolder> _listVideoFolder = [];
  List<String> get allVideoDir => _allVideoDir;
  set allVideoDir(List<String> videoList) {
    print("All video updated");
    _allVideoDir = videoList;
    notifyListeners();
  }

  // List<String> get folderList => _folderList;
  // set folderList(List<String> folderList) {
  //   _folderList = folderList;
  //   print("Folder updated");
  //   notifyListeners();
  // }

  List<VideoFolder> get listofVideoFolder => _listVideoFolder;

  void addFolder(List<String> folders) {
    _listVideoFolder = folders.map((folderList) {
      List<String> insideVideoList = [];
      insideVideoList = _allVideoDir
          .where((element) => element.startsWith(folderList))
          .toList();

      return VideoFolder(
          name: folderList.replaceRange(0, folderList.lastIndexOf('/') + 1, ''),
          path: folderList,
          insidePaths: insideVideoList);
    }).toList();

    notifyListeners();
  }

  Future<void> getVideoFolders() async {
    print("GetVideos called");
    List<String> _videoList = [];
    List<String> _folderListTmp = [];
    try {
      Directory dir = Directory('/storage/emulated/0/');
      Directory dirSD = Directory("/sdcard/");

      List<String> firstFolders =
          await dir.list().map((FileSystemEntity event) => event.path).toList();
      //taking all entry level folders from phon
      if (await dirSD.exists()) {
        firstFolders.addAll(await dirSD
            .list()
            .map((FileSystemEntity event) => event.path)
            .toList());
      }
      //taking all entry level folders from sd card
      firstFolders.removeWhere((element) => element.endsWith('Android'));
      // firstFolders.removeWhere((element) => element.contains('.'));
      // removing "Android" Folder
      _videoList.addAll(firstFolders
          .where((item) =>
              item.endsWith(".mp4") ||
              item.endsWith(".avi") ||
              item.endsWith(".mkv") ||
              item.endsWith(".MOV") ||
              item.endsWith(".m4v") ||
              item.endsWith(".webm"))
          .toList());

      for (String path in firstFolders) {
        //for each folder it needs to traverse
        Directory tmpDir = Directory(path);
        if (await tmpDir.exists()) {
          // print(path);
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
            _videoList.add(element);
          });
        }
      }
      Set<String> foldernameUnique = {};

      for (String loc in _videoList) {
        loc = loc.replaceRange(loc.lastIndexOf('/'), loc.length, '');

        foldernameUnique.add(loc);
        // addFolder(loc);
      }
      _folderListTmp.addAll(foldernameUnique);
      // _folderListTmp.sort();
      addFolder(_folderListTmp);
      // folderList = _folderListTmp;
      allVideoDir = _videoList;
    } catch (e) {
      ScaffoldMessenger.of(
              ScaffoldKeys.folderListPageScaffoldKey.currentContext!)
          .showSnackBar(
        SnackBar(
          content: const Text('Something Went Wrong'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class ListOfFolders {
  static Future<List<VideoFolder>> getVideoFolders() async {
    print("GetVideos called");
    List<String> _videoList = [];
    List<String> _folderListTmp = [];
    List<VideoFolder> _listVideoFolder = [];
    try {
      Directory dir = Directory('/storage/emulated/0/');
      Directory dirSD = Directory("/sdcard/");

      List<String> firstFolders =
          await dir.list().map((FileSystemEntity event) => event.path).toList();
      //taking all entry level folders from phon
      if (await dirSD.exists()) {
        firstFolders.addAll(await dirSD
            .list()
            .map((FileSystemEntity event) => event.path)
            .toList());
      }
      //taking all entry level folders from sd card
      firstFolders.removeWhere((element) => element.endsWith('Android'));
      // firstFolders.removeWhere((element) => element.contains('.'));
      // removing "Android" Folder
      _videoList.addAll(firstFolders
          .where((item) =>
              item.endsWith(".mp4") ||
              item.endsWith(".avi") ||
              item.endsWith(".mkv") ||
              item.endsWith(".MOV") ||
              item.endsWith(".m4v") ||
              item.endsWith(".webm"))
          .toList());

      for (String path in firstFolders) {
        //for each folder it needs to traverse
        Directory tmpDir = Directory(path);
        if (await tmpDir.exists()) {
          // print(path);
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
            _videoList.add(element);
          });
        }
      }
      Set<String> foldernameUnique = {};

      for (String loc in _videoList) {
        loc = loc.replaceRange(loc.lastIndexOf('/'), loc.length, '');

        foldernameUnique.add(loc);
        // addFolder(loc);
      }
      _folderListTmp.addAll(foldernameUnique);

      _listVideoFolder = _folderListTmp.map((folderList) {
        List<String> insideVideoList = [];
        insideVideoList = _videoList
            .where((element) => element.startsWith(folderList))
            .toList();

        return VideoFolder(
            name:
                folderList.replaceRange(0, folderList.lastIndexOf('/') + 1, ''),
            path: folderList,
            insidePaths: insideVideoList);
      }).toList();
    } catch (e) {
      ScaffoldMessenger.of(
              ScaffoldKeys.folderListPageScaffoldKey.currentContext!)
          .showSnackBar(
        SnackBar(
          content: const Text('Something Went Wrong'),
          backgroundColor: Colors.red,
        ),
      );
      throw (e);
    }

    return _listVideoFolder;
  }
}
