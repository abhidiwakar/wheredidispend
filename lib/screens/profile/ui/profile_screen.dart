import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wheredidispend/screens/profile/repository/profile_repository.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isDeletingAccount = false;

  @override
  void initState() {
    super.initState();
    FirebaseAnalytics.instance.setCurrentScreen(screenName: 'Profile');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      FirebaseAuth.instance.currentUser!.photoURL!,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    FirebaseAuth.instance.currentUser?.displayName ?? "User",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    FirebaseAuth.instance.currentUser?.email ?? "",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.delete_forever_outlined),
              title: const Text("Delete Account"),
              subtitle: const Text(
                "Permanently delete your account and associated data.",
              ),
              trailing: _isDeletingAccount
                  ? const SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : null,
              onTap: _isDeletingAccount
                  ? null
                  : () {
                      showAdaptiveDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text("Delete Account?"),
                          content: const Text(
                            "Your account and associated data will be permanently deleted.",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                                setState(() {
                                  _isDeletingAccount = true;
                                });
                                ProfileRepository.deleteAccount().then(
                                  (value) {
                                    log(value.toString());
                                    if (!value.success && mounted) {
                                      setState(() {
                                        _isDeletingAccount = false;
                                      });
                                      showAdaptiveDialog(
                                        context: context,
                                        builder: (ctxInner) => AlertDialog(
                                          title: const Text("Error"),
                                          content: Text(
                                            value.message ??
                                                "Failed to delete account.",
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(ctxInner).pop(),
                                              child: const Text("Ok"),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                );
                                // GoRouter.of(context).go("/auth"),
                              },
                              child: const Text("Delete"),
                            ),
                          ],
                        ),
                      );
                    },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              subtitle: const Text("Logout from the app."),
              onTap: () => {
                FirebaseAuth.instance.signOut(),
                GoRouter.of(context).go("/auth"),
              },
            ),
          ],
        ),
      ),
    );
  }
}
