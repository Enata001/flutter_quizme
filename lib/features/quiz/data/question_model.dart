class QuizModel {
  final String question;
  final List<String> options;
  final int correctAnswer;

  QuizModel({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      question: json['question'],
      options: List<String>.from(json['options']),
      correctAnswer: json['correctAnswer'],
    );
  }
}

// Quiz model
class Quiz {
  final int id;
  final String title;
  final String topic;
  final int duration;
  final List<Question> questions;

  Quiz({
    required this.id,
    required this.title,
    required this.topic,
    required this.duration,
    required this.questions,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      title: json['title'] ?? '',
      topic: json['topic'] ?? '',
      duration: json['duration'] ?? 0,
      questions:
          (json['questions'] as List).map((q) => Question.fromJson(q)).toList(),
    );
  }
}

// Option model
class Option {
  final int id;
  final String description;
  final bool isCorrect;

  Option({
    required this.id,
    required this.description,
    required this.isCorrect,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      id: json['id'],
      description: json['description'] ?? '',
      isCorrect: json['is_correct'] ?? false,
    );
  }
}

class Question {
  final int id;
  final String description;
  final String topic;
  final List<Option> options;

  Question({
    required this.id,
    required this.description,
    required this.topic,
    required this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      description: json['description'] ?? '',
      topic: json['topic'] ?? '',
      options:
          (json['options'] as List).map((o) => Option.fromJson(o)).toList(),
    );
  }
}
