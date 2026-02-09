import 'package:flutter/material.dart';

import 'doghog_controller.dart';
import 'i18n.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = DogHogController();
  await controller.load();
  runApp(DogHogApp(controller: controller));
}

class DogHogApp extends StatefulWidget {
  const DogHogApp({super.key, required this.controller});

  final DogHogController controller;

  @override
  State<DogHogApp> createState() => _DogHogAppState();
}

class _DogHogAppState extends State<DogHogApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    widget.controller.handleLifecycle(state);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        return MaterialApp(
          title: I18n.tr('appTitle'),
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2A9D8F)),
            useMaterial3: true,
          ),
          home: HomeScreen(controller: widget.controller),
        );
      },
    );
  }
}
