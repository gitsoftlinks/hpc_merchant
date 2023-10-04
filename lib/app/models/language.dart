class Language {
  final String languageName, flag, languageCode;

  const Language({required this.flag, required this.languageName, required this.languageCode});

  factory Language.fromJson(Map<String, dynamic> json) => Language(flag: json['flag'] ?? '', languageName: json['languageName'] ?? '', languageCode: json['languageCode'] ?? '');

  @override
  String toString() {
    return 'Language{ flag: $flag, languageName: $languageName,}';
  }

  Map<String, Object> toJson() => {'flag': flag, 'languageName': languageName};

  static const US = Language(flag: '🇬🇧', languageName: 'English', languageCode: 'en-US');
  static const AR = Language(flag: '🇦🇪', languageName: 'Arabic', languageCode: 'ar-AE');

  /// All the countries in the picker list
  static const ALL = <Language>[US, AR];
}
