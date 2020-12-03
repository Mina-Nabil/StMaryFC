
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Server {
  static String address = "https://stmaryfa.msquare.app/";
  static String _apiToken;
  static FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<String> get token async {
    if( _apiToken == null || _apiToken.isEmpty){
      _apiToken = await _storage.read(key: "token");
    }
    return _apiToken;
  }

  static setToken(String token) async {
      _storage.write(key: "token", value: token);
  }

  static logOut() async {
    _storage.delete(key: "token");
    _apiToken=null;
  }
}


class Utils {
  static String capitalize (String value) {
    return value == "" ? "" : '${value[0].toUpperCase()}${value.substring(1)}';
  }
}
