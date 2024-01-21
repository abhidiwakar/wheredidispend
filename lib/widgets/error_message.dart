import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final String message;
  final Widget? child;
  const ErrorMessage({super.key, required this.message, this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.sentiment_very_dissatisfied_rounded,
              size: 38,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 10),
            Text(
              "Oops! Something went wrong.",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            if (child != null) child!,
          ],
        ),
      ),
    );
  }
}
