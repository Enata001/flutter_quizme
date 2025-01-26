import 'package:flutter/material.dart';
import 'package:flutter_quizme/core/navigation/route_names.dart';
import 'package:flutter_quizme/features/quiz/presentation/quiz_screen.dart';
import 'package:flutter_quizme/features/result/presentation/result_screen.dart';

import '../../features/home/presentation/home_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';

class AppNavigator {
  AppNavigator._();
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static pushTo(String routeName, [dynamic args]) {
    navigatorKey.currentState?.pushNamed(routeName, arguments: args);
  }

  static skipTo(String routeName, [dynamic args]) {
    navigatorKey.currentState
        ?.pushNamedAndRemoveUntil(routeName, (route) => false, arguments: args);
  }

  static pushReplacementTo(String routeName, [dynamic args]) {
    navigatorKey.currentState?.pushReplacementNamed(routeName, arguments: args);
  }

  static pop([dynamic args]) {
    navigatorKey.currentState?.pop(args);
  }

  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.home:
        return AppRoute(HomeScreen());
      case RouteNames.splash:
        return AppRoute(SplashScreen());
      case RouteNames.quiz:
        return AppRoute(QuizScreen());
      case RouteNames.result:
        final args = settings.arguments as Map<String, dynamic>;
        return AppRoute(
          ResultScreen(
            score: args['score'],
            totalQuestions: args['totalQuestions'],
          ),
        );
    }
    return AppRoute(ErrorScreen(
      settings: settings,
    ));
  }
}

class AppRoute extends PageRouteBuilder {
  final Widget widget;

  static Duration duration = const Duration(milliseconds: 150);

  AppRoute(this.widget)
      : super(
          pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondary) =>
              widget,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            final tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            final offsetAnimation = animation.drive(tween);

            return SlideTransition(position: offsetAnimation, child: child);
          },
          reverseTransitionDuration: duration,
        );
}

class ErrorScreen extends StatelessWidget {
  final RouteSettings settings;

  const ErrorScreen({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "${settings.name} page does not exist",
        ),
      ),
    );
  }
}
