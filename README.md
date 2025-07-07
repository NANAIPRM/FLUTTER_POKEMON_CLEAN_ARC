# 🔴⚪ Pokémon Clean Architecture App

A modern Flutter application implementing Clean Architecture principles with BLoC state management for browsing Pokémon data from the PokéAPI.

<div align="center">
  <img src="assets/icon/pokeball_icon.png" alt="Pokémon App Icon" width="100" height="100"/>
</div>

## ✨ Features

- 🎯 **Clean Architecture** - Separation of concerns with Domain, Data, and Presentation layers
- 🔄 **BLoC State Management** - Reactive state management with flutter_bloc
- 🚀 **Modern Navigation** - Declarative routing with go_router
- 🌐 **API Integration** - Fetches data from PokéAPI (https://pokeapi.co/)
- 💾 **Offline Support** - Local caching with SharedPreferences
- 🔍 **Search Functionality** - Search Pokémon by name
- ♾️ **Infinite Scroll** - Pagination with smooth loading
- 📱 **Responsive UI** - Beautiful and modern user interface
- 🧪 **Comprehensive Testing** - Unit, widget, and integration tests
- 🎨 **Custom App Icon** - Pokéball themed application icon

## 🏗️ Architecture Overview

This project follows **Clean Architecture** principles with three main layers:

```
📱 Presentation Layer (UI)
├── 🎭 BLoC (Business Logic Component)
├── 📄 Pages (Screens)
└── 🧩 Widgets (Reusable UI Components)

💼 Domain Layer (Business Logic)
├── 🏢 Entities (Core Models)
├── 📋 Repositories (Abstract Contracts)
└── ⚙️ Use Cases (Business Rules)

📊 Data Layer (External Concerns)
├── 🌐 Remote Data Sources (API)
├── 💾 Local Data Sources (Cache)
├── 🔄 Repository Implementations
└── 📦 Models (Data Transfer Objects)
```

### 🎯 Layer Responsibilities

- **Presentation**: UI components, state management, user interactions
- **Domain**: Business logic, entities, use cases (framework independent)
- **Data**: API calls, local storage, data mapping and caching

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.5.2)
- Dart SDK
- Android Studio / VS Code
- iOS Simulator / Android Emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/flutter_pokemon_clean_arc.git
   cd flutter_pokemon_clean_arc
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code (for JSON serialization)**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 📁 Project Structure

```
lib/
├── 🎯 main.dart                          # App entry point
├── 🔧 injection_container.dart           # Dependency injection setup
├── 🏗️ core/                              # Core utilities and shared code
│   ├── 🔗 constants/                     # API constants
│   ├── ❌ error/                         # Error handling
│   ├── 🌐 network/                       # Network configuration
│   ├── 🧭 router/                        # App routing
│   └── 🛠️ utils/                         # Helper utilities
└── 🎮 features/pokemon/                   # Pokemon feature
    ├── 📊 data/                          # Data layer
    │   ├── 🗂️ datasources/               # API & Local data sources
    │   ├── 📦 models/                    # Data models
    │   └── 🔄 repositories/              # Repository implementations
    ├── 💼 domain/                        # Domain layer
    │   ├── 🏢 entities/                  # Core entities
    │   ├── 📋 repositories/              # Repository contracts
    │   └── ⚙️ usecases/                  # Business use cases
    └── 📱 presentation/                  # Presentation layer
        ├── 🎭 bloc/                      # BLoC state management
        ├── 📄 pages/                     # App screens
        └── 🧩 widgets/                   # Reusable widgets

test/                                     # Test files (mirrors lib structure)
├── 🧪 core/                              # Core tests
├── 🎮 features/pokemon/                   # Pokemon feature tests
└── 🔗 pokemon_app_integration_test.dart  # Integration tests
```

## 🛠️ Tech Stack

### Core Technologies
- **Flutter** - UI framework
- **Dart** - Programming language

### State Management
- **flutter_bloc** - BLoC pattern implementation
- **equatable** - Value equality

### Navigation
- **go_router** - Declarative routing

### Network & Data
- **dio** - HTTP client
- **shared_preferences** - Local storage
- **internet_connection_checker** - Network connectivity

### Dependency Injection
- **get_it** - Service locator

### Functional Programming
- **dartz** - Functional programming (Either type)

### Serialization
- **json_annotation** - JSON serialization
- **json_serializable** - Code generation

### Testing
- **mockito** - Mocking framework
- **bloc_test** - BLoC testing utilities

### Development Tools
- **build_runner** - Code generation
- **flutter_launcher_icons** - App icon generation

## 🧪 Testing

The project includes comprehensive test coverage:

### Run All Tests
```bash
flutter test
```

### Test Categories

- **Unit Tests**: Domain layer logic and use cases
- **Widget Tests**: Individual widget behavior
- **Integration Tests**: Complete user flows
- **BLoC Tests**: State management logic

### Test Coverage
```bash
# Generate coverage report
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## 📱 Features Showcase

### 🏠 Pokémon List
- View all Pokémon in a scrollable list
- Each card shows image, name, ID, and types
- Infinite scroll with automatic loading
- Pull-to-refresh functionality

### 🔍 Search
- Real-time search by Pokémon name
- Debounced search input for performance
- Clear search functionality

### 📋 Pokémon Details
- Detailed view with high-resolution image
- Physical stats (height, weight)
- Type information with color coding
- Smooth hero animations

### 🔄 State Management
- Loading states with smooth indicators
- Error handling with retry functionality
- Offline support with cached data

## 🎨 Design Patterns Used

- **Clean Architecture** - Separation of concerns
- **Repository Pattern** - Data access abstraction
- **BLoC Pattern** - Reactive state management
- **Dependency Injection** - Loose coupling
- **Factory Pattern** - Object creation
- **Observer Pattern** - Event-driven architecture

## 🌐 API Integration

This app integrates with the [PokéAPI](https://pokeapi.co/):
- **Base URL**: `https://pokeapi.co/api/v2/`
- **Endpoints Used**:
  - `GET /pokemon` - List of Pokémon
  - `GET /pokemon/{id}` - Individual Pokémon details
  - `GET /pokemon/{name}` - Pokémon by name

## 🔧 Configuration

### Environment Setup
The app supports different environments through configuration:

```dart
class ApiConstants {
  static const String baseUrl = 'https://pokeapi.co/api/v2/';
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
}
```

## 🚀 Build & Release

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style Guidelines
- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable and function names
- Add documentation for public APIs
- Write tests for new features
- Ensure all tests pass before submitting PR

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [PokéAPI](https://pokeapi.co/) - The RESTful Pokémon API
- [Flutter Team](https://flutter.dev/) - Amazing framework
- [BLoC Library](https://bloclibrary.dev/) - State management solution
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) - Architecture principles

---

<div align="center">
  <p>Made with ❤️ and Flutter</p>
  <p>🔴⚪ Gotta Code 'Em All! ⚪🔴</p>
</div>
