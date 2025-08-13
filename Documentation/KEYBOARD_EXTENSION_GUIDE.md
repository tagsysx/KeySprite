# 键盘扩展开发指南

## 📱 概述

本文档详细介绍了如何在KeySprite项目中开发iOS自定义键盘扩展，包括配置、实现和最佳实践。

## 🎯 开发目标

- 创建功能完整的iOS自定义键盘扩展
- 实现多种键盘布局（英文、中文、数字、符号、Emoji）
- 集成AI智能布局推荐功能
- 提供优秀的用户体验和性能表现

## 🏗️ 技术架构

### 1. 键盘扩展架构

```
┌─────────────────────────────────────────────────────────────┐
│                    iOS System                               │
├─────────────────────────────────────────────────────────────┤
│  Input Method Kit  │  Text Input Mode  │  Keyboard UI      │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                KeySprite Keyboard Extension                 │
├─────────────────────────────────────────────────────────────┤
│  KeyboardViewController  │  Layout Manager  │  Input Engine  │
├─────────────────────────────────────────────────────────────┤
│  QWERTY  │  Chinese  │  Number  │  Symbol  │  Emoji      │
└─────────────────────────────────────────────────────────────┘
```

### 2. 核心组件

- **KeyboardViewController**: 键盘扩展的主控制器
- **LayoutManager**: 键盘布局管理器
- **InputEngine**: 输入处理引擎
- **AIPredictor**: AI预测服务

## 🔧 配置步骤

### 步骤1: 创建键盘扩展Target

1. 在Xcode中选择File > New > Target
2. 选择iOS > Application Extension > Custom Keyboard Extension
3. 设置产品名称：KeySpriteKeyboard
4. 选择语言：Swift
5. 确保包含在主项目中

### 步骤2: 配置Info.plist

```xml
<!-- KeySpriteKeyboard/Info.plist -->
<key>NSExtension</key>
<dict>
    <key>NSExtensionAttributes</key>
    <dict>
        <key>IsASCIICapable</key>
        <true/>
        <key>PrefersRightToLeft</key>
        <false/>
        <key>PrimaryLanguage</key>
        <string>en-US</string>
        <key>RequestsOpenAccess</key>
        <true/>
    </dict>
    <key>NSExtensionMainStoryboard</key>
    <string>MainInterface</string>
    <key>NSExtensionPointIdentifier</key>
    <string>com.apple.keyboard-service</string>
</dict>
```

## 🚀 核心实现

### 1. KeyboardViewController

```swift
import UIKit
import InputMethodKit

class KeyboardViewController: UIInputViewController {
    
    // MARK: - Properties
    private var layoutManager: KeyboardLayoutManager!
    private var aiPredictor: AIPredictor!
    private var inputEngine: InputEngine!
    
    // MARK: - UI Components
    private var keyboardView: KeyboardView!
    private var candidateView: CandidateView?
    private var layoutIndicator: LayoutIndicatorView!
    
    // MARK: - State
    private var currentLayout: KeyboardLayout = .qwerty
    private var isShifted: Bool = false
    private var isCapsLocked: Bool = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponents()
        setupConstraints()
        setupGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateKeyboardLayout()
        updateAIRecommendation()
    }
    
    // MARK: - Setup
    private func setupComponents() {
        // 初始化布局管理器
        layoutManager = KeyboardLayoutManager()
        
        // 初始化AI预测器
        aiPredictor = AIPredictor()
        
        // 初始化输入引擎
        inputEngine = InputEngine()
        
        // 创建键盘视图
        keyboardView = KeyboardView()
        view.addSubview(keyboardView)
        
        // 创建候选词视图
        candidateView = CandidateView()
        view.addSubview(candidateView!)
        
        // 创建布局指示器
        layoutIndicator = LayoutIndicatorView()
        view.addSubview(layoutIndicator)
    }
    
    // MARK: - Layout Management
    private func updateKeyboardLayout() {
        let layout = layoutManager.getCurrentLayout()
        keyboardView.updateLayout(layout)
        layoutIndicator.updateLayout(layout)
        
        // 更新AI推荐
        updateAIRecommendation()
    }
    
    private func switchToLayout(_ layout: KeyboardLayout) {
        layoutManager.switchToLayout(layout)
        updateKeyboardLayout()
        
        // 记录用户选择
        UserDefaults.standard.set(layout.rawValue, forKey: "LastSelectedLayout")
    }
    
    // MARK: - AI Integration
    private func updateAIRecommendation() {
        let currentInput = getCurrentInput()
        let context = getCurrentContext()
        
        aiPredictor.predictNextLayout(input: currentInput, context: context) { [weak self] result in
            DispatchQueue.main.async {
                self?.handleAIRecommendation(result)
            }
        }
    }
    
    private func handleAIRecommendation(_ result: Result<LayoutRecommendation, Error>) {
        switch result {
        case .success(let recommendation):
            if recommendation.confidence > 0.7 {
                showLayoutRecommendation(recommendation)
            }
        case .failure(let error):
            print("AI推荐失败: \(error)")
        }
    }
    
    // MARK: - Input Handling
    private func handleKeyPress(_ key: KeyboardKey) {
        switch key.type {
        case .character:
            insertText(key.displayText)
            updateAIRecommendation()
            
        case .backspace:
            deleteBackward()
            
        case .space:
            insertText(" ")
            updateAIRecommendation()
            
        case .return:
            insertText("\n")
            
        case .shift:
            toggleShift()
            
        case .layout:
            switchToLayout(key.associatedLayout)
            
        case .emoji:
            showEmojiPicker()
        }
    }
    
    // MARK: - Text Input
    private func insertText(_ text: String) {
        textDocumentProxy.insertText(text)
        
        // 更新候选词
        if currentLayout == .chinese {
            updateCandidateWords()
        }
    }
    
    private func deleteBackward() {
        textDocumentProxy.deleteBackward()
        
        // 更新候选词
        if currentLayout == .chinese {
            updateCandidateWords()
        }
    }
    
    // MARK: - Helper Methods
    private func getCurrentInput() -> String {
        return textDocumentProxy.documentContextBeforeInput ?? ""
    }
    
    private func getCurrentContext() -> InputContext {
        return InputContext(
            textBeforeCursor: textDocumentProxy.documentContextBeforeInput ?? "",
            textAfterCursor: textDocumentProxy.documentContextAfterInput ?? "",
            currentWord: getCurrentWord(),
            appType: .other,
            inputFieldType: .text,
            timeOfDay: getCurrentTimeOfDay(),
            userActivity: .typing
        )
    }
    
    private func getCurrentWord() -> String {
        let beforeInput = textDocumentProxy.documentContextBeforeInput ?? ""
        let words = beforeInput.components(separatedBy: .whitespacesAndNewlines)
        return words.last ?? ""
    }
    
    private func getCurrentTimeOfDay() -> TimeOfDay {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12: return .morning
        case 12..<18: return .afternoon
        case 18..<22: return .evening
        default: return .night
        }
    }
}
```

### 2. 键盘布局管理器

```swift
import Foundation

class KeyboardLayoutManager {
    
    // MARK: - Properties
    private var currentLayout: KeyboardLayout = .qwerty
    private var availableLayouts: [KeyboardLayout] = [.qwerty, .chinese, .number, .symbol, .emoji]
    private var layoutHistory: [KeyboardLayout] = []
    private var layoutPreferences: [KeyboardLayout: Float] = [:]
    
    // MARK: - Initialization
    init() {
        loadLayoutPreferences()
        loadLastUsedLayout()
    }
    
    // MARK: - Public Methods
    func getCurrentLayout() -> KeyboardLayout {
        return currentLayout
    }
    
    func switchToLayout(_ layout: KeyboardLayout) {
        guard availableLayouts.contains(layout) else { return }
        
        // 保存当前布局到历史
        saveLayoutToHistory(currentLayout)
        
        // 更新当前布局
        currentLayout = layout
        
        // 更新使用偏好
        updateLayoutPreference(layout)
        
        // 保存设置
        saveLayoutPreferences()
    }
    
    func getRecommendedLayout() -> KeyboardLayout {
        // 基于用户偏好和使用历史推荐布局
        let recommendations = calculateLayoutRecommendations()
        return recommendations.first ?? .qwerty
    }
    
    func getPreviousLayout() -> KeyboardLayout? {
        return layoutHistory.last
    }
    
    func getAvailableLayouts() -> [KeyboardLayout] {
        return availableLayouts
    }
    
    // MARK: - Private Methods
    private func saveLayoutToHistory(_ layout: KeyboardLayout) {
        layoutHistory.append(layout)
        
        // 限制历史记录数量
        if layoutHistory.count > 10 {
            layoutHistory.removeFirst()
        }
    }
    
    private func updateLayoutPreference(_ layout: KeyboardLayout) {
        let currentPreference = layoutPreferences[layout] ?? 0.0
        layoutPreferences[layout] = currentPreference + 1.0
    }
    
    private func calculateLayoutRecommendations() -> [KeyboardLayout] {
        // 基于偏好分数排序布局
        let sortedLayouts = availableLayouts.sorted { layout1, layout2 in
            let score1 = layoutPreferences[layout1] ?? 0.0
            let score2 = layoutPreferences[layout2] ?? 0.0
            return score1 > score2
        }
        
        return sortedLayouts
    }
    
    private func loadLayoutPreferences() {
        let userDefaults = UserDefaults.standard
        
        for layout in availableLayouts {
            let key = "LayoutPreference_\(layout.rawValue)"
            let preference = userDefaults.float(forKey: key)
            layoutPreferences[layout] = preference
        }
    }
    
    private func saveLayoutPreferences() {
        let userDefaults = UserDefaults.standard
        
        for (layout, preference) in layoutPreferences {
            let key = "LayoutPreference_\(layout.rawValue)"
            userDefaults.set(preference, forKey: key)
        }
        
        userDefaults.synchronize()
    }
    
    private func loadLastUsedLayout() {
        let userDefaults = UserDefaults.standard
        if let layoutString = userDefaults.string(forKey: "LastUsedLayout"),
           let layout = KeyboardLayout(rawValue: layoutString) {
            currentLayout = layout
        }
    }
}

// MARK: - KeyboardLayout Enum
enum KeyboardLayout: String, CaseIterable {
    case qwerty = "QWERTY"
    case chinese = "Chinese"
    case number = "Number"
    case symbol = "Symbol"
    case emoji = "Emoji"
    
    var displayName: String {
        switch self {
        case .qwerty: return "英文"
        case .chinese: return "中文"
        case .number: return "数字"
        case .symbol: return "符号"
        case .emoji: return "表情"
        }
    }
    
    var iconName: String {
        switch self {
        case .qwerty: return "keyboard"
        case .chinese: return "character"
        case .number: return "number"
        case .symbol: return "textformat"
        case .emoji: return "face.smiling"
        }
    }
}
```

## 🎨 UI组件实现

### 1. 键盘视图

```swift
import UIKit

class KeyboardView: UIView {
    
    // MARK: - Properties
    private var currentLayout: KeyboardLayout = .qwerty
    private var keys: [[KeyboardKey]] = []
    private var keyViews: [[UIButton]] = []
    private var keyPreviewView: KeyPreviewView?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup
    private func setupView() {
        backgroundColor = UIColor.systemBackground
        layer.cornerRadius = 8
        layer.masksToBounds = true
        
        setupKeys()
        setupKeyViews()
    }
    
    private func setupKeys() {
        keys = currentLayout.getKeys()
    }
    
    private func setupKeyViews() {
        // 清除现有按键视图
        keyViews.forEach { row in
            row.forEach { $0.removeFromSuperview() }
        }
        keyViews.removeAll()
        
        // 创建新的按键视图
        for (rowIndex, row) in keys.enumerated() {
            var keyRow: [UIButton] = []
            
            for (colIndex, key) in row.enumerated() {
                let keyButton = createKeyButton(for: key)
                keyButton.tag = rowIndex * 100 + colIndex
                addSubview(keyButton)
                keyRow.append(keyButton)
            }
            
            keyViews.append(keyRow)
        }
        
        updateKeyConstraints()
    }
    
    private func createKeyButton(for key: KeyboardKey) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(key.displayText, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.backgroundColor = key.backgroundColor
        button.setTitleColor(key.textColor, for: .normal)
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        
        // 添加触摸事件
        button.addTarget(self, action: #selector(keyTapped(_:)), for: .touchUpInside)
        
        return button
    }
    
    // MARK: - Public Methods
    func updateLayout(_ layout: KeyboardLayout) {
        currentLayout = layout
        setupKeys()
        setupKeyViews()
    }
    
    func updateShiftState(isShifted: Bool, isCapsLocked: Bool) {
        // 更新Shift键状态
        for row in keyViews {
            for keyButton in row {
                if let key = getKeyForButton(keyButton), key.type == .shift {
                    updateShiftKeyAppearance(keyButton, isShifted: isShifted, isCapsLocked: isCapsLocked)
                }
            }
        }
    }
    
    // MARK: - Private Methods
    private func getKeyForButton(_ button: UIButton) -> KeyboardKey? {
        let tag = button.tag
        let rowIndex = tag / 100
        let colIndex = tag % 100
        
        guard rowIndex < keys.count && colIndex < keys[rowIndex].count else {
            return nil
        }
        
        return keys[rowIndex][colIndex]
    }
    
    // MARK: - Actions
    @objc private func keyTapped(_ sender: UIButton) {
        let tag = sender.tag
        let rowIndex = tag / 100
        let colIndex = tag % 100
        
        guard rowIndex < keys.count && colIndex < keys[rowIndex].count else {
            return
        }
        
        let key = keys[rowIndex][colIndex]
        
        // 发送按键事件
        NotificationCenter.default.post(
            name: .keyTapped,
            object: key
        )
    }
}

// MARK: - Notification Names
extension Notification.Name {
    static let keyTapped = Notification.Name("keyTapped")
}
```

## 🧪 测试和调试

### 1. 单元测试

```swift
import XCTest
@testable import KeySpriteKeyboard

class KeyboardViewControllerTests: XCTestCase {
    
    var keyboardViewController: KeyboardViewController!
    
    override func setUp() {
        super.setUp()
        keyboardViewController = KeyboardViewController()
    }
    
    override func tearDown() {
        keyboardViewController = nil
        super.tearDown()
    }
    
    func testInitialization() {
        XCTAssertNotNil(keyboardViewController)
        XCTAssertNotNil(keyboardViewController.view)
    }
    
    func testLayoutSwitching() {
        // 测试布局切换
        let initialLayout = keyboardViewController.layoutManager.getCurrentLayout()
        keyboardViewController.switchToLayout(.chinese)
        let newLayout = keyboardViewController.layoutManager.getCurrentLayout()
        
        XCTAssertEqual(newLayout, .chinese)
        XCTAssertNotEqual(initialLayout, newLayout)
    }
}
```

## 🚨 常见问题和解决方案

### 1. 键盘不显示

**问题**: 键盘扩展无法显示
**解决方案**:
- 检查Info.plist配置
- 验证Bundle Identifier设置
- 确保键盘扩展已启用
- 检查开发证书配置

### 2. 按键无响应

**问题**: 按键点击无反应
**解决方案**:
- 检查事件绑定
- 验证约束设置
- 确保视图层级正确
- 检查触摸事件处理

## 📚 参考资料

- [Custom Keyboard Extension](https://developer.apple.com/documentation/inputmethodkit)
- [iOS Input Method Development](https://developer.apple.com/library/archive/documentation/General/Conceptual/ExtensibilityPG/Keyboard.html)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines)

## 📝 更新日志

| 版本 | 日期 | 更新内容 |
|------|------|----------|
| 1.0.0 | 2024-01-XX | 初始键盘扩展开发指南 |

---

**注意**: 本指南提供了键盘扩展开发的基础框架，实际实现时需要根据具体需求进行调整和优化。
