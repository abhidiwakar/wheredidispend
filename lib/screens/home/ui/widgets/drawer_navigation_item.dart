import 'package:flutter/material.dart';

class DrawerNavigationItem extends StatefulWidget {
  final IconData? icon;
  final String title;
  const DrawerNavigationItem({super.key, this.icon, required this.title});

  @override
  State<DrawerNavigationItem> createState() => _DrawerNavigationItemState();
}

class _DrawerNavigationItemState extends State<DrawerNavigationItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      leading: widget.icon != null ? Icon(widget.icon) : null,
      title: Text(widget.title),
    );
  }
}
