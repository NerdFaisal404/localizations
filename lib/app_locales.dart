import 'dart:ui';

class AppLocales {
  static Locale english = const Locale('en', 'US');
  static Locale arabic = const Locale('ar', 'SA');
  static Locale spanish = const Locale('es', 'ES');
  static Locale hindi = const Locale('hi', 'IN');
  static Locale turkish = const Locale('tr', 'TR');

  static List<Locale> supportedLocales = [
    english,
    arabic,
    turkish,
    spanish,
    hindi,
  ];

  /// Returns a formatted version of language
  /// if nothing is present than it will pass the locale to a string
  static String formattedLanguageName(Locale locale) {
    if (locale == english) {
      return 'English';
    } else if (locale == arabic) {
      return 'عربي';
    } else if (locale == spanish) {
      return 'Español';
    } else if (locale == hindi) {
      return 'हिन्दी';
    } else if (locale == turkish) {
      return 'Türkçe';
    } else {
      return locale.countryCode.toString();
    }
  }

}
