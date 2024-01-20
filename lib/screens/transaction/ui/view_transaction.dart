import 'package:flutter/material.dart';

class ViewTransactionScreen extends StatefulWidget {
  final String transactionId;
  const ViewTransactionScreen({super.key, required this.transactionId});

  @override
  State<ViewTransactionScreen> createState() => _ViewTransactionScreenState();
}

class _ViewTransactionScreenState extends State<ViewTransactionScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
