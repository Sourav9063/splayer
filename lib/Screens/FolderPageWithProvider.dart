import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:splayer/BackEnd/Provider/storageProvider.dart';

import '../GlobalVar.dart';
import '../main.dart';
import 'HomeScreens/list_Of_Videos.dart';
import 'HomeScreens/req_screen.dart';

class FolderPageWithProvider extends StatelessWidget {
  FolderPageWithProvider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    mediaQuery = MediaQuery.of(context);
    scrnheight = mediaQuery.size.height;
    scrnwidth = mediaQuery.size.width;
    context.read<StorageStatusProvider>().checkPermission();
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
      body: Consumer<StorageStatusProvider>(
        builder: (context, value, child) {
          print(value.permissionStatus);
          if (value.permissionStatus.isGranted)
            return ListOfFolderProviderScreen();
          else if (value.permissionStatus.isPermanentlyDenied) {
            return Container(
              color: Colors.red,
            );
          } else
            return ReqPermission();
        },
      ),
    );
  }
}
