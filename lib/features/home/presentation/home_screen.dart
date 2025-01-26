import 'package:flutter/material.dart';
import 'package:flutter_quizme/core/utils/app_constants.dart';
import 'package:flutter_quizme/core/utils/dimensions.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../../core/common_widgets/c_elevated_button.dart';
import '../../../core/navigation/app_routes.dart';
import '../../../core/navigation/route_names.dart';
import '../../../core/theme/theme_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            spacing: AppDimensions.padding,
            children: [
              Lottie.asset(AppConstants.welcome,
                  width: 300,
                  height: MediaQuery.sizeOf(context).height * 0.4,
                  fit: BoxFit.contain,
                  repeat: true),
              Text(
                'Let\'s Play!',
                textScaler: TextScaler.linear(2.5),
                style: TextStyle( letterSpacing: 1.5),
              ),
              Text(
                'Play now and test your skills',
                textScaler: TextScaler.linear(1),
              ),
              const SizedBox(
                height: 20,
              ),
              CElevatedButton(
                onPressed: () {
                  AppNavigator.pushTo(RouteNames.quiz);
                },
                text: 'Start Quiz',
              ),
              CElevatedButton(
                text: 'Change Theme',
                onPressed: () {
                  Provider.of<ThemeProvider>(context, listen: false)
                      .toggleTheme();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
