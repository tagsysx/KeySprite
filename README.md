# KeySprite - AI-Powered Smart Input Method

> **Note**: This is a research project currently under development. The project is in active development and may contain experimental features.

An intelligent iOS input method application based on AI models that automatically recommends the most suitable keyboard layout based on user input content.

## 🚀 Features

- **Multi-language Support**: English, Chinese, Numbers, Symbols, Emoji
- **AI Smart Recommendations**: Automatically recommends the most suitable keyboard layout based on pre-trained models
- **Adaptive Layout**: Dynamically adjusts keyboard display based on input content
- **Personalized Experience**: Learns user habits and provides personalized recommendations
- **High Performance**: Local AI inference with fast response

## 🏗️ Technical Architecture

- **Development Language**: Swift 5.0+
- **iOS Version**: iOS 17.0+
- **Framework**: SwiftUI + UIKit
- **AI Engine**: Core ML + Pre-trained Models
- **Data Storage**: Core Data + UserDefaults
- **Architecture Pattern**: MVVM + Coordinator

## 📱 Supported Keyboard Layouts

1. **English QWERTY Keyboard**: Standard English input
2. **Chinese Pinyin Keyboard**: Smart pinyin input with handwriting support
3. **Numeric Keyboard**: Numbers and common symbols
4. **Symbol Keyboard**: Punctuation marks and special characters
5. **Emoji Keyboard**: Categorized emoji browsing

## 🔧 Development Environment Requirements

- Xcode 15.0+
- iOS 17.0+ SDK
- macOS 14.0+
- Apple Developer Account

## 📦 Installation and Setup

### 1. Clone the Project
```bash
git clone https://github.com/tagsysx/KeySprite.git
cd KeySprite
```

### 2. Open the Project
```bash
open KeySprite.xcodeproj
```

### 3. Configure Developer Account
- Log in to your Apple Developer account in Xcode
- Update Bundle Identifier
- Configure development certificates and Provisioning Profile

### 4. Run the Project
- Select target device (real device or simulator)
- Press Cmd+R to run the project

## 🧪 Testing

### Unit Testing
```bash
# Run all tests
Cmd+U

# Run specific tests
Cmd+Shift+U
```

### UI Testing
```bash
# Run UI tests
Product > Test > Test Plan
```

## 📊 Project Structure

```
KeySprite/
├── KeySprite.xcodeproj/          # Main project file
├── KeySprite/                    # Main application
├── KeySpirteKeyboard/            # Keyboard extension
├── Shared/                       # Shared code
├── Resources/                    # Resource files
├── Tests/                        # Test files
└── Documentation/                # Project documentation
```

## 🤝 Contributing

1. Fork the project
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Create a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## 📞 Contact

- Project Maintainer: [Your Name]
- Email: [your.email@example.com]
- Project Link: [https://github.com/tagsysx/KeySprite](https://github.com/tagsysx/KeySprite)

## 🙏 Acknowledgments

Thanks to all developers and designers who have contributed to this project.

---

**Note**: This is an iOS input method application. Keyboard extension functionality needs to be tested on real devices. Simulators cannot fully test all features of keyboard extensions.
