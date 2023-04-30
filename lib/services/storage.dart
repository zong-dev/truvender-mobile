import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageUtil {
  Future<bool> hasKey(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }

  setStrVal(String key, String val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, val);
  }

  getStrVal(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? '';
  }

  setNumVal(String key, double val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(key, val);
  }

  getNumVal(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key) ?? 0;
  }

  setBoolVal(String key, bool val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, val);
  }

  getBoolVal(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  deleteKey(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }

  empty() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }
}


class SecureStorage {

  final _secureStorage = const FlutterSecureStorage();

  Future setValue(String key, String value) async {
    var writeData = await _secureStorage.write(key: key, value: value);
    return writeData;
  }

  Future getValue(String key) async {
    var readData = await _secureStorage.read(key: key);
    return readData;
  }

  Future deleteValue(String key) async {
    var deleteData = await _secureStorage.delete(key: key);
    return deleteData;
  }
}
