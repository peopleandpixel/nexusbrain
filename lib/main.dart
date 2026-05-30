import 'package:dynamic_color/dynamic_color.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' as material show ThemeMode;
import 'package:flutter/material.dart' hide ThemeMode, KeyboardListener;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' show KeyboardListener;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexusbrain/domain/models/page.dart' as domain;
import 'package:nexusbrain/presentation/state/notes_state.dart';
import 'package:nexusbrain/presentation/state/shortcut_state.dart';
import 'package:nexusbrain/presentation/widgets/common/shortcut_overlay.dart';

import 'core/database/isar_service.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/notes/block_editor_page.dart';
import 'presentation/state/locale_state.dart';
import 'presentation/state/theme_state.dart' as state;
import 'presentation/state/theme_state.dart' show AppThemeMode;
import 'presentation/theme.dart';
import 'presentation/widgets/common/biometric_auth_guard.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  
  if (args.firstOrNull == 'multi_window') {
    // final windowId = int.parse(args[1]);
    final argument = args[2]; // pageId
    await EasyLocalization.ensureInitialized();
    await IsarService.init();
    
    runApp(
      ProviderScope(
        child: EasyLocalization(
          supportedLocales: const [
            Locale('de'),
            Locale('en'),
            Locale('es'),
            Locale('fr'),
            Locale('it'),
          ],
          path: 'assets/translations',
          fallbackLocale: const Locale('en'),
          child: NexusBrainMultiWindowApp(pageId: argument),
        ),
      ),
    );
    return;
  }

  await EasyLocalization.ensureInitialized();
  await IsarService.init();
  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: const [
          Locale('de'),
          Locale('en'),
          Locale('es'),
          Locale('fr'),
          Locale('it'),
        ],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        child: const NexusBrainApp(),
      ),
    ),
  );
}

class NexusBrainMultiWindowApp extends ConsumerWidget {
  final String pageId;
  const NexusBrainMultiWindowApp({super.key, required this.pageId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeModeValue = ref.watch(state.themeModeProvider);
    final locale = ref.watch(localeProvider);

    return FutureBuilder<domain.Page?>(
      future: ref.read(blockRepositoryProvider).getPageByPageId(pageId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator())));
        }
        return MaterialApp(
          title: 'NexusBrain - Editor',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: locale,
          theme: NexusBrainTheme.light,
          darkTheme: NexusBrainTheme.dark,
          themeMode: switch (themeModeValue) {
            AppThemeMode.light => material.ThemeMode.light,
            AppThemeMode.dark => material.ThemeMode.dark,
            AppThemeMode.system => material.ThemeMode.system,
          },
          home: Stack(
            children: [
              BlockEditorPage(page: snapshot.data!),
              const ShortcutOverlay(),
            ],
          ),
        );
      },
    );
  }
}

class NexusBrainApp extends ConsumerWidget {
  const NexusBrainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeModeValue = ref.watch(state.themeModeProvider);
    final locale = ref.watch(localeProvider);

    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightScheme;
        ColorScheme darkScheme;

        if (lightDynamic != null && darkDynamic != null) {
          lightScheme = lightDynamic.harmonized();
          darkScheme = darkDynamic.harmonized();
        } else {
          lightScheme = NexusBrainTheme.light.colorScheme;
          darkScheme = NexusBrainTheme.dark.colorScheme;
        }

        return KeyboardListener(
          focusNode: FocusNode(),
          onKeyEvent: (event) {
            if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.slash && HardwareKeyboard.instance.isShiftPressed) {
              ref.read(shortcutOverlayStateProvider.notifier).toggle();
            }
          },
          child: MaterialApp(
            title: 'NexusBrain',
            debugShowCheckedModeBanner: false,
            localizationsDelegates: [
              ...context.localizationDelegates,
            ],
            supportedLocales: context.supportedLocales,
            locale: locale,
            theme: NexusBrainTheme.light.copyWith(colorScheme: lightScheme),
            darkTheme: NexusBrainTheme.dark.copyWith(colorScheme: darkScheme),
            themeMode: switch (themeModeValue) {
              state.AppThemeMode.light => material.ThemeMode.light,
              state.AppThemeMode.dark => material.ThemeMode.dark,
              state.AppThemeMode.system => material.ThemeMode.system,
            },
            home: const BiometricAuthGuard(
              child: HomePage(),
            ),
          ),
        );
      },
    );
  }
}
