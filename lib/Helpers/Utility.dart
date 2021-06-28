import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum ProcessingDBDataState { waiting, done }

class Utility {
  final storage = new FlutterSecureStorage();

  Future<bool> checkConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } on SocketException catch (_) {
      return false;
    }
  }

  void signOut() async {
    await storage.deleteAll();
  }

  void signIn(String documentID, String fullName, String userName,
      String password, String role, String defaultCompanyName) async {
    await storage.write(key: "fullName", value: fullName);
    await storage.write(key: "userName", value: userName);
    await storage.write(key: "password", value: password);
    await storage.write(key: "role", value: role);
    await storage.write(key: "defaultCompanyName", value: defaultCompanyName);
  }

  Future<Map<String, String>> getAllStoredData() async {
    return await storage.readAll();
  }

  Future<String?> getStoredDataByKey(String _key) async {
    return await storage.read(key: _key);
  }

  // getTempDirectory() async{
  //   Directory tempDir = await getTemporaryDirectory();
  //   return tempDir.path;
  // }

  // getAppDirectory() async{
  //   Directory appDir = await getApplicationDocumentsDirectory();
  //   return appDir.path;
  // }
}
