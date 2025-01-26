import 'package:flutter/material.dart';
import 'package:flutter_quizme/core/navigation/app_routes.dart';
import 'package:flutter_quizme/core/navigation/route_names.dart';
import 'package:flutter_quizme/core/utils/app_constants.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../core/common_widgets/c_elevated_button.dart';
import '../../../core/utils/dimensions.dart';
import '../../quiz/provider/quiz_provider.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;

  const ResultScreen(
      {super.key, required this.score, required this.totalQuestions});

  @override
  Widget build(BuildContext context) {
    double percentage = (score / totalQuestions) * 100;
    String resultMessage;
    String lottieAnimation;

    if (percentage >= 80) {
      resultMessage = "Excellent Job! 🎉";
      lottieAnimation = AppConstants.success;
    } else if (percentage >= 50) {
      resultMessage = "Good Effort! 👍";
      lottieAnimation = AppConstants.goodEffort;
    } else {
      resultMessage = "Keep Practicing! 💪";
      lottieAnimation = AppConstants.tryAgain;
    }

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.padding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset(
                lottieAnimation,
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              Text(
                resultMessage,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                'You scored $score out of $totalQuestions',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              CElevatedButton(
                onPressed: () {
                  final quizProvider = context.read<QuizProvider>();
                  quizProvider.resetQuiz();
                  AppNavigator.pushReplacementTo(RouteNames.quiz);
                },
                text: 'Retake Quiz',
              ),
              const SizedBox(height: 20),
              CElevatedButton(
                onPressed: () {
                  AppNavigator.skipTo(RouteNames.home);
                },
                text: 'Go home',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
