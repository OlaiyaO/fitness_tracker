import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static Future<void> setSliderValues(double value1, double value2, double value3) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('double_value_1', value1);
    await prefs.setDouble('double_value_2', value2);
    await prefs.setDouble('double_value_3', value3);
  }

  static Future<Map<String, double>> getSliderValues() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    double value1 = prefs.getDouble('double_value_1') ?? 1.0;
    double value2 = prefs.getDouble('double_value_2') ?? 2.0;
    double value3 = prefs.getDouble('double_value_3') ?? 5.0;
    return {
      'double_value_1': value1,
      'double_value_2': value2,
      'double_value_3': value3,
    };
  }
}
