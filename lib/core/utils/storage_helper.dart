import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageHelper {

final storage = FlutterSecureStorage(aOptions: AndroidOptions(
  enforceBiometrics: true
));

Future saveToken(String token) async{
  await storage.write(key: "accessToken", value: token);
}
  
  Future<String?> getToken() async{
    return await storage.read(key: "accessToken")??"";
  }
Future removeToken() async{
  return await storage.delete(key: "accessToken");
}
}