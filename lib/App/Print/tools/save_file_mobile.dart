///Dart import
library;

import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
// import 'package:permission_handler/permission_handler.dart';

class FileSaveHelper {
  static Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
    String? path;
    if (Platform.isAndroid) {
      final Directory? directory = await getExternalStorageDirectory();
      if (directory != null) {
        path = directory.path;
      }
    } else if (Platform.isIOS || Platform.isLinux || Platform.isWindows) {
      final Directory directory = await getApplicationSupportDirectory();
      path = directory.path;
    } else {
      path = await PathProviderPlatform.instance.getApplicationSupportPath();
    }

    final File file = File(Platform.isWindows ? '$path\\$fileName' : '$path/$fileName');

    await file.writeAsBytes(bytes, flush: true);

    if (Platform.isAndroid || Platform.isIOS) {
      try {
        await file.writeAsBytes(bytes);
        OpenFile.open(file.path);
        //  print('$path/$fileName');
      } catch (e) {
        // print(e);
        throw Exception(e);
      }
    } else if (Platform.isWindows) {
      await Process.run('start', <String>['$path\\$fileName'], runInShell: true);
    } else if (Platform.isMacOS) {
      await Process.run('open', <String>['$path/$fileName'], runInShell: true);
    } else if (Platform.isLinux) {
      await Process.run('xdg-open', <String>['$path/$fileName'], runInShell: true);
    }
  }
}
