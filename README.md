# Ecommerce-Flutter

A modern, high-performance e-commerce Flutter application developed by **Nafis Rayan**.

This cross-platform e-commerce application provides a seamless shopping experience across iOS, Android, and Web platforms. Built with Flutter, it features a modern UI design, smooth animations, and comprehensive e-commerce functionality.

## 🚀 Features

### Core Functionality
- **Product Browsing**: Browse through various product categories with smooth navigation
- **Search Functionality**: Advanced search capabilities to find products quickly
- **Product Details**: Detailed product pages with descriptions, ratings, and reviews
- **Shopping Cart**: Add products to cart with quantity management
- **Special Offers**: Dedicated section for promotional offers and discounts
- **User Profile**: Complete user profile management system

### UI/UX Features
- **Modern Design**: Clean, intuitive interface following Material Design principles
- **Responsive Layout**: Optimized for different screen sizes and orientations
- **Smooth Animations**: Fluid transitions and micro-interactions
- **Dark Mode Support**: Toggle between light and dark themes
- **Custom Icons**: Beautifully crafted custom icons throughout the app

### Technical Features
- **Cross-Platform**: Single codebase for iOS, Android, and Web
- **State Management**: Efficient state management for optimal performance
- **Custom Components**: Reusable UI components for consistency
- **Asset Management**: Organized asset structure for icons and images

## 📱 Screenshots

**Available on iOS, Android, and Web platforms.**

![](./preview/Preview%203.png)

## 🛠️ Technology Stack

- **Framework**: Flutter 3.x
- **Language**: Dart
- **State Management**: StatefulWidget (can be upgraded to Provider/Bloc)
- **UI Components**: Custom widgets with Material Design
- **Assets**: Custom icons and images
- **Platforms**: iOS, Android, Web, Windows, macOS, Linux

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2
  expandable_text: ^2.3.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0 or higher)
- Dart SDK (2.18.2 or higher)
- Android Studio / VS Code
- Xcode (for iOS development)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/nafisrayan/ecommerce-flutter.git
   cd ecommerce-flutter
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   # For development
   flutter run

   # For specific platform
   flutter run -d chrome    # Web
   flutter run -d ios       # iOS
   flutter run -d android   # Android
   ```

### Building for Production

```bash
# Android APK
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release

# Windows
flutter build windows --release

# macOS
flutter build macos --release

# Linux
flutter build linux --release
```

## 📁 Project Structure

```
lib/
├── components/           # Reusable UI components
│   ├── app_bar.dart
│   ├── product_card.dart
│   └── special_offer_widget.dart
├── model/               # Data models
│   ├── category.dart
│   ├── popular.dart
│   └── special_offer.dart
├── screens/             # Application screens
│   ├── detail/
│   ├── home/
│   ├── mostpopular/
│   ├── profile/
│   ├── special_offers/
│   ├── tabbar/
│   └── test/
├── constants.dart       # App constants
├── image_loader.dart    # Image loading utilities
├── main.dart           # Application entry point
├── routes.dart         # Route definitions
├── size_config.dart    # Responsive design utilities
└── theme.dart          # App theme configuration

assets/
├── fonts/              # Custom fonts
├── icons/              # App icons and images
│   ├── bold/
│   ├── light/
│   ├── products/
│   ├── profile/
│   ├── tabbar/
│   └── detail/
```

## 🎨 Design System

### Color Palette
- **Primary**: #212121 (Dark Gray)
- **Secondary**: #757575 (Medium Gray)
- **Background**: #FFFFFF (White)
- **Surface**: #F3F3F3 (Light Gray)
- **Accent**: #101010 (Black)

### Typography
- **Font Family**: Urbanist
- **Weights**: Regular (400), Medium (500), Bold (700)

### Components
- **Buttons**: Rounded corners with elevation
- **Cards**: Material design cards with shadows
- **Input Fields**: Rounded input fields with focus states
- **Navigation**: Bottom navigation with custom icons

## 🔧 Configuration

### App Configuration
The app can be configured through various files:

- **pubspec.yaml**: Dependencies and assets
- **lib/constants.dart**: App-wide constants
- **lib/theme.dart**: Theme configuration
- **Platform-specific configs**: Android, iOS, Web manifests

### Customization
- **Colors**: Modify `lib/theme.dart`
- **Icons**: Replace assets in `assets/icons/`
- **Fonts**: Update `assets/fonts/` and `pubspec.yaml`
- **App Name**: Update platform-specific configuration files

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Widget tests
flutter test test/widget_test.dart
```

## 📱 Platform Support

| Platform | Status | Notes |
|----------|--------|-------|
| Android | ✅ | Fully supported |
| iOS | ✅ | Fully supported |
| Web | ✅ | Fully supported |
| Windows | ✅ | Fully supported |
| macOS | ✅ | Fully supported |
| Linux | ✅ | Fully supported |

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Nafis Rayan**
- Email: nafis.rayan@example.com
- GitHub: [@nafisrayan](https://github.com/nafisrayan)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design for the design system
- All contributors and supporters

---

**Made with ❤️ by Nafis Rayan**
