# Core ML 集成指南

## 📱 概述

本文档详细介绍了如何在KeySprite项目中集成预训练的Core ML模型，实现智能键盘布局推荐功能。

## 🎯 集成目标

- 集成预训练的AI模型到iOS应用中
- 实现实时的布局推荐功能
- 优化模型性能，确保流畅的用户体验
- 处理模型推理过程中的错误和异常

## 🏗️ 技术架构

### 1. Core ML集成架构

```
┌─────────────────────────────────────────────────────────────┐
│                    Keyboard Extension                       │
├─────────────────────────────────────────────────────────────┤
│  Input Handler  │  Feature Extractor  │  Layout Manager   │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    AI Service Layer                         │
├─────────────────────────────────────────────────────────────┤
│  Model Manager  │  Inference Engine  │  Result Processor  │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    Core ML Model                            │
├─────────────────────────────────────────────────────────────┤
│  Pre-trained Model  │  Model Metadata  │  Model Resources  │
└─────────────────────────────────────────────────────────────┘
```

### 2. 核心组件

- **ModelManager**: 模型加载和管理
- **FeatureExtractor**: 特征提取和预处理
- **InferenceEngine**: 模型推理引擎
- **ResultProcessor**: 结果处理和转换

## 🔧 集成步骤

### 步骤1: 添加模型文件

1. 将预训练的`.mlmodel`文件添加到Xcode项目中
2. 确保模型文件包含在正确的target中
3. 验证模型文件的完整性

```swift
// 在项目中添加模型文件
// 1. 拖拽 .mlmodel 文件到 Xcode 项目
// 2. 选择 "Copy items if needed"
// 3. 选择正确的 target (KeySpriteKeyboard)
// 4. 确保 "Add to target" 已勾选
```

### 步骤2: 创建模型管理器

```swift
import CoreML
import Foundation

class ModelManager {
    // MARK: - Properties
    private var model: MLModel?
    private let modelName = "LayoutRecommendationModel"
    
    // MARK: - Initialization
    init() throws {
        try loadModel()
    }
    
    // MARK: - Public Methods
    func getModel() -> MLModel? {
        return model
    }
    
    func isModelLoaded() -> Bool {
        return model != nil
    }
    
    // MARK: - Private Methods
    private func loadModel() throws {
        guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "mlmodel") else {
            throw ModelError.modelNotFound
        }
        
        do {
            let compiledModelURL = try MLModel.compileModel(at: modelURL)
            self.model = try MLModel(contentsOf: compiledModelURL)
        } catch {
            throw ModelError.modelLoadFailed(error)
        }
    }
}

// MARK: - Error Types
enum ModelError: Error, LocalizedError {
    case modelNotFound
    case modelLoadFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .modelNotFound:
            return "预训练模型文件未找到"
        case .modelLoadFailed(let error):
            return "模型加载失败: \(error.localizedDescription)"
        }
    }
}
```

### 步骤3: 实现特征提取器

```swift
import Foundation

class FeatureExtractor {
    
    // MARK: - Public Methods
    func extractFeatures(from input: String, context: InputContext) -> [Float] {
        var features: [Float] = []
        
        // 提取文本特征
        features.append(contentsOf: extractTextFeatures(input))
        
        // 提取上下文特征
        features.append(contentsOf: extractContextFeatures(context))
        
        // 提取用户特征
        features.append(contentsOf: extractUserFeatures())
        
        // 特征标准化
        return normalizeFeatures(features)
    }
    
    // MARK: - Private Methods
    private func extractTextFeatures(_ text: String) -> [Float] {
        var features: [Float] = []
        
        // 文本长度特征
        features.append(Float(text.count))
        
        // 字符类型分布
        let englishCount = text.filter { $0.isLetter && $0.isASCII }.count
        let chineseCount = text.filter { $0.unicodeScalars.contains { $0.properties.isIdeographic } }.count
        let numberCount = text.filter { $0.isNumber }.count
        let symbolCount = text.filter { !$0.isLetter && !$0.isNumber && !$0.isWhitespace }.count
        
        features.append(Float(englishCount))
        features.append(Float(chineseCount))
        features.append(Float(numberCount))
        features.append(Float(symbolCount))
        
        // 单词数量
        let words = text.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
        features.append(Float(words.count))
        
        // 句子数量
        let sentences = text.components(separatedBy: CharacterSet(charactersIn: "。！？.!?"))
        features.append(Float(sentences.count))
        
        return features
    }
    
    private func extractContextFeatures(_ context: InputContext) -> [Float] {
        var features: [Float] = []
        
        // 应用类型特征
        features.append(encodeAppType(context.appType))
        
        // 输入框类型特征
        features.append(encodeInputFieldType(context.inputFieldType))
        
        // 时间特征
        features.append(encodeTimeOfDay(context.timeOfDay))
        
        // 用户活动特征
        features.append(encodeUserActivity(context.userActivity))
        
        return features
    }
    
    private func extractUserFeatures() -> [Float] {
        var features: [Float] = []
        
        // 用户偏好特征
        let userDefaults = UserDefaults.standard
        let preferredLayout = userDefaults.string(forKey: "PreferredLayout") ?? "QWERTY"
        features.append(encodeLayoutPreference(preferredLayout))
        
        // 使用频率特征
        let qwertyUsage = userDefaults.double(forKey: "QWERTYUsage")
        let chineseUsage = userDefaults.double(forKey: "ChineseUsage")
        let numberUsage = userDefaults.double(forKey: "NumberUsage")
        
        features.append(Float(qwertyUsage))
        features.append(Float(chineseUsage))
        features.append(Float(numberUsage))
        
        return features
    }
    
    private func normalizeFeatures(_ features: [Float]) -> [Float] {
        // 简单的Min-Max标准化
        guard let min = features.min(), let max = features.max(), max > min else {
            return features
        }
        
        return features.map { ($0 - min) / (max - min) }
    }
    
    // MARK: - Encoding Methods
    private func encodeAppType(_ appType: AppType) -> Float {
        switch appType {
        case .messaging: return 0.0
        case .social: return 0.25
        case .productivity: return 0.5
        case .browser: return 0.75
        case .other: return 1.0
        }
    }
    
    private func encodeInputFieldType(_ fieldType: InputFieldType) -> Float {
        switch fieldType {
        case .text: return 0.0
        case .email: return 0.25
        case .password: return 0.5
        case .search: return 0.75
        case .url: return 1.0
        }
    }
    
    private func encodeTimeOfDay(_ time: TimeOfDay) -> Float {
        switch time {
        case .morning: return 0.0
        case .afternoon: return 0.33
        case .evening: return 0.66
        case .night: return 1.0
        }
    }
    
    private func encodeUserActivity(_ activity: UserActivity) -> Float {
        switch activity {
        case .typing: return 0.0
        case .editing: return 0.25
        case .searching: return 0.5
        case .browsing: return 0.75
        case .idle: return 1.0
        }
    }
    
    private func encodeLayoutPreference(_ layout: String) -> Float {
        switch layout {
        case "QWERTY": return 0.0
        case "Chinese": return 0.25
        case "Number": return 0.5
        case "Symbol": return 0.75
        case "Emoji": return 1.0
        default: return 0.0
        }
    }
}

// MARK: - Supporting Types
enum AppType {
    case messaging, social, productivity, browser, other
}

enum InputFieldType {
    case text, email, password, search, url
}

enum TimeOfDay {
    case morning, afternoon, evening, night
}

enum UserActivity {
    case typing, editing, searching, browsing, idle
}
```

### 步骤4: 实现推理引擎

```swift
import CoreML
import Foundation

class InferenceEngine {
    
    // MARK: - Properties
    private let modelManager: ModelManager
    private let featureExtractor: FeatureExtractor
    
    // MARK: - Initialization
    init(modelManager: ModelManager, featureExtractor: FeatureExtractor) {
        self.modelManager = modelManager
        self.featureExtractor = featureExtractor
    }
    
    // MARK: - Public Methods
    func predictNextLayout(input: String, context: InputContext) throws -> LayoutRecommendation {
        guard let model = modelManager.getModel() else {
            throw InferenceError.modelNotLoaded
        }
        
        // 提取特征
        let features = featureExtractor.extractFeatures(from: input, context: context)
        
        // 创建模型输入
        let modelInput = try createModelInput(features: features)
        
        // 执行推理
        let prediction = try performInference(model: model, input: modelInput)
        
        // 处理结果
        return processPrediction(prediction)
    }
    
    // MARK: - Private Methods
    private func createModelInput(features: [Float]) throws -> MLFeatureProvider {
        // 根据你的模型输入格式创建MLFeatureProvider
        // 这里需要根据实际的模型输入要求进行调整
        
        let featureValue = MLFeatureValue(multiArray: try MLMultiArray(shape: [1, features.count], dataType: .float32))
        
        // 填充特征值
        for (index, feature) in features.enumerated() {
            featureValue.multiArrayValue[index] = NSNumber(value: feature)
        }
        
        let inputFeatures = ["input_features": featureValue]
        return try MLDictionaryFeatureProvider(dictionary: inputFeatures)
    }
    
    private func performInference(model: MLModel, input: MLFeatureProvider) throws -> MLFeatureProvider {
        do {
            return try model.prediction(from: input)
        } catch {
            throw InferenceError.inferenceFailed(error)
        }
    }
    
    private func processPrediction(_ prediction: MLFeatureProvider) -> LayoutRecommendation {
        // 根据你的模型输出格式处理预测结果
        // 这里需要根据实际的模型输出进行调整
        
        // 示例：假设模型输出是布局概率分布
        let layoutProbabilities = extractLayoutProbabilities(from: prediction)
        let recommendedLayout = selectRecommendedLayout(from: layoutProbabilities)
        
        return LayoutRecommendation(
            recommendedLayout: recommendedLayout,
            confidence: layoutProbabilities.max() ?? 0.0,
            alternatives: getAlternativeLayouts(from: layoutProbabilities),
            reasoning: generateReasoning(for: recommendedLayout)
        )
    }
    
    private func extractLayoutProbabilities(from prediction: MLFeatureProvider) -> [Float] {
        // 从模型输出中提取布局概率
        // 需要根据实际模型输出格式调整
        
        // 示例实现
        var probabilities: [Float] = []
        
        // 假设输出特征名为 "layout_probabilities"
        if let outputFeature = prediction.featureValue(for: "layout_probabilities") {
            if let multiArray = outputFeature.multiArrayValue {
                for i in 0..<multiArray.count {
                    probabilities.append(multiArray[i].floatValue)
                }
            }
        }
        
        return probabilities
    }
    
    private func selectRecommendedLayout(from probabilities: [Float]) -> KeyboardLayout {
        // 选择概率最高的布局
        guard let maxIndex = probabilities.enumerated().max(by: { $0.element < $1.element })?.offset else {
            return QWERTYLayout() // 默认布局
        }
        
        return getLayoutForIndex(maxIndex)
    }
    
    private func getAlternativeLayouts(from probabilities: [Float]) -> [KeyboardLayout] {
        // 获取备选布局（概率第二高的）
        let sortedIndices = probabilities.enumerated().sorted { $0.element > $1.element }.map { $0.offset }
        
        var alternatives: [KeyboardLayout] = []
        for i in 1..<min(3, sortedIndices.count) {
            alternatives.append(getLayoutForIndex(sortedIndices[i]))
        }
        
        return alternatives
    }
    
    private func getLayoutForIndex(_ index: Int) -> KeyboardLayout {
        // 根据索引返回对应的布局
        switch index {
        case 0: return QWERTYLayout()
        case 1: return ChineseLayout()
        case 2: return NumberLayout()
        case 3: return SymbolLayout()
        case 4: return EmojiLayout()
        default: return QWERTYLayout()
        }
    }
    
    private func generateReasoning(for layout: KeyboardLayout) -> String {
        // 生成推荐理由
        switch layout.identifier {
        case "QWERTY":
            return "检测到英文输入，推荐使用QWERTY键盘"
        case "Chinese":
            return "检测到中文输入，推荐使用拼音键盘"
        case "Number":
            return "检测到数字输入，推荐使用数字键盘"
        case "Symbol":
            return "检测到符号输入，推荐使用符号键盘"
        case "Emoji":
            return "检测到表情需求，推荐使用Emoji键盘"
        default:
            return "基于AI分析推荐的最佳键盘布局"
        }
    }
}

// MARK: - Error Types
enum InferenceError: Error, LocalizedError {
    case modelNotLoaded
    case inferenceFailed(Error)
    case invalidInput
    case invalidOutput
    
    var errorDescription: String? {
        switch self {
        case .modelNotLoaded:
            return "AI模型未加载"
        case .inferenceFailed(let error):
            return "推理失败: \(error.localizedDescription)"
        case .invalidInput:
            return "输入特征无效"
        case .invalidOutput:
            return "模型输出无效"
        }
    }
}
```

### 步骤5: 实现结果处理器

```swift
import Foundation

class ResultProcessor {
    
    // MARK: - Public Methods
    func processModelOutput(_ output: MLFeatureProvider) -> LayoutRecommendation {
        // 处理模型输出，转换为应用可用的推荐结果
        let layoutProbabilities = extractLayoutProbabilities(from: output)
        let recommendedLayout = selectRecommendedLayout(from: layoutProbabilities)
        
        return LayoutRecommendation(
            recommendedLayout: recommendedLayout,
            confidence: calculateConfidence(from: layoutProbabilities),
            alternatives: getAlternativeLayouts(from: layoutProbabilities),
            reasoning: generateReasoning(for: recommendedLayout, probabilities: layoutProbabilities)
        )
    }
    
    // MARK: - Private Methods
    private func extractLayoutProbabilities(from output: MLFeatureProvider) -> [Float] {
        // 从模型输出中提取概率分布
        // 需要根据实际模型输出格式调整
        return []
    }
    
    private func selectRecommendedLayout(from probabilities: [Float]) -> KeyboardLayout {
        // 选择推荐布局
        return QWERTYLayout() // 默认实现
    }
    
    private func calculateConfidence(from probabilities: [Float]) -> Float {
        // 计算推荐置信度
        return probabilities.max() ?? 0.0
    }
    
    private func getAlternativeLayouts(from probabilities: [Float]) -> [KeyboardLayout] {
        // 获取备选布局
        return []
    }
    
    private func generateReasoning(for layout: KeyboardLayout, probabilities: [Float]) -> String {
        // 生成推荐理由
        return "基于AI分析的智能推荐"
    }
}
```

## 🔌 集成到键盘扩展

### 1. 在KeyboardViewController中集成

```swift
import UIKit
import InputMethodKit

class KeyboardViewController: UIInputViewController {
    
    // MARK: - Properties
    private var aiService: AIService?
    private var layoutManager: KeyboardLayoutManager
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAIService()
        setupKeyboard()
    }
    
    // MARK: - Setup
    private func setupAIService() {
        do {
            aiService = try AIService()
        } catch {
            print("AI服务初始化失败: \(error)")
            // 降级到非AI模式
        }
    }
    
    // MARK: - AI Integration
    private func updateAIRecommendation() {
        guard let aiService = aiService else { return }
        
        let currentInput = getCurrentInput()
        let context = getCurrentContext()
        
        // 异步获取AI推荐
        aiService.predictNextLayout(input: currentInput, context: context) { [weak self] result in
            DispatchQueue.main.async {
                self?.handleAIRecommendation(result)
            }
        }
    }
    
    private func handleAIRecommendation(_ result: Result<LayoutRecommendation, Error>) {
        switch result {
        case .success(let recommendation):
            if recommendation.confidence > 0.7 { // 高置信度时才推荐
                self.showLayoutRecommendation(recommendation)
            }
        case .failure(let error):
            print("AI推荐失败: \(error)")
        }
    }
    
    private func showLayoutRecommendation(_ recommendation: LayoutRecommendation) {
        // 显示布局推荐UI
        let alert = UIAlertController(
            title: "智能推荐",
            message: recommendation.reasoning,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "切换", style: .default) { _ in
            self.switchToLayout(recommendation.recommendedLayout)
        })
        
        alert.addAction(UIAlertAction(title: "忽略", style: .cancel))
        
        present(alert, animated: true)
    }
    
    // MARK: - Helper Methods
    private func getCurrentInput() -> String {
        // 获取当前输入内容
        return textDocumentProxy.documentContextBeforeInput ?? ""
    }
    
    private func getCurrentContext() -> InputContext {
        // 获取当前输入上下文
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
        // 获取当前单词
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

### 2. 创建AI服务封装

```swift
import Foundation

class AIService {
    
    // MARK: - Properties
    private let modelManager: ModelManager
    private let featureExtractor: FeatureExtractor
    private let inferenceEngine: InferenceEngine
    
    // MARK: - Initialization
    init() throws {
        self.modelManager = try ModelManager()
        self.featureExtractor = FeatureExtractor()
        self.inferenceEngine = InferenceEngine(
            modelManager: modelManager,
            featureExtractor: featureExtractor
        )
    }
    
    // MARK: - Public Methods
    func predictNextLayout(
        input: String,
        context: InputContext,
        completion: @escaping (Result<LayoutRecommendation, Error>) -> Void
    ) {
        // 在后台队列执行AI推理
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let recommendation = try self.inferenceEngine.predictNextLayout(
                    input: input,
                    context: context
                )
                completion(.success(recommendation))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func updateModel(with feedback: UserFeedback) {
        // 处理用户反馈，可用于模型更新
        // 这里可以实现增量学习或模型参数调整
    }
}
```

## 📊 性能优化

### 1. 模型优化

```swift
// 模型量化
let config = MLModelConfiguration()
config.computeUnits = .cpuAndGPU // 或 .cpuOnly, .all

// 模型缓存
private var cachedPredictions: [String: LayoutRecommendation] = [:]
private let cacheQueue = DispatchQueue(label: "ai.cache")

func getCachedPrediction(for key: String) -> LayoutRecommendation? {
    return cacheQueue.sync {
        return cachedPredictions[key]
    }
}

func cachePrediction(_ prediction: LayoutRecommendation, for key: String) {
    cacheQueue.async {
        self.cachedPredictions[key] = prediction
        // 限制缓存大小
        if self.cachedPredictions.count > 100 {
            self.cachedPredictions.removeAll()
        }
    }
}
```

### 2. 异步处理

```swift
// 使用DispatchGroup管理多个异步操作
func predictWithMultipleModels(
    input: String,
    context: InputContext,
    completion: @escaping ([LayoutRecommendation]) -> Void
) {
    let group = DispatchGroup()
    var predictions: [LayoutRecommendation] = []
    
    // 并行执行多个模型推理
    group.enter()
    model1.predict(input: input, context: context) { prediction in
        predictions.append(prediction)
        group.leave()
    }
    
    group.enter()
    model2.predict(input: input, context: context) { prediction in
        predictions.append(prediction)
        group.leave()
    }
    
    group.notify(queue: .main) {
        completion(predictions)
    }
}
```

## 🧪 测试和调试

### 1. 单元测试

```swift
import XCTest
@testable import KeySpriteKeyboard

class AIServiceTests: XCTestCase {
    
    var aiService: AIService!
    
    override func setUp() {
        super.setUp()
        // 设置测试环境
    }
    
    override func tearDown() {
        aiService = nil
        super.tearDown()
    }
    
    func testFeatureExtraction() {
        // 测试特征提取
        let input = "Hello World"
        let context = InputContext(/* 测试上下文 */)
        
        let features = featureExtractor.extractFeatures(from: input, context: context)
        
        XCTAssertFalse(features.isEmpty)
        XCTAssertEqual(features.count, expectedFeatureCount)
    }
    
    func testModelInference() {
        // 测试模型推理
        let expectation = XCTestExpectation(description: "AI推理完成")
        
        aiService.predictNextLayout(input: "Test", context: context) { result in
            switch result {
            case .success(let recommendation):
                XCTAssertNotNil(recommendation.recommendedLayout)
                XCTAssertGreaterThan(recommendation.confidence, 0.0)
            case .failure(let error):
                XCTFail("推理失败: \(error)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testPerformance() {
        // 性能测试
        measure {
            // 执行AI推理
            let _ = try? inferenceEngine.predictNextLayout(input: "Performance test", context: context)
        }
    }
}
```

### 2. 集成测试

```swift
class KeyboardAIIntegrationTests: XCTestCase {
    
    func testAIRecommendationFlow() {
        // 测试完整的AI推荐流程
        let keyboard = KeyboardViewController()
        keyboard.loadViewIfNeeded()
        
        // 模拟输入
        keyboard.textDocumentProxy.insertText("Hello")
        
        // 验证AI推荐是否被调用
        // 这里需要mock或spy来验证
    }
}
```

## 🚨 常见问题和解决方案

### 1. 模型加载失败

**问题**: 模型文件无法加载
**解决方案**:
- 检查模型文件是否正确添加到项目中
- 验证Bundle中是否包含模型文件
- 检查模型文件格式是否正确

### 2. 推理性能问题

**问题**: AI推理速度慢
**解决方案**:
- 使用模型量化
- 优化特征提取算法
- 实现结果缓存
- 使用异步处理

### 3. 内存占用过高

**问题**: 应用内存使用过多
**解决方案**:
- 限制缓存大小
- 及时释放不需要的资源
- 使用内存池管理
- 监控内存使用情况

### 4. 电池消耗问题

**问题**: AI功能消耗电池过多
**解决方案**:
- 减少推理频率
- 使用智能缓存
- 优化算法复杂度
- 提供用户控制选项

## 📚 参考资料

- [Core ML Framework Documentation](https://developer.apple.com/documentation/coreml)
- [Integrating a Core ML Model into Your App](https://developer.apple.com/documentation/coreml/integrating_a_core_ml_model_into_your_app)
- [Core ML Best Practices](https://developer.apple.com/documentation/coreml/integrating_a_core_ml_model_into_your_app)
- [WWDC Sessions on Core ML](https://developer.apple.com/videos/play/wwdc2020/10153/)

## 📝 更新日志

| 版本 | 日期 | 更新内容 |
|------|------|----------|
| 1.0.0 | 2024-01-XX | 初始Core ML集成指南 |

---

**注意**: 本指南需要根据你的具体模型格式和需求进行调整。请确保模型输入输出格式与代码实现匹配。
