import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class JsonStorageService {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _localFile(String fileName) async {
    final path = await _localPath;
    return File('$path/$fileName');
  }

  Future<void> writeData(String fileName, Map<String, dynamic> data) async {
    final file = await _localFile(fileName);
    final jsonString = json.encode(data);
    await file.writeAsString(jsonString);
  }

  Future<Map<String, dynamic>?> readData(String fileName) async {
    try {
      final file = await _localFile(fileName);
      final contents = await file.readAsString();
      return json.decode(contents) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }
}