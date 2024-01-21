import 'dart:async';
import 'dart:developer' as dev;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sharing_intent/flutter_sharing_intent.dart';
import 'package:flutter_sharing_intent/model/sharing_file.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:intl/intl.dart';
import 'package:wheredidispend/models/transaction.dart';
import 'package:wheredidispend/router/route_constants.dart';
import 'package:wheredidispend/screens/home/bloc/home_bloc.dart';
import 'package:wheredidispend/screens/home/ui/widgets/no_transaction.dart';
import 'package:wheredidispend/utils/text_to_number.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late StreamSubscription _intentDataStreamSubscription;
  List<SharedFile>? list;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();
  // final List<Transaction> _transactions = [];

  Future<void> _getTransactions({bool loadMore = false}) async {
    final state = context.read<HomeBloc>().state;
    if (state is HomeLoading || state is HomeLoadingMore) {
      dev.log("Not fetching transactions as already loading");
      return;
    }

    final limit = (MediaQuery.of(context).size.longestSide / 50).round();
    // log("=====> Fetching $limit transactions...");
    // return TransactionRepository.getTransactions(
    //   limit: limit,
    //   firstId: _transactions.firstOrNull?.id,
    //   lastId: _transactions.lastOrNull?.id,
    // ).then((value) {
    //   if (value.success) {
    //     setState(() {
    //       value.data?.forEach((element) {
    //         if (_transactions.where((el) => element == el).isEmpty) {
    //           _transactions.add(element);
    //         }
    //       });
    //       _transactions.sort((a, b) {
    //         return b.date.compareTo(a.date);
    //       });
    //     });
    //   } else {
    //     showAdaptiveDialog(
    //       context: context,
    //       builder: (_) => AlertDialog(
    //         title: const Text("Error"),
    //         content: Text(value.message!),
    //         actions: [
    //           TextButton(
    //             onPressed: () {
    //               context.pop();
    //             },
    //             child: const Text("OK"),
    //           ),
    //         ],
    //       ),
    //     );
    //   }
    // });
    String? firstId;
    String? lastId;
    List<Transaction> existingTransactions = [];

    if (state is HomeSuccess) {
      final state = context.read<HomeBloc>().state as HomeSuccess;
      firstId = state.transactions.firstOrNull?.id;
      lastId = state.transactions.lastOrNull?.id;
      existingTransactions = state.transactions;
    }

    if (loadMore) {
      context.read<HomeBloc>().add(
            FetchMoreHomeEvent(
              limit: limit,
              firstId: firstId,
              lastId: lastId,
              transactions: existingTransactions,
            ),
          );
    } else {
      context.read<HomeBloc>().add(
            FetchHomeEvent(
              limit: limit,
            ),
          );
    }
  }

  Future<dynamic> _processImage(String imagePath) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);
      String text = recognizedText.text;
      // dev.log("Text: $text");

      RegExp regex = RegExp(r'(?<=Rupees\s)([\s\w]+)(?=\sOnly)');
      final match = regex.firstMatch(text)?.group(1)?.replaceAll("\n", " ");
      List<double> numbers = [];
      if (match != null) {
        dev.log("Match: $match");
        final number = numberTextToInteger(match);
        dev.log("Number: $number");
        numbers.add(number);
      } else {
        for (TextBlock block in recognizedText.blocks) {
          final value = double.tryParse(block.text.replaceAll(",", ""));
          dev.log("Block: ${block.text} => $value");
          if (value != null) {
            numbers.add(value);
          }
        }
      }
      dev.log("message: ${numbers.join(",")}");
      numbers.sort();

      if (numbers.isEmpty) {
        Fluttertoast.showToast(
          msg: "Sorry, we couldn't find any amount in the image.",
        );
        return;
      }

      String description = "";
      for (TextBlock block in recognizedText.blocks) {
        final value = block.text.toLowerCase().startsWith("to:");
        if (value) {
          description = block.text.replaceAll("\n", " ");
          break;
        }
      }

      return {
        "amount": numbers.first,
        "description": description,
      };
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Sorry, we couldn't find any amount in the image.",
      );
      return null;
    } finally {
      textRecognizer.close();
    }
  }

  @override
  void initState() {
    super.initState();

    FirebaseAnalytics.instance.setCurrentScreen(screenName: 'Home');

    Future.delayed(Duration.zero, () {
      // Fetch transactions on first load
      // _refreshKey.currentState?.show();
      _getTransactions();

      // Fetch more data when user reaches the end of the list
      _scrollController.addListener(() {
        // Check if the user has reached the end of the list
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          // Load more data only if not already loading
          // _refreshKey.currentState?.show(atTop: false);
          _getTransactions(loadMore: true);
        }
      });
    });

    // Listen for auth state changes and redirect to auth screen if user is not logged in
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        context.go(AppRoute.auth.route);
      }
    });

    _intentDataStreamSubscription = FlutterSharingIntent.instance
        .getMediaStream()
        .listen((List<SharedFile> value) {
      dev.log("Shared: getMediaStream ${value.map((f) => f.value).join(",")}");
      if (value.isNotEmpty && value.first.value != null) {
        _processImage(value.first.value!).then((value) {
          if (value != null) {
            dev.log("Passing params: $value");
            context.pushNamed(
              AppRoute.addTransaction.name,
              extra: {
                "amount": value["amount"].toString(),
                "description": value["description"],
              },
            ).then((value) {
              dev.log("Fetch transactions");
              // if (value != null && bool.tryParse(value.toString()) == true) {
              //   _refreshKey.currentState?.show();
              // }
            });
          }
        });
      }
    }, onError: (err) {
      dev.log("getIntentDataStream error: $err");
      Fluttertoast.showToast(
        msg: "Sorry, we couldn't process the image! Please try again.",
      );
    });

    // For sharing images coming from outside the app while the app is closed
    FlutterSharingIntent.instance
        .getInitialSharing()
        .then((List<SharedFile> value) {
      dev.log("Shared: getInitialMedia ${value.map((f) => f.value).join(",")}");
      if (value.isNotEmpty && value.first.value != null) {
        _processImage(value.first.value!).then((value) {
          if (value != null) {
            dev.log("Passing params: $value");
            context.pushNamed(
              AppRoute.addTransaction.name,
              extra: {
                "amount": value["amount"].toString(),
                "description": value["description"],
              },
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    dev.log("Cancelling all subscriptions");
    _intentDataStreamSubscription.cancel();
    // Dispose the ScrollController to prevent memory leaks
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          SvgPicture.asset(
            'assets/icon/wallet.svg',
            height: 25,
            width: 25,
          ),
          const SizedBox(width: 10),
          const Text('WhereDidISpend?'),
        ]),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: BlocSelector<HomeBloc, HomeState, bool>(
            selector: (state) {
              return state is HomeLoading || state is HomeLoadingMore;
            },
            builder: (context, state) {
              return state
                  ? const SizedBox(
                      height: 3,
                      child: LinearProgressIndicator(),
                    )
                  : const SizedBox(
                      height: 3,
                    );
            },
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: FirebaseAuth.instance.currentUser?.photoURL != null
                ? SizedBox(
                    height: 35,
                    child: Tooltip(
                      message: "Open profile screen",
                      child: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                          FirebaseAuth.instance.currentUser!.photoURL!,
                          scale: 35,
                        ),
                      ),
                    ),
                  )
                : const Icon(Icons.account_circle_rounded),
            onPressed: () {
              context.pushNamed(AppRoute.profile.name);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add a transaction",
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        onPressed: () async {
          context.pushNamed(AppRoute.addTransaction.name);
          // dev.log("Result: $result");
          // if (result != null && result) {
          //   _refreshKey.currentState?.show();
          // }
        },
        child: const Icon(Icons.add),
      ),
      // drawer: const AppDrawer(),
      body: RefreshIndicator.adaptive(
        key: _refreshKey,
        onRefresh: () {
          return _getTransactions();
        },
        child: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is HomeFailure) {
              Fluttertoast.showToast(
                msg: state.message,
              );
            }
          },
          builder: (context, state) {
            if (state is HomeLoading) {
              return const NoTransaction();
            }

            if (state is HomeSuccess || state is HomeLoadingMore) {
              if (state is HomeSuccess && state.transactions.isEmpty) {
                return const NoTransaction();
              }

              final transactions = state is HomeSuccess
                  ? state.transactions
                  : state is HomeLoadingMore
                      ? state.transactions
                      : [];

              return ListView.builder(
                controller: _scrollController,
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      (index == 0) ||
                              (transactions[index].date.month !=
                                  transactions[index - 1].date.month)
                          ? ListTile(
                              title: Text(
                                transactions[index].date.month ==
                                        DateTime.now().month
                                    ? "This month"
                                    : DateFormat('MMMM yyyy')
                                        .format(transactions[index].date),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          : const SizedBox(),
                      Card(
                        child: ListTile(
                          // onTap: () => context.pushNamed(
                          //   AppRoute.viewTransaction.name,
                          //   pathParameters: {
                          //     "id": _transactions[index].id!,
                          //   },
                          // ),
                          leading: CircleAvatar(
                            child: Text(DateFormat('dd')
                                .format(transactions[index].date)),
                          ),
                          title: Text(
                            NumberFormat.simpleCurrency(
                                    name: transactions[index].currency)
                                .format(
                              transactions[index].amount,
                            ),
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: transactions[index].description != null &&
                                  transactions[index].description!.isNotEmpty
                              ? Text(transactions[index].description!)
                              : null,
                        ),
                      ),
                    ],
                  );
                },
                padding: EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 10,
                  bottom: MediaQuery.of(context).viewPadding.bottom + 100,
                ),
              );
            }

            return Container();
          },
        ),
      ),
    );
  }
}
