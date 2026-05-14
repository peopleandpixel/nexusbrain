import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/theme.dart';
import 'presentation/pages/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: NexusBrainApp()));
}

class NexusBrainApp extends StatelessWidget {
  const NexusBrainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NexusBrain',
      debugShowCheckedModeBanner: false,
      theme: NexusBrainTheme.dark,
      home: const HomePage(),
    );
  }
}
