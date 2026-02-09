import 'package:flutter/material.dart';

import 'core/managers/game_manager.dart';
import 'core/services/storage_service.dart';
import 'i18n.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  final storageService = StorageService();
  await storageService.init();
  
  // Initialize game manager
  final gameManager = GameManager(storageService);
  await gameManager.init();
  
  runApp(DogHogApp(gameManager: gameManager));
}

class DogHogApp extends StatefulWidget {
  const DogHogApp({super.key, required this.gameManager});

  final GameManager gameManager;

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
    widget.gameManager.handleLifecycle(state);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.gameManager,
      builder: (context, _) {
        // Set language from game state
        I18n.setLanguage(widget.gameManager.gameState.languageCode);
        
        return MaterialApp(
          title: I18n.tr('appTitle'),
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF2A9D8F),
              brightness: Brightness.light,
            ),
            useMaterial3: true,
            scaffoldBackgroundColor: const Color(0xFFF0F7FF),
            cardTheme: CardTheme(
              elevation: 8,
              shadowColor: Colors.black.withOpacity(0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                elevation: 6,
                shadowColor: Colors.black.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            appBarTheme: const AppBarTheme(
              elevation: 0,
              centerTitle: true,
              titleTextStyle: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          home: HomeScreen(gameManager: widget.gameManager),
        );
      },
    );
  }
}
