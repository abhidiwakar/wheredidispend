import 'package:flutter/material.dart';

class Attachment extends StatefulWidget {
  const Attachment({super.key});

  @override
  State<Attachment> createState() => _AttachmentState();
}

class _AttachmentState extends State<Attachment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attachments"),
      ),
      body: const Center(
        child: Text("Attachment"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
