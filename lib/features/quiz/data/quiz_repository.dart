import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_quizme/core/utils/app_constants.dart';
import 'package:flutter_quizme/features/quiz/data/question_model.dart';
import 'package:http/http.dart' as http;


class QuizRepository {

  Future<Quiz> fetchQuiz() async {
    try {
      final response = await http.get(Uri.parse(AppConstants.apiUrl));
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print(response.body);
        }
        final quiz = Quiz.fromJson(jsonDecode(response.body));
        return quiz;
      } else {
        throw Exception('Failed to load quiz data');
      }
    } catch (e) {
      rethrow;
    }
  }
}