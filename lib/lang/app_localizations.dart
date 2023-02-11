import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'app_lang_model.dart';

enum supportedLang {
  english,
  bengali,
  arabic,
}

Map<supportedLang, Locale> getLocal = {
  supportedLang.english: Locale("en", ""),
  supportedLang.bengali: Locale("bn", ""),
  supportedLang.arabic: Locale("ar", ""),
};

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  // Helper method to keep the code in the widgets concise
  // Localizations are accessed using an InheritedWidget "of" syntax
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  // Static member to have a simple access to the delegate from the MaterialApp
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static Locale localeResolutionCallback(
      Locale? locale, Iterable<Locale> supportedLocales) {
    for (Locale supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale?.languageCode &&
          supportedLocale.countryCode == locale?.countryCode) {
        return supportedLocale;
      }
    }
    return supportedLocales.first;
  }

  late AppLangModel appLangModel;

  Future<String> loadString(String key, {bool cache = true}) async {
    final ByteData data = await loadData(key);
    // 50 KB of data should take 2-3 ms to parse on a Moto G4, and about 400 μs
    // on a Pixel 4.
    if (data.lengthInBytes < 50 * 1024) {
      return utf8.decode(data.buffer.asUint8List());
    }
    // For strings larger than 50 KB, run the computation in an isolate to
    // avoid causing main thread jank.
    return compute(_utf8decode, data, debugLabel: 'UTF8 decode for "$key"');
  }

  static String _utf8decode(ByteData data) {
    return utf8.decode(data.buffer.asUint8List());
  }

  Future<ByteData> loadData(String key) {
    final Uint8List encoded =
        utf8.encoder.convert(Uri(path: Uri.encodeFull(key)).path);
    final Future<ByteData>? future = ServicesBinding
        .instance.defaultBinaryMessenger
        .send('flutter/assets', encoded.buffer.asByteData())
        ?.then((ByteData? asset) {
      if (asset == null) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorDescription('The asset does not exist or has empty data.'),
        ]);
      }
      return asset;
    });
    if (future == null) {
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorDescription('The asset does not exist or has empty data.'),
      ]);
    }
    return future;
  }

  Future<bool> load() async {
    Directory _appDocumentsDirectory = await getApplicationDocumentsDirectory();
    // Load the language JSON file from the "lang" folder
    var input =
        await File("${_appDocumentsDirectory.path}/${locale.languageCode}.json")
            .readAsString();
    print(json.decode(input));

    appLangModel = AppLangModel.fromMap(json.decode(input));
    return true;
  }

//      Map<String, dynamic> innerJsonMap = json.decode(value.toString());
//      _innerLocalizedStrings = innerJsonMap.map((k, v) => MapEntry(key, v.toString()));

  // This method will be called from every widget which needs a localized text
  AppLangModel translate() {
    return appLangModel;
  }
}

// LocalizationsDelegate is a factory for a set of localized resources
// In this case, the localized strings will be gotten in an AppLocalizations object
class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  // This delegate instance will never change (it doesn't even have fields!)
  // It can provide a constant constructor.
  const _AppLocalizationsDelegate();

  static const List<String> _supportedLanguageCodes = ["en", "bn", "ar"];

  @override
  bool isSupported(Locale locale) {
    // Include all of your supported language codes here
    return _supportedLanguageCodes.contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    String jsonString =
        await rootBundle.loadString('lang/${locale.languageCode}.json');
    Map<String, dynamic> jsonFileContent = json.decode(jsonString);

    Directory _appDocumentsDirectory = await getApplicationDocumentsDirectory();

    File file = new File(
        _appDocumentsDirectory.path + "/" + '${locale.languageCode}.json');
    file.createSync();
    file.writeAsStringSync(json.encode(jsonFileContent));
    // AppLocalizations class is where the JSON loading actually runs
    AppLocalizations localizations = new AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
