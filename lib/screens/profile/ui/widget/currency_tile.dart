import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyTile extends StatefulWidget {
  const CurrencyTile({super.key});

  @override
  State<CurrencyTile> createState() => _CurrencyTileState();
}

class _CurrencyTileState extends State<CurrencyTile> {
  Currency? _currencyString;

  _getCurrencyString({SharedPreferences? prefs}) async {
    try {
      prefs ??= await SharedPreferences.getInstance();
      final currencyJson = prefs.getString("currency");
      final currency = currencyJson != null
          ? Currency.from(json: jsonDecode(currencyJson))
          : null;

      setState(() {
        _currencyString = currency;
      });
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrencyString();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.attach_money),
      title: const Text("Currency"),
      subtitle: const Text("Change your currency."),
      trailing: _currencyString != null
          ? Text(
              CurrencyUtils.currencyToEmoji(_currencyString!),
              style: const TextStyle(fontSize: 24),
            )
          : null,
      onTap: () {
        final List<String> currencies = [];
        if (_currencyString != null) {
          currencies.add(_currencyString!.code);
        }
        final localCurrency =
            NumberFormat.simpleCurrency(locale: Platform.localeName)
                .currencyName;
        if (localCurrency != null) {
          if (!currencies.contains(localCurrency)) {
            currencies.add(localCurrency);
          }
        }

        showCurrencyPicker(
          context: context,
          favorite: currencies,
          showFlag: true,
          showCurrencyName: true,
          showCurrencyCode: true,
          onSelect: (Currency currency) async {
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            prefs.setString("currency", jsonEncode(currency.toJson()));
            _getCurrencyString(prefs: prefs);
          },
        );
      },
    );
  }
}
