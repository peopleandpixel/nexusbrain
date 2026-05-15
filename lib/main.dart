import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'core/database/isar_service.dart';
import 'presentation/theme.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/state/theme_state.dart';
import 'presentation/state/locale_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await IsarService.init();
  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: const [Locale('de'), Locale('en')],
        path: 'assets/translations',
        fallbackLocale: const Locale('de'),
        child: const NexusBrainApp(),
      ),
    ),
  );
}

class NexusBrainApp extends ConsumerWidget {
  const NexusBrainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      title: 'NexusBrain',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        ...context.localizationDelegates,
      ],
      supportedLocales: context.supportedLocales,
      locale: locale,
      theme: NexusBrainTheme.light,
      darkTheme: NexusBrainTheme.dark,
      themeMode: switch (themeMode) {
        AppThemeMode.light => ThemeMode.light,
        AppThemeMode.dark => ThemeMode.dark,
        AppThemeMode.system => ThemeMode.system,
      },
      home: const HomePage(),
    );
  }
}
