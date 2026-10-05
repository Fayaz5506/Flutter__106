import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientation and UI overlays
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(
    ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: const DailyWinApp(),
    ),
  );
}

class DailyWinApp extends StatelessWidget {
  const DailyWinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        return MaterialApp(
          title: 'DailyWin',
          debugShowCheckedModeBanner: false,
          themeMode: provider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          theme: AppTheme.lightTheme(),
          darkTheme: AppTheme.darkTheme(),
          home: const SplashScreen(),
        );
      },
    );
  }
}
