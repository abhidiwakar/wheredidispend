import 'package:flutter/material.dart';
import 'package:wheredidispend/screens/home/ui/widgets/drawer_navigation_item.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: Image.asset(
                  "assets/icon/icon.png",
                  height: 24,
                  width: 24,
                ),
                title: const Text(
                  "wheredidispend.com",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              const DrawerNavigationItem(
                title: "Add new Group",
                icon: Icons.add,
              )
            ],
          ),
        ),
      ),
    );
  }
}
