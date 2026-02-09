# DogHot - Casual Mobile Pet Game 🐕

A fun, casual mobile game where you take care of your virtual pet dog by playing minigames and managing their stats!

## Features

- 🐶 **Animated Dog Character** with mood-based expressions
- 📊 **Three Core Stats:** Hunger, Happiness, and Cleanliness
- 🎮 **Two Minigames:**
  - **Feeding Frenzy:** Tap falling food items to feed your dog
  - **Pipe Fix:** Rotate pipes to match the target pattern
- ⭐ **Progression System:** Level up your dog with XP and stars
- 💾 **Auto-Save:** Your progress is automatically saved
- ⏰ **Time-Based Decay:** Stats naturally decrease over time
- 🌍 **Multi-Language:** English and Polish support
- 📱 **Responsive Design:** Works on mobile and web

## Getting Started

### Prerequisites
- Flutter SDK (3.1.0 or higher)
- Dart SDK (included with Flutter)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/leonkameleon2012leon-ship-it/doghod.git
cd doghod
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
# For web
flutter run -d chrome

# For mobile (with device connected)
flutter run
```

## Project Structure

See [ARCHITECTURE.md](ARCHITECTURE.md) for detailed documentation on the codebase structure.

```
lib/
├── core/          # Game systems (managers, services, constants)
├── models/        # Data models (dog, game state, results)
├── widgets/       # Reusable UI components
├── screens/       # Main app screens
├── games/         # Minigame implementations
├── i18n.dart      # Internationalization
└── main.dart      # App entry point
```

## Free Assets Guide

The game is designed to work with **fallback icons** when assets are missing. However, you can enhance the visual experience by adding your own assets from these FREE sources:

### Dog Animations (Lottie)
**Source:** [LottieFiles.com](https://lottiefiles.com)
- Search for "dog" and filter by "Free"
- Download JSON files and place in `assets/animations/dog/`
- Recommended: idle.json, happy.json, sad.json, eating.json

**Example Free Animations:**
- [Cute Dog Animation](https://lottiefiles.com/free-animation/dog-Y9vM4r8nKb)
- [Happy Dog](https://lottiefiles.com/animations/dog)

### Food Sprites
**Sources:**
- [Kenney.nl](https://kenney.nl/assets) - Public domain game assets
- [OpenGameArt.org](https://opengameart.org) - CC0 license assets
- [itch.io](https://itch.io/game-assets/free/tag-food) - Free food sprites

**What you need:**
- sausage.png
- chicken.png
- carrot.png
- bone.png
- fish.png

Place in `assets/images/food/`

### UI Icons
The app uses **Material Icons** by default, so additional UI assets are optional.

### Sound Effects (Optional)
**Sources:**
- [Freesound.org](https://freesound.org) - CC0 sounds
- [ZapSplat](https://www.zapsplat.com) - Free sound effects

Place in `assets/sounds/`

### Important Notes
- ✅ The app works perfectly **without** any assets using Material Icons and emoji
- ✅ All asset sources above are **100% free** for personal and commercial use
- ✅ Always check the license before using any asset
- ❌ **Never** use copyrighted content without permission

## Game Mechanics

### Stats Management
- **Hunger:** Decreases 1% per hour. Play Feeding Frenzy to restore.
- **Happiness:** Decreases 0.5% per hour. Increases with any minigame.
- **Cleanliness:** Decreases 0.3% per hour. Play Pipe Fix to restore.

### Dog Moods
Your dog's mood changes based on their stats:
- 🎉 **Happy:** All stats above 70%
- 😊 **Content:** Balanced stats
- 🍖 **Hungry:** Hunger below 50%
- 😔 **Sad:** Happiness below 50%
- 🛁 **Dirty:** Cleanliness below 40%
- 😰 **Critical:** Any stat below 30%

### Feeding Frenzy
- Duration: 30 seconds
- Tap falling food items
- Preferred food = 3 points
- Normal food = 1 point
- Star rating: 1★ at 10pts, 2★ at 20pts, 3★ at 35pts

### Pipe Fix
- Rotate all pipes to match the target pattern
- Par moves: 16
- Star rating based on efficiency:
  - 3★: ≤16 moves
  - 2★: 17-21 moves
  - 1★: 22+ moves

## Development

### Building for Production

**Web:**
```bash
flutter build web --release
```

**Android:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

### Code Quality
- Null-safe Dart code
- Defensive programming with try-catch
- Comprehensive error handling
- No late-init crashes
- Clean architecture with separation of concerns

## Contributing

Contributions are welcome! Please follow these guidelines:
1. Fork the repository
2. Create a feature branch
3. Write clean, documented code
4. Test thoroughly
5. Submit a pull request

## License

This project is open source. Assets you add must be properly licensed for your use case.

## Credits

- Built with [Flutter](https://flutter.dev)
- Game engine: [Flame](https://flame-engine.org)
- Icons: [Material Design Icons](https://fonts.google.com/icons)

## Support

For issues, questions, or suggestions:
- Open an issue on GitHub
- Check the [ARCHITECTURE.md](ARCHITECTURE.md) for technical details

---

**Made with ❤️ for casual mobile gaming**