import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutTile extends StatelessWidget {
  const AboutTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: PackageInfo.fromPlatform(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return AboutListTile(
              icon: const Icon(Icons.info_outline),
              applicationName: snapshot.data!.appName,
              applicationVersion: snapshot.data!.version,
              applicationIcon: SvgPicture.asset(
                "assets/icon/wallet.svg",
                height: 24,
                width: 24,
              ),
              applicationLegalese:
                  "© ${DateTime.now().year} ${snapshot.data!.appName}",
              aboutBoxChildren: [
                const SizedBox(height: 10),
                Text(
                  "${snapshot.data!.appName} is a simple app to track your expenses.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 10),
                Text(
                  "Made with ❤️ by The Nameless Coder.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 10),
                Text(
                  "If you like the app, please consider sharing it with your friends and family.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 10),
                Text(
                  "Thank you for your support!",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 10),
              ],
            );
          } else {
            return const SizedBox();
          }
        });
  }
}
