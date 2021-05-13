import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:splayer/BackEnd/Provider/ListOfFoldersProvider.dart';
import 'package:splayer/BackEnd/Provider/storageProvider.dart';

import '../GlobalVar.dart';
import '../main.dart';

class FolderPageWithProvider extends StatelessWidget {
  FolderPageWithProvider({Key? key}) : super(key: key);

//   @override
//   _FolderPageWithProviderState createState() => _FolderPageWithProviderState();
// }

// class _FolderPageWithProviderState extends State<FolderPageWithProvider> {
  @override
  Widget build(BuildContext context) {
    mediaQuery = MediaQuery.of(context);
    scrnheight = mediaQuery.size.height;
    scrnwidth = mediaQuery.size.width;
    context.read<StorageStatusProvider>().checkPermission();
    return Scaffold(
      key: ScaffoldKeys.folderListPageScaffoldKey,
      // appBar: AppBar(
      //   title: Padding(
      //     padding: EdgeInsets.all(3),
      //     child: Text("Splayer"),
      //   ),
      //   actions: [
      //     IconButton(
      //         icon: Icon(Icons.link),
      //         onPressed: () {
      //           Navigator.push(
      //               context, MaterialPageRoute(builder: (_) => LinkPage()));
      //         })
      //   ],
      // ),
      // body: FutureBuilder<bool>(
      //   future: Permission.storage.isGranted,
      //   builder: (context, snapshot) {
      //     if (snapshot.data == true) {
      //       return ListOfFolderProvider();
      //     } else if (snapshot.data == false) {
      //       return _ReqPermission();
      //     }
      //     return Center(child: CircularProgressIndicator());
      //   },
      // ),

      body: Consumer<StorageStatusProvider>(
        builder: (context, value, child) {
          print(value.permissionStatus);
          if (value.permissionStatus.isGranted)
            return ListOfFolderProvider();
          else if (value.permissionStatus.isPermanentlyDenied) {
            return Container(
              color: Colors.red,
            );
          } else
            return _ReqPermission();
        },
      ),
    );
  }
}

class _ReqPermission extends StatelessWidget {
  const _ReqPermission({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(child: Text("Storage permission is needed")),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () async {
              context.read<StorageStatusProvider>().reqAccess();
            },
            child: Text("ALLOW"),
          ),
        ),
      ],
    );
  }
}

class ListOfFolderProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
