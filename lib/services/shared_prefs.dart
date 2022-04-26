import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const seenTourStr = 'seenTour';

  Future<bool?> seenTour() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(seenTourStr)??false;
  }

  Future<bool?> setSeenTour() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool(seenTourStr,true);
  }

}
