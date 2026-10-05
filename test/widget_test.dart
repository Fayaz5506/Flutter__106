import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:dailywin/providers/app_provider.dart';
import 'package:dailywin/screens/main_screen.dart';
import 'package:dailywin/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('DailyWin main screen renders greeting header and navigation tabs', (WidgetTester tester) async {
    final provider = AppProvider();
    await provider.init();

    await tester.pumpWidget(
      ChangeNotifierProvider<AppProvider>.value(
        value: provider,
        child: MaterialApp(
          theme: AppTheme.lightTheme(),
          home: const MainScreen(),
        ),
      ),
    );

    // Initial frame render
    await tester.pump();

    // Verify main screen elements
    expect(find.text('DailyWin'), findsWidgets);
    expect(find.text('Daily Progress'), findsOneWidget);
    expect(find.text('Tasks'), findsWidgets);
    expect(find.text('Habits'), findsWidgets);
    expect(find.text('Streaks'), findsWidgets);
  });
}
