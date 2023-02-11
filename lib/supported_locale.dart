enum SupportedLocale { en, bn }

extension SupportedLocalExtension on SupportedLocale {

  String get code =>toString().split('.').last;

  String get name {
    String name;
    switch (this) {
      case SupportedLocale.en:
        name = 'English';
        break;
      case SupportedLocale.bn:
        name = 'Bengali';
        break;
    }

    return name;
  }

}