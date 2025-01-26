import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import '../data/question_model.dart';
import '../data/quiz_repository.dart';

class QuizProvider with ChangeNotifier {
  final QuizRepository _quizRepository = QuizRepository();
  Quiz? _quiz;
  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _totalQuestions = 0;

  List<Question> get questions => _questions;

  int get currentQuestionIndex => _currentQuestionIndex;

  int get score => _score;

  int get totalQuestions => _totalQuestions;

  // Future<void> loadQuiz() async {
  //   try {
  //     _quiz = await _quizRepository.fetchQuiz();
  //     _questions = _quiz!.questions;
  //     _totalQuestions = _questions.length;
  //     _currentQuestionIndex = 0;
  //     _score = 0;
  //     notifyListeners();
  //   } catch (e) {
  //     throw Exception('Failed to load quiz: $e');
  //   }
  // }

  void answerQuestion(bool isCorrect) {
    if (isCorrect) {
      _score++;
    }
    _currentQuestionIndex++;
    notifyListeners();
  }

  void resetQuiz() {
    _currentQuestionIndex = 0;
    _score = 0;
    notifyListeners();
  }

  bool _hasInternet = true;
  String? _errorMessage;

  bool get hasInternet => _hasInternet;

  String? get errorMessage => _errorMessage;

  Future<void> loadQuiz() async {
    try {
      final connectivity = await Connectivity().checkConnectivity();
      if (connectivity.firstOrNull == ConnectivityResult.none) {
        _hasInternet = false;
        _errorMessage = "No internet connection. Please check your connection.";
        notifyListeners();
        return;
      }

      _hasInternet = true;
      _errorMessage = null;

      // Add print statements or logging here
      print('Attempting to fetch quiz');

      _quiz = await _quizRepository.fetchQuiz().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          print('Quiz loading timed out');
          throw TimeoutException("Loading quiz timed out. Please try again.");
        },
      );

      // Add print statement to verify quiz is loaded
      print('Quiz loaded: ${_quiz?.questions.length} questions');

      _questions = _quiz!.questions;
      _totalQuestions = _questions.length;
      _currentQuestionIndex = 0;
      _score = 0;
      notifyListeners();
    } catch (e) {
      // More detailed error logging
      print('Error loading quiz: $e');
      _hasInternet = false;
      _errorMessage = "Failed to load quiz: ${e.toString()}";
      notifyListeners();
    }
  }

  void resetErrors() {
    _errorMessage = null;
    notifyListeners();
  }
}
