import 'package:flutter/material.dart';

class NoTransaction extends StatelessWidget {
  const NoTransaction({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: "Click "),
            WidgetSpan(
              child: Icon(
                Icons.add,
                size: 14,
              ),
            ),
            TextSpan(text: " button to add transaction."),
          ],
        ),
      ),
    );
  }
}
