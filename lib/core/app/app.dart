import 'package:flutter/material.dart';
import 'package:flutter_quizme/core/navigation/app_routes.dart';
import 'package:flutter_quizme/core/navigation/route_names.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/quiz/provider/quiz_provider.dart';
import '../theme/app_theme.dart';
import '../theme/theme_provider.dart';

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Quiz App',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            initialRoute: RouteNames.splash,
            navigatorKey: AppNavigator.navigatorKey,
            onGenerateRoute: AppNavigator.onGenerateRoute,
          );
        },
      ),
    );
  }
}
