import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:nexusbrain/data/repositories/isar_block_repository.dart';
import 'package:nexusbrain/domain/models/block.dart';
import 'package:nexusbrain/domain/models/page.dart' as domain;
import 'package:nexusbrain/domain/models/tag.dart';
import 'package:nexusbrain/presentation/pages/home_page.dart';
import 'package:nexusbrain/presentation/pages/notes/notes_page.dart';
import 'package:nexusbrain/presentation/state/notes_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late Isar isar;

  setUpAll(() async {
    HttpOverrides.global = null;
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    isar = await Isar.open(
      [domain.PageSchema, BlockSchema, TagSchema],
      directory: Directory.systemTemp.path,
      name: 'test_widget_db_${DateTime.now().millisecondsSinceEpoch}',
    );
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
  });

  testWidgets('HomePage shows NotesPage by default', (WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            blockRepositoryProvider.overrideWithValue(IsarBlockRepository(isar: isar)),
          ],
          child: EasyLocalization(
            supportedLocales: const [
              Locale('en'),
              Locale('de'),
              Locale('es'),
              Locale('fr'),
              Locale('it'),
            ],
            path: 'assets/translations',
            fallbackLocale: const Locale('en'),
            startLocale: const Locale('en'),
            saveLocale: false,
            useOnlyLangCode: true,
            child: Builder(
              builder: (context) => MaterialApp(
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                home: const HomePage(),
              ),
            ),
          ),
        ),
      );
      // Warten bis EasyLocalization geladen hat
      await tester.pump();
      await Future.delayed(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();
    });

    expect(find.byType(NotesPage), findsOneWidget);
    expect(find.text('NexusBrain'), findsNWidgets(2));
  });
}
