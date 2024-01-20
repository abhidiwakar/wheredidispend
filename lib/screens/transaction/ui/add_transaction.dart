import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:wheredidispend/models/transaction.dart';
import 'dart:developer';
import 'package:wheredidispend/screens/transaction/repository/transaction_repository.dart';

class AddTransactionScreen extends StatefulWidget {
  final String? amount;
  final String? description;
  const AddTransactionScreen({super.key, this.amount, this.description});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  var _isAddingTransaction = false;
  final _amountFieldController = TextEditingController(
      text: "${NumberFormat.simpleCurrency(
    locale: Platform.localeName,
  ).currencySymbol}0");
  final _descriptionFieldController = TextEditingController(text: "");

  _addTransaction() async {
    final amountString =
        _amountFieldController.text.substring(1).replaceAll(",", "");
    final amount = double.parse(amountString);

    if (amount == 0) {
      showAdaptiveDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Error"),
              content: const Text("Amount cannot be zero!"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("OK"),
                )
              ],
            );
          });
      return;
    }

    final description = _descriptionFieldController.text;
    final transaction = Transaction(
      amount: amount,
      description: description,
      date: DateTime.now(),
      currency: NumberFormat.simpleCurrency(
        locale: Platform.localeName,
      ).currencyName,
    );
    if (MediaQuery.of(context).viewInsets.bottom > 0) {
      FocusScope.of(context).unfocus();
    }
    setState(() {
      _isAddingTransaction = true;
    });
    // log(transaction.toString());
    TransactionRepository.addTransaction(transaction).then((result) {
      if (result.success == true) {
        context.pop(true);
      } else {
        setState(() {
          _isAddingTransaction = false;
        });
        showAdaptiveDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Error"),
                content: Text(result.message ?? "Something went wrong!"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("OK"),
                  )
                ],
              );
            });
      }
    }).catchError((error) {
      log("Error adding transaction: $error");
    });
  }
  // var _locationText = "";
  // var _coordinates;

  // _getEmoji() {
  //   //TODO: Calculate average transaction amount and show emoji accordingly
  //   return "";
  //   // final amountString =
  //   //     _amountFieldController.text.substring(1).replaceAll(",", "");
  //   // final amount = double.tryParse(amountString);

  //   // if (amount == 0) return "";

  //   // if (amount != null) {
  //   //   if (amount > 0 && amount <= 500) {
  //   //     return "😃";
  //   //   }

  //   //   if (amount > 500 && amount <= 1000) {
  //   //     return "😀";
  //   //   }

  //   //   if (amount > 1000 && amount <= 5000) {
  //   //     return "🙂";
  //   //   }

  //   //   if (amount > 5000 && amount <= 10000) {
  //   //     return "🤔";
  //   //   }

  //   //   if (amount > 10000 && amount <= 50000) {
  //   //     return "😐";
  //   //   }
  //   // }

  //   // return "🔥";
  // }

  // _requestLocationPermission() async {
  //   var permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //   }

  //   if (permission == LocationPermission.whileInUse ||
  //       permission == LocationPermission.always) {
  //     final position = await Geolocator.getCurrentPosition();
  //     _coordinates = position;
  //     final address = await placemarkFromCoordinates(
  //       position.latitude,
  //       position.longitude,
  //       localeIdentifier: "en_IN",
  //     );
  //     var firstAddress = address.firstOrNull;
  //     if (firstAddress != null) {
  //       _locationText = [
  //         firstAddress.street,
  //         firstAddress.subLocality,
  //         firstAddress.locality
  //       ].join(", ").trim();
  //     }
  //     setState(() {});
  //   }
  // }

  @override
  void initState() {
    super.initState();
    log("AddTransactionScreen init -> ${widget.amount} ${widget.description}");
    if (widget.amount != null) {
      _amountFieldController.text = "${NumberFormat.simpleCurrency(
        locale: Platform.localeName,
      ).currencySymbol}${widget.amount ?? 0}";
    }
    if (widget.description != null) {
      _descriptionFieldController.text = widget.description ?? "";
    }
    FirebaseAnalytics.instance.setCurrentScreen(screenName: 'Add Transaction');
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _isAddingTransaction == false,
      child: Stack(
        children: [
          Scaffold(
            extendBody: true,
            appBar: AppBar(
              centerTitle: true,
              // title: Text(_getEmoji()),
            ),
            body: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              textAlign: TextAlign.center,
                              controller: _amountFieldController,
                              autofocus: true,
                              style: const TextStyle(
                                fontSize: 36,
                              ),
                              maxLength: 15,
                              inputFormatters: [
                                CurrencyInputFormatter(
                                  leadingSymbol: NumberFormat.simpleCurrency(
                                    locale: Platform.localeName,
                                  ).currencySymbol,
                                ),
                              ],
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                counterText: "",
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                              constraints: const BoxConstraints(
                                maxWidth: 300,
                              ),
                              child: TextField(
                                maxLength: 50,
                                textAlign: TextAlign.center,
                                autocorrect: true,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  counterText: "",
                                  hintText: "What are you spending on?",
                                ),
                                controller: _descriptionFieldController,
                              ),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(horizontal: 18),
                            //   child: Row(
                            //     mainAxisSize: MainAxisSize.min,
                            //     children: [
                            //       const Icon(Icons.location_on_outlined),
                            //       Flexible(
                            //         child: Padding(
                            //           padding:
                            //               const EdgeInsets.symmetric(horizontal: 8.0),
                            //           child: Text(
                            //             _locationText,
                            //             overflow: TextOverflow.ellipsis,
                            //             softWrap: false,
                            //           ),
                            //         ),
                            //       ),
                            //       // const Icon(
                            //       //   Icons.keyboard_arrow_right_rounded,
                            //       // ),
                            //     ],
                            //   ),
                            // ),
                            // const SizedBox(
                            //   height: 30,
                            // ),
                            // OutlinedButton(
                            //   onPressed: () {
                            //     showModalBottomSheet(
                            //       context: context,
                            //       builder: (context) {
                            //         return const GroupSelectionBottomSheet();
                            //       },
                            //     );
                            //   },
                            //   child: const Text("General"),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 600,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(22),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.primary,
                              ),
                              foregroundColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                            onPressed: _addTransaction,
                            child: const Text("Save"),
                          ),
                        )
                        // const SizedBox(width: 10),
                        // Badge.count(
                        //   count: 2,
                        //   offset: Offset.fromDirection(0, 0),
                        //   child: OutlinedButton(
                        //     onPressed: () {
                        //       context.pushNamed(AppRoute.attachments.name);
                        //     },
                        //     child: const Icon(Icons.attachment),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          if (_isAddingTransaction)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}

class GroupSelectionBottomSheet extends StatelessWidget {
  const GroupSelectionBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "Group",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.close,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  elevation: 0,
                  child: ListTile(
                    title: Text("General"),
                    subtitle: Text("0 transactions this month"),
                  ),
                )
                // Card(
                //   borderOnForeground: true,
                //   elevation: 0,
                //   child: Container(
                //     width: double.infinity,
                //     padding: const EdgeInsets.all(12),
                //     child: Text(
                //       "General",
                //       style: Theme.of(context).textTheme.titleMedium,
                //     ),
                //   ),
                // ),
                // Card(
                //   borderOnForeground: true,
                //   elevation: 0,
                //   child: Container(
                //     width: double.infinity,
                //     padding: const EdgeInsets.all(12),
                //     child: Text(
                //       "General",
                //       style: Theme.of(context).textTheme.titleMedium,
                //     ),
                //   ),
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
