import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexusbrain/main.dart';
import 'package:nexusbrain/presentation/pages/onboarding/onboarding_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App starts and shows Onboarding', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({'onboarding_completed': false});
    
    await tester.pumpWidget(
      const ProviderScope(
        child: NexusBrainApp(),
      ),
    );
    
    await tester.pumpAndSettle();
    
    // OnboardingPage should be shown
    expect(find.byType(OnboardingPage), findsOneWidget);
  });
}
