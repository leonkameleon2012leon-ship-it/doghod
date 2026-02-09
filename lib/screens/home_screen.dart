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
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Text(
                      I18n.tr('language'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Spacer(),
                    DropdownButton<String>(
                      value: controller.languageCode,
                      onChanged: (value) {
                        if (value != null) {
                          controller.setLanguage(value);
                        }
                      },
                      items: [
                        DropdownMenuItem(
                          value: 'en',
                          child: Text(I18n.tr('english')),
                        ),
                        DropdownMenuItem(
                          value: 'es',
                          child: Text(I18n.tr('spanish')),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Center(
                  child: Column(
                    children: [
                      Container(
                        height: 140,
                        width: 140,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE8C2),
                          borderRadius: BorderRadius.circular(70),
                        ),
                        child: const Icon(
                          Icons.pets,
                          size: 80,
                          color: Color(0xFF8D6E63),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        I18n.tr('petName'),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        I18n.tr('welcome'),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  I18n.tr('statsTitle'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                _StatCard(
                  label: I18n.tr('hunger'),
                  value: controller.hunger,
                  color: const Color(0xFFE76F51),
                ),
                _StatCard(
                  label: I18n.tr('happiness'),
                  value: controller.happiness,
                  color: const Color(0xFF2A9D8F),
                ),
                _StatCard(
                  label: I18n.tr('cleanliness'),
                  value: controller.cleanliness,
                  color: const Color(0xFF457B9D),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => FeedingGameScreen(controller: controller),
                      ),
                    );
                  },
                  child: Text(I18n.tr('playFeeding')),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PipesGameScreen(controller: controller),
                      ),
                    );
                  },
                  child: Text(I18n.tr('playPipes')),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(I18n.trf('statValue', {
              'label': label,
              'value': '$value%',
            })),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: value / 100,
                minHeight: 12,
                color: color,
                backgroundColor: color.withOpacity(0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
