import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class SettingsService {
  static const String settingsFileName = 'settings.json';

  Future<File> _getSettingsFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$settingsFileName';
    return File(path);
  }

  Future<Map<String, dynamic>> readSettings() async {
    final settings = {
      "notification_dictionary_screen": true,
      "notification_story_screen": true
    };
    try {
      final file = await _getSettingsFile();
      if (file.existsSync()) {
        final contents = await file.readAsString();
        return jsonDecode(contents);
      } else {
        writeSettings(settings);
        return settings;
      }
    } catch (e) {
      return {};
    }
  }

  Future<void> writeSettings(Map<String, dynamic> settings) async {
    final file = await _getSettingsFile();
    await file.writeAsString(jsonEncode(settings));
  }

}