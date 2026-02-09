import 'package:flutter/material.dart';

import '../doghog_controller.dart';
import '../i18n.dart';
import 'feeding_game_screen.dart';
import 'pipes_game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.controller});

  final DogHogController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(I18n.tr('appTitle')),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.monetization_on, size: 20, color: Colors.amber[700]),
                    const SizedBox(width: 4),
                    Text(
                      '${controller.happiness}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.amber[700],
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.language),
                onSelected: (value) => controller.setLanguage(value),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'en',
                    child: Text(I18n.tr('english')),
                  ),
                  PopupMenuItem(
                    value: 'pl',
                    child: Text(I18n.tr('polish')),
                  ),
                ],
              ),
            ],
          ),
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Dog Card
                          Card(
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  Container(
                                    height: 120,
                                    width: 120,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFE8C2),
                                      borderRadius: BorderRadius.circular(60),
                                    ),
                                    child: const Icon(
                                      Icons.pets,
                                      size: 70,
                                      color: Color(0xFF8D6E63),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    I18n.tr('petName'),
                                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    I18n.tr('welcome'),
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: Colors.grey[600],
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Stats Section
                          _CompactStatRow(
                            label: I18n.tr('hunger'),
                            value: controller.hunger,
                            color: const Color(0xFFE76F51),
                            icon: Icons.restaurant,
                          ),
                          const SizedBox(height: 12),
                          _CompactStatRow(
                            label: I18n.tr('happiness'),
                            value: controller.happiness,
                            color: const Color(0xFF2A9D8F),
                            icon: Icons.sentiment_very_satisfied,
                          ),
                          const SizedBox(height: 12),
                          _CompactStatRow(
                            label: I18n.tr('cleanliness'),
                            value: controller.cleanliness,
                            color: const Color(0xFF457B9D),
                            icon: Icons.water_drop,
                          ),
                          const SizedBox(height: 24),
                          // Action Buttons
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => FeedingGameScreen(controller: controller),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.restaurant),
                                  label: Text(I18n.tr('playFeeding')),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    backgroundColor: const Color(0xFFE76F51),
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => PipesGameScreen(controller: controller),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.water_drop),
                                  label: Text(I18n.tr('playWater')),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    backgroundColor: const Color(0xFF457B9D),
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _CompactStatRow extends StatelessWidget {
  const _CompactStatRow({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String label;
  final int value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: value / 100,
                  minHeight: 10,
                  color: color,
                  backgroundColor: color.withOpacity(0.2),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$value%',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: color,
          ),
        ),
      ],
    );
  }
}
