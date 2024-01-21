import 'package:flutter/material.dart';

class NoTransaction extends StatelessWidget {
  const NoTransaction({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: const TextSpan(
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
          children: [
            TextSpan(
              text: "You don't have any transactions yet.\n",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(text: "Click on the "),
            WidgetSpan(
                child: Icon(
              Icons.add,
              size: 16,
            )),
            TextSpan(text: " button to add a new transaction."),
          ],
        ),
      ),
    );
  }
}
