import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wheredidispend/router/route_constants.dart';
import 'package:wheredidispend/screens/auth/ui/auth_screen.dart';
import 'package:wheredidispend/screens/home/ui/home_screen.dart';
import 'package:wheredidispend/screens/init/init_screen.dart';
import 'package:wheredidispend/screens/profile/ui/profile_screen.dart';
import 'package:wheredidispend/screens/transaction/attachments/attachments.dart';
import 'package:wheredidispend/screens/transaction/bloc/transaction_bloc.dart';
import 'package:wheredidispend/screens/transaction/ui/add_transaction.dart';
import 'package:wheredidispend/screens/transaction/ui/view_transaction.dart';
import 'package:wheredidispend/screens/update/ui/update_screen.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      name: AppRoute.root.name,
      path: AppRoute.root.route,
      builder: (context, state) => const InitScreen(),
    ),
    GoRoute(
      name: AppRoute.update.name,
      path: AppRoute.update.route,
      builder: (context, state) => const UpdateScreen(),
    ),
    GoRoute(
      name: AppRoute.auth.name,
      path: AppRoute.auth.route,
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      name: AppRoute.home.name,
      path: AppRoute.home.route,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      name: AppRoute.profile.name,
      path: AppRoute.profile.route,
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      name: AppRoute.addTransaction.name,
      path: AppRoute.addTransaction.route,
      builder: (context, state) => BlocProvider<TransactionBloc>(
        create: (context) => TransactionBloc(),
        child: state.extra != null
            ? AddTransactionScreen(
                amount: (state.extra as Map<String, dynamic>)["amount"],
                description:
                    (state.extra as Map<String, dynamic>)["description"],
              )
            : const AddTransactionScreen(),
      ),
    ),
    GoRoute(
      name: AppRoute.viewTransaction.name,
      path: AppRoute.viewTransaction.route,
      builder: (context, state) => ViewTransactionScreen(
        transactionId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      name: AppRoute.attachments.name,
      path: AppRoute.attachments.route,
      builder: (context, state) => const Attachment(),
    ),
  ],
);
