import 'package:flutter/material.dart';
import 'package:flutter_quizme/core/navigation/app_routes.dart';
import 'package:flutter_quizme/core/navigation/route_names.dart';
import 'package:flutter_quizme/features/quiz/presentation/widgets/progress_bar.dart';
import 'package:flutter_quizme/features/quiz/presentation/widgets/question_card.dart';
import 'package:flutter_quizme/features/quiz/presentation/widgets/quiz_option_card.dart';
import 'package:provider/provider.dart';
import '../../../core/common_widgets/loading_widget.dart';
import '../data/question_model.dart';
import '../provider/quiz_provider.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Consumer<QuizProvider>(
        builder: (context, quizProvider, _) {
          if (quizProvider.questions.isEmpty) {
            if (quizProvider.errorMessage != null) {
              return _ErrorWidget(
                message: quizProvider.errorMessage!,
                onRetry: () {
                  quizProvider.resetErrors();
                  quizProvider.loadQuiz();
                },
              );
            }
            if (!quizProvider.hasInternet) {
              return _NoInternetWidget(
                onRetry: () {
                  quizProvider.resetErrors();
                  quizProvider.loadQuiz();
                },
              );
            }
            quizProvider.loadQuiz();
            return const LoadingWidget();
          }

          if (quizProvider.currentQuestionIndex >=
              quizProvider.questions.length) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              AppNavigator.pushReplacementTo(RouteNames.result, {
                'score': quizProvider.score,
                'totalQuestions': quizProvider.totalQuestions
              });
            });
            return const SizedBox.shrink();
          }

          final question =
              quizProvider.questions[quizProvider.currentQuestionIndex];
          final progress = (quizProvider.currentQuestionIndex + 1) /
              quizProvider.questions.length;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Question ${quizProvider.currentQuestionIndex + 1}/${quizProvider.questions.length}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),

                ProgressBar(progress: progress),
                const SizedBox(height: 10),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 600),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeInOutCubic,
                      ),
                      child: FadeTransition(opacity: animation, child: child),
                    );
                  },
                  child: Column(
                    key: ValueKey(quizProvider.currentQuestionIndex),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      QuestionCard(questionText: question.description),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 300, // Set a fixed height or use a more dynamic calculation
                        child: ListView.builder(
                          itemCount: question.options.length,
                          itemBuilder: (context, index) {
                            Option option = question.options[index];
                            return QuizOptionCard(
                              key: ValueKey(option.id),
                              optionText: option.description,
                              isCorrect: option.isCorrect,
                              questionKey: ValueKey(question.id),
                              onTap: () {
                                quizProvider.answerQuestion(option.isCorrect);
                              },
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorWidget({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off, color: Colors.white, size: 80),
          const SizedBox(height: 16),
          Text(message,
              textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onRetry,

            icon: const Icon(Icons.refresh),
            label: const Text("Retry"),
          ),
        ],
      ),
    );
  }
}

class _NoInternetWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const _NoInternetWidget({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off, color: Colors.grey, size: 80),
          const SizedBox(height: 16),
          const Text(
            "No internet connection.\nPlease check your network and try again.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text("Retry"),
          ),
        ],
      ),
    );
  }
}
