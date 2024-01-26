import 'dart:developer';
import 'dart:io';

import 'package:currency_picker/currency_picker.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:wheredidispend/models/transaction.dart';
import 'package:wheredidispend/repositories/transaction_repository.dart';
import 'package:wheredidispend/screens/home/bloc/home_bloc.dart';
import 'package:wheredidispend/screens/transaction/bloc/transaction_bloc.dart';
import 'package:wheredidispend/utils/currency.dart';

class AddTransactionScreen extends StatefulWidget {
  final String? amount;
  final String? description;
  const AddTransactionScreen({super.key, this.amount, this.description});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  var _isAddingTransaction = false;
  var _emoji = "";
  var _spendMessage = "";
  final _amountFieldController = TextEditingController(text: "");
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

    if (MediaQuery.of(context).viewInsets.bottom > 0) {
      FocusScope.of(context).unfocus();
    }

    final description = _descriptionFieldController.text;
    final currency = await getCurrency();
    final transaction = Transaction(
      amount: amount,
      description: description,
      date: DateTime.now(),
      currency: currency?.code ??
          NumberFormat.simpleCurrency(
            locale: Platform.localeName,
          ).currencyName,
    );

    setState(() {
      _isAddingTransaction = true;
    });
    // log(transaction.toString());
    TransactionRepository.addTransaction(transaction).then((result) {
      if (result.success == true) {
        final limit = (MediaQuery.of(context).size.longestSide / 50).round();
        context.read<HomeBloc>().add(FetchHomeEvent(limit: limit));
        context.pop();
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

  _getEmoji() {
    final averageAmount = context.read<TransactionBloc>().state
            is TransactionAverageSuccess
        ? (context.read<TransactionBloc>().state as TransactionAverageSuccess)
            .averageSpending
        : null;
    if (_amountFieldController.text.isEmpty) {
      return;
    }
    final amountString =
        _amountFieldController.text.substring(1).replaceAll(",", "");
    final amount = double.tryParse(amountString);

    String newEmoji = "";

    log("Amount: $amount, Average: $averageAmount");
    if (amount != null && amount != 0 && averageAmount != null) {
      log("Amount: $amount, Average: $averageAmount");
      final deviation = ((amount - averageAmount) / averageAmount) * 100;

      if (deviation <= 10) {
        newEmoji = "😃";
        _spendMessage = "You are spending within 10 percent of your average!";
      } else if (deviation > 10 && deviation <= 30) {
        newEmoji = "🤔";
        _spendMessage =
            "You are spending more than 10 percent of your average!";
      } else if (deviation > 30 && deviation <= 50) {
        newEmoji = "😐";
        _spendMessage =
            "You are spending more than 30 percent of your average!";
      } else {
        newEmoji = "🔥";
        _spendMessage =
            "You are spending more than 50 percent of your average!";
      }
    }

    setState(() {
      _emoji = newEmoji;
    });
  }

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

  _initAmount() async {
    final currency = await getCurrency();
    if (widget.amount != null) {
      _amountFieldController.text = "${NumberFormat.currency(
        symbol: currency?.symbol,
        decimalDigits: currency?.decimalDigits,
        name: currency?.name,
      ).currencySymbol}${widget.amount ?? 0}";
    }
  }

  @override
  void initState() {
    super.initState();
    _initAmount();
    Future.delayed(Duration.zero, () {
      context.read<TransactionBloc>().add(TransactionGetAverageEvent());
    });
    if (widget.description != null) {
      _descriptionFieldController.text = widget.description ?? "";
    }
    _amountFieldController.addListener(() {
      _getEmoji();
    });
    FirebaseAnalytics.instance.setCurrentScreen(screenName: 'Add Transaction');
  }

  @override
  void dispose() {
    _amountFieldController.dispose();
    _descriptionFieldController.dispose();
    super.dispose();
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
              title: _emoji != ""
                  ? Tooltip(
                      message: _spendMessage,
                      margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.1,
                      ),
                      child: Text(_emoji),
                    )
                  : null,
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
                            // Container(
                            //   padding: const EdgeInsets.all(8),
                            //   decoration: BoxDecoration(
                            //     color: Theme.of(context)
                            //         .colorScheme
                            //         .surfaceVariant,
                            //     borderRadius: BorderRadius.circular(10),
                            //   ),
                            //   child: RichText(
                            //     text: TextSpan(
                            //       children: [
                            //         TextSpan(
                            //           text: "INR",
                            //           style: Theme.of(context)
                            //               .textTheme
                            //               .labelSmall,
                            //         ),
                            //         const WidgetSpan(
                            //           child: Icon(
                            //             Icons.arrow_drop_down_outlined,
                            //             size: 18,
                            //           ),
                            //         )
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            FutureBuilder<Currency?>(
                                future: getCurrency(),
                                builder: (context, snap) {
                                  return TextField(
                                    textAlign: TextAlign.center,
                                    controller: _amountFieldController,
                                    autofocus: true,
                                    style: const TextStyle(
                                      fontSize: 36,
                                    ),
                                    maxLength: 15,
                                    inputFormatters: [
                                      CurrencyInputFormatter(
                                        leadingSymbol: snap.data?.symbol ??
                                            NumberFormat.simpleCurrency(
                                              locale: Platform.localeName,
                                            ).currencySymbol,
                                      ),
                                    ],
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      counterText: "",
                                      hintText: NumberFormat.currency(
                                        decimalDigits: snap.data?.decimalDigits,
                                        name: snap.data?.name,
                                        symbol: snap.data?.symbol,
                                      ).format(0),
                                    ),
                                  );
                                }),
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
