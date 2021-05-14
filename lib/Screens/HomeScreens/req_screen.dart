import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:splayer/BackEnd/Provider/storageProvider.dart';

class ReqPermission extends StatelessWidget {
  const ReqPermission({
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
