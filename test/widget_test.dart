import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:markdown_creator/main.dart';
import 'package:markdown_creator/providers/project_provider.dart';
import 'package:markdown_creator/providers/library_provider.dart';
import 'package:markdown_creator/services/subscription_service.dart';

void main() {
  testWidgets('App loads and shows title', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({'hasSeenOnboarding': true});

    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;

    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ProjectProvider()),
          ChangeNotifierProvider(
            create: (_) => LibraryProvider(isFirebaseAvailable: false),
          ),
          ChangeNotifierProvider(
            create: (_) => SubscriptionService(isFirebaseAvailable: false),
          ),
        ],
        child: const MarkdownCreatorApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Markdown Creator'), findsOneWidget);
    expect(find.text('Components'), findsOneWidget);
  });
}
