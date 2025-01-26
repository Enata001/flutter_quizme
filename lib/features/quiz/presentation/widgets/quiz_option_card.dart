import 'package:flutter/material.dart';
import 'package:flutter_quizme/core/utils/app_colors.dart';

class QuizOptionCard extends StatefulWidget {
  final String optionText;
  final bool isCorrect;
  final VoidCallback onTap;
  final Key questionKey;

  const QuizOptionCard({
    super.key,
    required this.optionText,
    required this.isCorrect,
    required this.onTap,
    required this.questionKey, // Make this required
  });

  @override
  State createState() => _QuizOptionCardState();
}

class _QuizOptionCardState extends State<QuizOptionCard> {
  bool _isSelected = false;

  @override
  void didUpdateWidget(QuizOptionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.questionKey != widget.questionKey) {
      setState(() {
        _isSelected = false;
      });
    }
  }

  void _handleTap() {
    setState(() {
      _isSelected = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      widget.onTap();
    });
  }

  Color _getCardColor() {
    if (!_isSelected) {
      return AppColors.primaryBlue.withOpacity(1);
    }
    return widget.isCorrect ? Colors.green.shade500 : Colors.red.shade500;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getCardColor(),
            _getCardColor().withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _isSelected
                ? (_getCardColor()).withOpacity(0.5)
                : Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: _isSelected ? null : _handleTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.optionText,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: _isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
                if (_isSelected)
                  Icon(
                    widget.isCorrect
                        ? Icons.check_circle
                        : Icons.cancel,
                    color: Colors.white,
                    size: 24,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}