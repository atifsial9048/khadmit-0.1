import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/locale_provider.dart';
import '../../core/constants/app_strings.dart';

extension LocalizedBuildContext on BuildContext {
  String tr(String key) {
    final locale = watch<LocaleProvider>().languageCode;
    return AppStrings.get(key, locale);
  }

  String trStatic(String key) {
    final locale = read<LocaleProvider>().languageCode;
    return AppStrings.get(key, locale);
  }

  bool get isUrdu => watch<LocaleProvider>().isUrdu;
  TextDirection get textDir => isUrdu ? TextDirection.rtl : TextDirection.ltr;
}
