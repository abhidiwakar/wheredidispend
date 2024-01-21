import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:currency_picker/currency_picker.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wheredidispend/router/route_constants.dart';
import 'package:wheredidispend/widgets/logo.dart';

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  final remoteConfig = FirebaseRemoteConfig.instance;

  _initCurrency() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString("currency") == null) {
      final currencyName =
          NumberFormat.simpleCurrency(locale: Platform.localeName).currencyName;
      if (currencyName != null) {
        final cur = CurrencyService().findByCode(currencyName);
        if (cur != null) {
          prefs.setString("currency", jsonEncode(cur.toJson()));
        }
      }
    }
  }

  Future<bool> _getConfig() async {
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 30),
      minimumFetchInterval: const Duration(minutes: 1),
    ));
    await remoteConfig.fetchAndActivate();
    return remoteConfig.getBool("update_app");
  }

  @override
  void initState() {
    super.initState();

    FirebaseAnalytics.instance.setCurrentScreen(screenName: 'Init');

    _initCurrency();

    _getConfig().then((value) {
      log("Should update app: $value");
      if (value) {
        log("Update app");
        GoRouter.of(context).go(AppRoute.update.route);
      } else {
        Future.delayed(const Duration(seconds: 1), () {
          FirebaseAuth.instance.currentUser != null
              ? GoRouter.of(context).go(AppRoute.home.route)
              : GoRouter.of(context).go(AppRoute.auth.route);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Logo(),
            SizedBox(
              height: 25,
            ),
            SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ],
        ),
      ),
    );
  }
}
