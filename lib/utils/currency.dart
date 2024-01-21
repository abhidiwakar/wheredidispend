import 'dart:convert';
import 'dart:io';

import 'package:currency_picker/currency_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Currency?> getCurrency() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final currencyJson = prefs.getString("currency");
  final currency = currencyJson != null
      ? Currency.from(json: jsonDecode(currencyJson))
      : null;

  return currency ??
      CurrencyService().findByCode(NumberFormat.simpleCurrency(
        locale: Platform.localeName,
      ).currencyName);
}
