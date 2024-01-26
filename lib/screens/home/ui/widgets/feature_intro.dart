import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:wheredidispend/utils/constants.dart';

class FeatureIntro extends StatefulWidget {
  const FeatureIntro({super.key});

  @override
  State<FeatureIntro> createState() => _FeatureIntroState();
}

class _FeatureIntroState extends State<FeatureIntro> {
  _launchUrl({bool? hide}) async {
    if (hide == true) {
      _hideBottomSheet();
    }
    const featureUrl = "$newFeaturesURL#auto-fill-expenses";
    if (await canLaunchUrlString(featureUrl)) {
      await launchUrlString(featureUrl);
    }
  }

  _hideBottomSheet() async {
    Navigator.of(context).pop();
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool(kHideAutoFillBottomSheet, true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.new_releases,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'New Feature',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Hey ${FirebaseAuth.instance.currentUser?.displayName ?? "User"}, we\'re excited to announce a new way of adding your expenses.',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const Divider(height: 24),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text:
                        'Adding your expenses is now easier than ever! Simply ',
                  ),
                  TextSpan(
                    text: 'share a screenshot',
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w600,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => _launchUrl(),
                  ),
                  const TextSpan(
                    text:
                        ' of your payment from popular UPI apps and we will scan it to ',
                  ),
                  TextSpan(
                    text: 'automatically fill in the details',
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => _launchUrl(),
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const TextSpan(
                    text:
                        ' for you. It\'s a hassle-free way to keep track of your expenses!',
                  ),
                ],
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: TextButton(
                    onPressed: _launchUrl,
                    child: const Text('Learn More'),
                  ),
                ),
                const SizedBox(width: 16),
                Flexible(
                  child: FilledButton(
                    onPressed: _hideBottomSheet,
                    child: const Text('Ok, Got it.'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
