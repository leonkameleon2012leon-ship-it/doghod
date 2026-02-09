# DogHot - Game Architecture Documentation

## Overview
DogHot is a casual mobile pet simulation game built with Flutter and Flame game engine. This document describes the complete architecture and code organization.

## Project Structure

```
lib/
├── core/                      # Core game systems
│   ├── constants/            # Game constants and configuration
│   │   ├── game_constants.dart       # Numerical values, decay rates, rewards
│   │   ├── visual_constants.dart     # Colors, sizes, gradients, animations
│   │   └── asset_paths.dart          # Asset file paths and helpers
│   ├── managers/             # State management
│   │   └── game_manager.dart         # Central game state controller
│   └── services/             # Persistent storage services
│       ├── storage_service.dart      # SharedPreferences wrapper
│       └── save_service.dart         # Game state serialization
│
├── models/                    # Data models
│   ├── dog_model.dart                # Dog state, stats, mood, level
│   ├── game_state.dart               # Overall game progress
│   └── minigame_result.dart          # Minigame completion rewards
│
├── widgets/                   # Reusable UI components
│   ├── stat_bar.dart                 # Thick rounded progress bars
│   ├── game_button.dart              # Large gradient action buttons
│   ├── dog_character.dart            # Animated dog display
│   ├── coin_display.dart             # Currency UI widget
│   ├── reward_popup.dart             # Post-game reward screen
│   └── gradient_background.dart      # Background container
│
├── screens/                   # Main app screens
│   ├── home_screen.dart              # Main hub with dog and stats
│   ├── feeding_game_screen.dart      # Feeding Frenzy wrapper
│   └── pipes_game_screen.dart        # Pipe Fix game
│
├── games/                     # Minigame implementations
│   └── feeding_game.dart             # Flame-based feeding game
│
├── i18n.dart                  # Internationalization (EN/PL)
└── main.dart                  # App entry point
```

## Core Architecture

### State Management
The app uses a centralized `GameManager` that extends `ChangeNotifier` for reactive state updates.

**Key responsibilities:**
- Load/save game state
- Apply time-based stat decay
- Handle minigame rewards
- Manage language settings
- Auto-save every 30 seconds

### Data Flow
```
User Action → Screen → GameManager → Model Update → Save Service → Storage
                 ↓
            UI Update (via ChangeNotifier)
```

### Models

#### DogModel
Represents the pet's state:
- Stats: hunger, happiness, cleanliness (0-100)
- Level and XP progression
- Mood calculation based on stat thresholds
- Time-based decay application

**Moods:**
- Happy (all stats > 70%)
- Content (balanced stats)
- Hungry (hunger < 50%)
- Sad (happiness < 50%)
- Dirty (cleanliness < 40%)
- Critical (any stat < 30%)

#### GameState
Complete game progress:
- Dog reference
- Currency (coins, stars)
- High scores per game
- Achievements
- Daily food preferences
- Language preference

#### MinigameResult
Standardized reward structure:
- Score and star rating (1-3 stars)
- Coins and XP earned
- Stat changes (hunger, happiness, cleanliness)
- Play duration

### Services

#### StorageService
Type-safe wrapper around SharedPreferences:
- String, int, double, bool primitives
- JSON object serialization
- Error handling with fallbacks

#### SaveService
Game state persistence:
- Serialize/deserialize GameState
- Apply time decay on load
- Handle daily resets
- Backup/restore functionality

## Minigames

### Feeding Frenzy (Flame Game)
**Objective:** Tap falling food items to feed the dog.

**Mechanics:**
- 30-second timer
- 4 food types with different colors
- Preferred food (3 points) vs normal food (1 point)
- Larger tap hitboxes for mobile
- Gradient food sprites with shadows

**Rewards:**
- Hunger boost based on score
- Coins = score / 2
- Star rating at 10/20/35 points

### Pipe Fix (Custom Paint)
**Objective:** Rotate pipe tiles to match target pattern.

**Mechanics:**
- 4x4 grid of L-shaped pipes
- Tap to rotate 90 degrees
- Visual feedback when correct (green gradient)
- Move counter for star rating

**Rewards:**
- Cleanliness boost
- Stars based on moves vs par (16 moves)
- Bonus rewards for efficiency

## Visual Design

### Color Scheme
- **Primary:** #FF6B6B (warm red/pink)
- **Secondary:** #4ECDC4 (teal)
- **Accent:** #FFE66D (yellow)

### Stat Colors
- **Hunger:** Red-orange gradient
- **Happiness:** Teal-green gradient  
- **Cleanliness:** Blue gradient

### Design Principles
- Large, tappable buttons (60px height)
- Thick stat bars (40px height) with percentages
- Rounded corners (24px radius)
- Gradient backgrounds and buttons
- Shadow effects for depth
- Animated dog character with mood states

## Game Loop

### Initialization
1. Load saved game state from storage
2. Apply time-based decay since last play
3. Check for new day (reset daily foods)
4. Start auto-save timer

### Main Loop
1. User views home screen with dog and stats
2. User plays minigame
3. Minigame returns result with rewards
4. GameManager applies stat changes
5. Dog mood updates based on new stats
6. State auto-saves

### Time-Based Decay
Runs when app resumes or on manual check:
- Hunger: -1% per hour
- Happiness: -0.5% per hour
- Cleanliness: -0.3% per hour

## Localization
Supports English and Polish via `I18n` class:
- Static dictionary with key-value pairs
- Template strings with parameter replacement
- Language persisted in game state

## Asset Management
Assets are optional with fallback to Material Icons:
- Dog animations (Lottie JSON) - fallback to Icons.pets
- Food sprites - fallback to colored circles
- UI icons - use Material Icons

## Performance Considerations
- Single GameManager instance
- Auto-save throttled to 30 seconds
- Flame game engine for 60 FPS minigames
- Efficient rebuilds via AnimatedBuilder
- Dispose timers and controllers properly

## Future Expansion Points
- Additional minigames
- Dog breeds/skins system
- Achievement system
- Daily challenges
- Coin shop
- Sound effects
- Particle systems
- Animation improvements

## Dependencies
```yaml
flutter: SDK
flame: ^1.13.1          # Game engine
shared_preferences: ^2.2.2  # Storage
```

## Testing Strategy
- Unit tests for models (stat calculations, JSON serialization)
- Widget tests for UI components
- Integration tests for save/load flow
- Manual testing on web and mobile platforms

## Code Quality Standards
- Defensive programming with null safety
- Try-catch blocks around I/O operations
- Fallback values for all late-init fields
- Consistent naming (camelCase)
- Type-safe APIs (no dynamic)
- Documentation on public classes
- Max 300 lines per file
