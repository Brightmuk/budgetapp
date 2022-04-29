import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const seenTourStr = 'seenTour';
  static const currency = 'currency';

  Future<bool?> seenTour() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(seenTourStr)??false;
  }

  Future<bool?> setSeenTour() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool(seenTourStr,true);
  }

  Future<String?> getCurrency()async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(currency)??'KES';
  }

  Future<bool?> setCurrency(String currencyVal)async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(currency, currencyVal);
  }

}
