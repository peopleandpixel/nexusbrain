import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexusbrain/data/services/mobile_service.dart';
import 'package:nexusbrain/main.dart';
import 'package:nexusbrain/presentation/state/onboarding_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockMobileService extends MobileService {
  @override
  void build() {}
}

class MockOnboardingState extends OnboardingState {
  final bool initialValue;
  MockOnboardingState(this.initialValue);
  @override
  bool build() => initialValue;
}

void main() {
  setUpAll(() async {
    HttpOverrides.global = null;
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  testWidgets('Screenshot Onboarding', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1080 / 2, 2400 / 2));
    
    await tester.runAsync(() async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            mobileServiceProvider.overrideWith(() => MockMobileService()),
            onboardingStateProvider.overrideWith(() => MockOnboardingState(false)),
          ],
          child: EasyLocalization(
            supportedLocales: const [Locale('de')],
            path: 'assets/translations',
            fallbackLocale: const Locale('de'),
            startLocale: const Locale('de'),
            child: const NexusBrainApp(),
          ),
        ),
      );
      await tester.pump();
      await Future.delayed(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
    });

    await expectLater(
      find.byType(NexusBrainApp),
      matchesGoldenFile('goldens/onboarding_1.png'),
    );

    // Click Next
    await tester.tap(find.text('Weiter'));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(NexusBrainApp),
      matchesGoldenFile('goldens/onboarding_2.png'),
    );
  });

  testWidgets('Screenshot Home', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1080 / 2, 2400 / 2));
    
    await tester.runAsync(() async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            mobileServiceProvider.overrideWith(() => MockMobileService()),
            onboardingStateProvider.overrideWith(() => MockOnboardingState(true)),
          ],
          child: EasyLocalization(
            supportedLocales: const [Locale('de')],
            path: 'assets/translations',
            fallbackLocale: const Locale('de'),
            startLocale: const Locale('de'),
            child: const NexusBrainApp(),
          ),
        ),
      );
      await tester.pump();
      await Future.delayed(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
    });

    await expectLater(
      find.byType(NexusBrainApp),
      matchesGoldenFile('goldens/home_notes.png'),
    );

    // Switch to Graph
    await tester.tap(find.byIcon(Icons.account_tree_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500)); // AnimatedSwitcher

    await expectLater(
      find.byType(NexusBrainApp),
      matchesGoldenFile('goldens/home_graph.png'),
    );

    // Switch to Settings
    await tester.tap(find.byIcon(Icons.settings_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    await expectLater(
      find.byType(NexusBrainApp),
      matchesGoldenFile('goldens/home_settings.png'),
    );
  });
}
