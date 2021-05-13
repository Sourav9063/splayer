import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:splayer/GlobalVar.dart';

class ListOfFoldersProvider extends ChangeNotifier {
  List<String> _folderList = [];

  bool _error = false;

  bool get error => _error;
  set error(bool isError) {
    _error = isError;
    notifyListeners();
  }

  List<String> get folderList => _folderList;
  set folderList(List<String> folderList) {
    _folderList = folderList;
    notifyListeners();
  }

  void addFolder(String folder) {
    _folderList.add(folder);
    notifyListeners();
  }
}

class ListOfFolders {
  List<String> _videoList = [];
  List<String> _folderList = [];

  Future<List<String>> getFolders() async {
    try {
      Directory dir = Directory('/storage/emulated/0/');
      Directory dirSD = Directory("/sdcard/");

      List<String> firstFolders =
          await dir.list().map((FileSystemEntity event) => event.path).toList();

      firstFolders.addAll(await dirSD
          .list()
          .map((FileSystemEntity event) => event.path)
          .toList());
      firstFolders.removeWhere((element) => element.endsWith('Android'));

      firstFolders.forEach((path) async {
        Directory tmpDir = Directory(path);
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
          _videoList.add(element);
          // print(videoList.length);
        });
        // notifyListeners();
        Set<String> foldername = {};

        for (String loc in _videoList) {
          loc = loc.replaceRange(loc.lastIndexOf('/'), loc.length, '');

          foldername.add(loc);
          // addFolder(loc);
        }
        _folderList = foldername.toList();

        print(_folderList);
      });
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

    return _folderList;
  }
}
