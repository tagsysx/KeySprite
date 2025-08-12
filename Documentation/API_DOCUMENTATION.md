# KeySprite API 文档

## 📱 概述

本文档描述了KeySprite输入法应用的主要API接口和类结构。KeySprite是一个基于AI模型的智能iOS输入法应用，支持多种键盘布局和智能推荐功能。

## 🏗️ 架构概览

KeySprite采用MVVM架构模式，主要包含以下模块：
- **主应用模块**: 设置、统计、用户配置
- **键盘扩展模块**: 输入处理、布局管理、AI预测
- **共享模块**: 数据模型、工具类、扩展方法

## 🔧 核心类

### 1. 主应用模块

#### AppDelegate
主应用的委托类，负责应用生命周期管理。

```swift
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    func applicationWillTerminate(_ application: UIApplication)
}
```

#### SceneDelegate
iOS 13+的场景委托，管理应用界面。

```swift
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions)
    func sceneDidDisconnect(_ scene: UIScene)
}
```

### 2. 键盘扩展模块

#### KeyboardViewController
键盘扩展的主要视图控制器，继承自UIInputViewController。

```swift
class KeyboardViewController: UIInputViewController {
    // MARK: - Properties
    private var layoutManager: KeyboardLayoutManager
    private var aiPredictor: AIPredictor
    private var inputEngine: InputEngine
    
    // MARK: - Lifecycle
    override func viewDidLoad()
    override func viewWillAppear(_ animated: Bool)
    
    // MARK: - Public Methods
    func setupKeyboard()
    func handleInput(_ input: String)
    func switchLayout(to layout: KeyboardLayout)
    func updateAIRecommendation()
    
    // MARK: - Private Methods
    private func configureKeyboard()
    private func setupConstraints()
}
```

#### KeyboardLayoutManager
键盘布局管理器，负责不同布局之间的切换和管理。

```swift
class KeyboardLayoutManager {
    // MARK: - Properties
    private var currentLayout: KeyboardLayout
    private var availableLayouts: [KeyboardLayout]
    private var layoutHistory: [KeyboardLayout]
    
    // MARK: - Public Methods
    func switchToLayout(_ layout: KeyboardLayout)
    func getRecommendedLayout() -> KeyboardLayout
    func getPreviousLayout() -> KeyboardLayout?
    
    // MARK: - Private Methods
    private func saveLayoutToHistory(_ layout: KeyboardLayout)
    private func loadLayoutPreferences()
}
```

#### AIPredictor
AI预测服务，负责调用预训练模型进行布局推荐。

```swift
class AIPredictor {
    // MARK: - Properties
    private let model: MLModel
    private let featureExtractor: FeatureExtractor
    private let resultProcessor: ResultProcessor
    
    // MARK: - Public Methods
    func predictNextLayout(input: String, context: InputContext) -> LayoutRecommendation
    func updateModel(with feedback: UserFeedback)
    
    // MARK: - Private Methods
    private func extractFeatures(from input: String, context: InputContext) -> [Float]
    private func runInference(features: [Float]) -> MLModelOutput
    private func processResults(_ output: MLModelOutput) -> LayoutRecommendation
}
```

### 3. 布局系统

#### KeyboardLayout
键盘布局协议，定义所有布局必须实现的方法。

```swift
protocol KeyboardLayout {
    // MARK: - Properties
    var identifier: String { get }
    var keys: [[KeyboardKey]] { get }
    var height: CGFloat { get }
    
    // MARK: - Methods
    func setupLayout()
    func handleKeyPress(_ key: KeyboardKey)
    func updateLayout(for context: InputContext)
}
```

#### 具体布局实现

##### QWERTYLayout
英文QWERTY键盘布局。

```swift
class QWERTYLayout: KeyboardLayout {
    // MARK: - Properties
    var identifier: String { return "QWERTY" }
    var keys: [[KeyboardKey]] { return qwertyKeys }
    var height: CGFloat { return 220 }
    
    // MARK: - Methods
    func setupLayout()
    func handleKeyPress(_ key: KeyboardKey)
    func updateLayout(for context: InputContext)
    
    // MARK: - Private Methods
    private func createQWERTYKeys() -> [[KeyboardKey]]
    private func handleShiftKey()
}
```

##### ChineseLayout
中文拼音键盘布局。

```swift
class ChineseLayout: KeyboardLayout {
    // MARK: - Properties
    var identifier: String { return "Chinese" }
    var keys: [[KeyboardKey]] { return chineseKeys }
    var height: CGFloat { return 240 }
    
    // MARK: - Methods
    func setupLayout()
    func handleKeyPress(_ key: KeyboardKey)
    func updateLayout(for context: InputContext)
    
    // MARK: - Private Methods
    private func createChineseKeys() -> [[KeyboardKey]]
    private func handlePinyinInput(_ input: String)
    private func showCandidateWords(_ words: [String])
}
```

### 4. 输入引擎

#### InputEngine
输入处理引擎，负责文本输入、候选词显示等。

```swift
class InputEngine {
    // MARK: - Properties
    private var currentInput: String
    private var candidateWords: [String]
    private var inputHistory: [String]
    
    // MARK: - Public Methods
    func processInput(_ input: String)
    func getCandidateWords() -> [String]
    func selectCandidate(_ word: String)
    func clearInput()
    
    // MARK: - Private Methods
    private func updateCandidateWords()
    private func saveToHistory(_ input: String)
}
```

### 5. 数据模型

#### InputContext
输入上下文，包含当前输入状态的信息。

```swift
struct InputContext {
    let textBeforeCursor: String
    let textAfterCursor: String
    let currentWord: String
    let appType: AppType
    let inputFieldType: InputFieldType
    let timeOfDay: TimeOfDay
    let userActivity: UserActivity
}
```

#### LayoutRecommendation
AI推荐的布局信息。

```swift
struct LayoutRecommendation {
    let recommendedLayout: KeyboardLayout
    let confidence: Float
    let alternatives: [KeyboardLayout]
    let reasoning: String
}
```

#### UserFeedback
用户对AI推荐的反馈。

```swift
struct UserFeedback {
    let recommendation: LayoutRecommendation
    let userAction: UserAction
    let timestamp: Date
    let context: InputContext
}

enum UserAction {
    case accepted
    case rejected
    case ignored
}
```

### 6. 工具类和扩展

#### FeatureExtractor
特征提取器，将输入转换为AI模型需要的特征向量。

```swift
class FeatureExtractor {
    // MARK: - Public Methods
    func extractFeatures(from input: String, context: InputContext) -> [Float]
    
    // MARK: - Private Methods
    private func extractTextFeatures(_ text: String) -> [Float]
    private func extractContextFeatures(_ context: InputContext) -> [Float]
    private func extractUserFeatures() -> [Float]
    private func normalizeFeatures(_ features: [Float]) -> [Float]
}
```

#### ResultProcessor
结果处理器，将AI模型的输出转换为可用的推荐结果。

```swift
class ResultProcessor {
    // MARK: - Public Methods
    func processModelOutput(_ output: MLModelOutput) -> LayoutRecommendation
    
    // MARK: - Private Methods
    private func parseProbabilities(_ output: MLModelOutput) -> [Float]
    private func rankLayouts(_ probabilities: [Float]) -> [KeyboardLayout]
    private func generateReasoning(_ recommendation: LayoutRecommendation) -> String
}
```

## 🔌 接口规范

### 1. 异步处理
所有AI相关的操作都应该是异步的，避免阻塞主线程：

```swift
func predictNextLayout(input: String, context: InputContext, completion: @escaping (LayoutRecommendation) -> Void)
```

### 2. 错误处理
使用Result类型或抛出错误来处理异常情况：

```swift
enum AIError: Error {
    case modelNotFound
    case inferenceFailed
    case invalidInput
    case modelOutOfMemory
}

func predictNextLayout(input: String, context: InputContext) throws -> LayoutRecommendation
```

### 3. 配置管理
使用UserDefaults或Core Data来管理用户配置：

```swift
protocol ConfigurationManager {
    func getValue<T>(for key: String) -> T?
    func setValue<T>(_ value: T, for key: String)
    func resetToDefaults()
}
```

## 📊 性能要求

### 1. 响应时间
- AI推理时间: < 100ms
- 键盘响应时间: < 50ms
- 布局切换时间: < 200ms

### 2. 内存使用
- 总内存占用: < 100MB
- AI模型内存: < 50MB
- 缓存内存: < 20MB

### 3. 电池消耗
- 后台运行时间: 最小化
- AI推理频率: 智能控制
- 网络请求: 本地优先

## 🧪 测试指南

### 1. 单元测试
每个核心类都应该有对应的单元测试：

```swift
class AIPredictorTests: XCTestCase {
    func testFeatureExtraction()
    func testModelInference()
    func testResultProcessing()
    func testPerformance()
}
```

### 2. 集成测试
测试不同模块之间的协作：

```swift
class KeyboardIntegrationTests: XCTestCase {
    func testLayoutSwitching()
    func testAIRecommendationFlow()
    func testInputProcessing()
}
```

### 3. UI测试
测试用户界面的交互：

```swift
class KeyboardUITests: XCTestCase {
    func testKeyPress()
    func testLayoutSwitch()
    func testCandidateSelection()
}
```

## 📝 更新日志

| 版本 | 日期 | 更新内容 |
|------|------|----------|
| 1.0.0 | 2024-01-XX | 初始API设计 |

## 🔗 相关文档

- [开发计划](./DEVELOPMENT_PLAN.md)
- [README](./README.md)
- [Core ML集成指南](./CORE_ML_INTEGRATION.md)
- [键盘扩展开发指南](./KEYBOARD_EXTENSION_GUIDE.md)

---

**注意**: 本文档会随着开发进度持续更新，请关注最新版本。
