import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:wheredidispend/utils/update.dart';
import 'package:wheredidispend/widgets/logo.dart';

class UpdateScreen extends StatelessWidget {
  final bool _isSigningIn = false;

  const UpdateScreen({super.key});

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
                              Text(
                                "An update is available!",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                "Please update the app to continue using it.",
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  PackageInfo.fromPlatform().then((package) {
                                    canLaunchUrlString(
                                      getAppURL(package.packageName),
                                    ).then((value) {
                                      if (value) {
                                        launchUrlString(
                                          getAppURL(package.packageName),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Could not open app store.",
                                            ),
                                          ),
                                        );
                                      }
                                    });
                                  });
                                },
                                icon: const Icon(Icons.update),
                                label: const Text("Update Now"),
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
