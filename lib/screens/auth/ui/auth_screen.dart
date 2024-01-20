import 'dart:developer';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wheredidispend/router/route_constants.dart';
import 'package:wheredidispend/utils/constants.dart';
import 'package:wheredidispend/widgets/logo.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isSigningIn = false;

  _signInWithGoogle() async {
    try {
      setState(() {
        _isSigningIn = true;
      });
      const List<String> scopes = <String>[
        'email',
      ];
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn(scopes: scopes).signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final result =
          await FirebaseAuth.instance.signInWithCredential(credential);
      await FirebaseAnalytics.instance.setUserId(id: result.user?.uid);
      if (result.user != null) {
        await FirebaseCrashlytics.instance.setUserIdentifier(result.user!.uid);
      }
      if (mounted) {
        GoRouter.of(context).go(AppRoute.home.route);
      }
    } catch (e) {
      log(e.toString());
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      Fluttertoast.showToast(
        msg: "Sign in failed. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
      );
    } finally {
      setState(() {
        _isSigningIn = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    FirebaseAnalytics.instance.setCurrentScreen(screenName: 'Login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(247, 242, 250, 1),
              Color.fromRGBO(228, 228, 228, 0.5),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        width: double.infinity,
        child: SafeArea(
          child: Column(
            children: [
              const Expanded(
                flex: 1,
                child: Center(
                  child: Logo(),
                ),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 600,
                ),
                child: Container(
                  padding: const EdgeInsets.all(22),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    child: _isSigningIn
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 25),
                            child: Center(
                              child: CircularProgressIndicator.adaptive(),
                            ),
                          )
                        : Column(
                            children: [
                              SignInButton(
                                Buttons.Google,
                                text: "Continue with Google",
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 4,
                                ),
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                onPressed: _signInWithGoogle,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Platform.isIOS
                                  ? SignInButton(
                                      Buttons.Apple,
                                      elevation: 1,
                                      text: "Continue with Apple",
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 10,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      onPressed: () {
                                        log("Sign in with Apple");
                                      },
                                    )
                                  : const SizedBox(),
                              const SizedBox(
                                height: 15,
                              ),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          "By clicking Continue with Google or Continue with Apple, you agree to our ",
                                      style: GoogleFonts.openSans(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "Terms & Conditions ",
                                      style: GoogleFonts.openSans(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.underline,
                                        color: Colors.black,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          if (await canLaunchUrlString(
                                              termsAndConditionsURL)) {
                                            await launchUrlString(
                                              termsAndConditionsURL,
                                            );
                                          }
                                        },
                                    ),
                                    TextSpan(
                                      text: "and ",
                                      style: GoogleFonts.openSans(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "Privacy Statement.",
                                      style: GoogleFonts.openSans(
                                        fontSize: 12,
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          if (await canLaunchUrlString(
                                              privacyPolicyURL)) {
                                            await launchUrlString(
                                              privacyPolicyURL,
                                            );
                                          }
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
