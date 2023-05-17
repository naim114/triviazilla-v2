class AppSettingsModel {
  final String applicationName;
  final String logoFaviconPath;
  final String logoFaviconURL;
  final String logoMainPath;
  final String logoMainURL;
  final String urlCopyright;
  final String urlPrivacyPolicy;
  final String urlTermCondition;

  AppSettingsModel({
    required this.applicationName,
    required this.logoFaviconPath,
    required this.logoFaviconURL,
    required this.logoMainPath,
    required this.logoMainURL,
    required this.urlCopyright,
    required this.urlPrivacyPolicy,
    required this.urlTermCondition,
  });

  @override
  String toString() {
    return 'AppSettingsModel(applicationName: $applicationName, logoFaviconPath: $logoFaviconPath, logoFaviconURL: $logoFaviconURL, logoMainPath: $logoMainPath, logoMainURL: $logoMainURL, urlCopyright: $urlCopyright, urlPrivacyPolicy: $urlPrivacyPolicy, urlTermCondition: $urlTermCondition)';
  }

  Map<String, Object?> toJson() {
    return {
      'applicationName': applicationName,
      'logoFaviconPath': logoFaviconPath,
      'logoFaviconURL': logoFaviconURL,
      'logoMainPath': logoMainPath,
      'logoMainURL': logoMainURL,
      'urlCopyright': urlCopyright,
      'urlPrivacyPolicy': urlPrivacyPolicy,
      'urlTermCondition': urlTermCondition,
    };
  }

  factory AppSettingsModel.fromMap(Map<String, dynamic> map) {
    var appsettings = AppSettingsModel(
      applicationName: map['applicationName'],
      logoFaviconPath: map['logoFaviconPath'],
      logoFaviconURL: map['logoFaviconURL'],
      logoMainPath: map['logoMainPath'],
      logoMainURL: map['logoMainURL'],
      urlCopyright: map['urlCopyright'],
      urlPrivacyPolicy: map['urlPrivacyPolicy'],
      urlTermCondition: map['urlTermCondition'],
    );

    return appsettings;
  }
}
