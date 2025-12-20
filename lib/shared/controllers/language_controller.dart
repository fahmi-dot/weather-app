import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController {
  final SharedPreferences prefs;
  final String _key = 'app_language';

  LanguageController({required this.prefs});

  Rx<Locale> locale = Locale('en', 'US').obs;

  @override
  void onInit() {
    super.onInit();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    if (!prefs.containsKey(_key)) {
      await _saveLanguage(locale.value.toLanguageTag());
    }

    final value = prefs.getString(_key);

    if (value == 'en-US') {
      locale.value = Locale('en', 'US');
    } else {
      locale.value = Locale('id', 'ID');
    }
  }

  Future<void> _saveLanguage(String languageTag) async {
    await prefs.setString(_key, languageTag);
  }

  Future<void> setLanguage(Locale loc) async {
    locale.value = loc;
    await _saveLanguage(loc.toLanguageTag());
  }

  void toggle() {
    if (locale.value != Locale('en', 'US')) {
      setLanguage(Locale('en', 'US'));
    } else {
      setLanguage(Locale('id', 'ID'));
    }
  }
}
