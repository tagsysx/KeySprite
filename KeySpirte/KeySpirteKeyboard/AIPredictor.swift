//
//  AIPredictor.swift
//  KeySpirteKeyboard
//
//  Created by Lei Yang on 12/8/2025.
//

import Foundation
import CoreML

class AIPredictor {
    
    // MARK: - Properties
    private var model: MLModel?
    private let featureExtractor = FeatureExtractor()
    private let resultHandler = ResultHandler()
    
    // MARK: - Configuration
    private let isAIEnabled = true
    private let predictionCache = NSCache<NSString, LayoutRecommendation>()
    private let cacheTimeout: TimeInterval = 60 // 1分钟缓存
    
    // MARK: - Initialization
    init() {
        loadModel()
    }
    
    // MARK: - Model Loading
    private func loadModel() {
        // 这里应该加载实际的Core ML模型
        // 目前使用模拟实现
        print("AI Model loaded successfully")
    }
    
    // MARK: - Prediction Interface
    func predictNextLayout(
        input: String,
        context: InputContext,
        completion: @escaping (Result<LayoutRecommendation, Error>) -> Void
    ) {
        // 检查缓存
        let cacheKey = generateCacheKey(input: input, context: context)
        if let cachedResult = predictionCache.object(forKey: cacheKey) {
            completion(.success(cachedResult))
            return
        }
        
        // 如果AI未启用，使用规则基础推荐
        guard isAIEnabled else {
            let ruleBasedRecommendation = generateRuleBasedRecommendation(for: context)
            completion(.success(ruleBasedRecommendation))
            return
        }
        
        // 执行AI预测
        performAIPrediction(input: input, context: context) { [weak self] result in
            switch result {
            case .success(let recommendation):
                // 缓存结果
                self?.predictionCache.setObject(recommendation, forKey: cacheKey)
                completion(.success(recommendation))
                
            case .failure(let error):
                // AI预测失败，回退到规则基础推荐
                let fallbackRecommendation = self?.generateRuleBasedRecommendation(for: context)
                if let fallback = fallbackRecommendation {
                    completion(.success(fallback))
                } else {
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - AI Prediction
    private func performAIPrediction(
        input: String,
        context: InputContext,
        completion: @escaping (Result<LayoutRecommendation, Error>) -> Void
    ) {
        // 暂时使用同步实现，避免DispatchQueue问题
        do {
            // 1. 特征提取
            let features = self.featureExtractor.extractFeatures(from: input, context: context)
            
            // 2. 特征预处理
            let processedFeatures = self.featureExtractor.preprocessFeatures(features)
            
            // 3. 模型推理
            let prediction = try self.runModelInference(features: processedFeatures)
            
            // 4. 结果处理
            let recommendation = self.resultHandler.processResults(prediction)
            
            if let recommendation = recommendation {
                completion(.success(recommendation))
            } else {
                completion(.failure(AIPredictorError.processingFailed))
            }
            
        } catch {
            completion(.failure(error))
        }
    }
    
    private func runModelInference(features: [Float]) throws -> MLFeatureProvider {
        // 这里应该调用实际的Core ML模型
        // 目前使用模拟实现
        return MockMLFeatureProvider(features: features)
    }
    
    // MARK: - Rule-based Fallback
    private func generateRuleBasedRecommendation(for context: InputContext) -> LayoutRecommendation {
        let recommendedLayout: KeyboardLayout
        let confidence: Float
        let reasoning: String
        
        switch context.inputFieldType {
        case .email, .url, .password:
            recommendedLayout = .qwerty
            confidence = 0.9
            reasoning = "Email/URL/Password fields typically require QWERTY layout"
            
        case .search:
            recommendedLayout = .qwerty
            confidence = 0.8
            reasoning = "Search fields usually benefit from QWERTY layout"
            
        case .text:
            // 基于文本内容分析
            let textAnalysis = analyzeTextContent(context.currentInput)
            recommendedLayout = textAnalysis.recommendedLayout
            confidence = textAnalysis.confidence
            reasoning = textAnalysis.reasoning
        }
        
        return LayoutRecommendation(
            recommendedLayout: recommendedLayout,
            confidence: confidence,
            alternatives: generateAlternatives(for: recommendedLayout),
            reasoning: reasoning
        )
    }
    
    private func analyzeTextContent(_ text: String) -> (recommendedLayout: KeyboardLayout, confidence: Float, reasoning: String) {
        let chineseCharCount = text.filter { $0.isChinese }.count
        let englishCharCount = text.filter { $0.isEnglish }.count
        let numberCount = text.filter { $0.isNumber }.count
        let symbolCount = text.filter { $0.isSymbol }.count
        
        if chineseCharCount > englishCharCount && chineseCharCount > 0 {
            return (.chinese, 0.85, "Text contains Chinese characters")
        } else if numberCount + symbolCount > englishCharCount {
            return (.number, 0.8, "Text contains numbers and symbols")
        } else {
            return (.qwerty, 0.7, "Text is primarily English")
        }
    }
    
    private func generateAlternatives(for layout: KeyboardLayout) -> [KeyboardLayout] {
        let allLayouts = KeyboardLayout.allCases
        return allLayouts.filter { $0 != layout }
    }
    
    // MARK: - Cache Management
    private func generateCacheKey(input: String, context: InputContext) -> NSString {
        let keyString = "\(input)_\(context.inputFieldType.rawValue)_\(context.appType.rawValue)"
        return NSString(string: keyString)
    }
    
    func clearCache() {
        predictionCache.removeAllObjects()
    }
    
    // MARK: - Model Update
    func updateModel(with feedback: UserFeedback) {
        // 这里应该实现模型更新逻辑
        // 目前只是记录反馈
        print("Model updated with feedback: \(feedback.userAction.rawValue)")
    }
}

// MARK: - Feature Extractor
private class FeatureExtractor {
    func extractFeatures(from input: String, context: InputContext) -> FeatureVector {
        // 文本特征
        let textLength = Float(input.count)
        let englishCharCount = Float(input.filter { $0.isEnglish }.count)
        let chineseCharCount = Float(input.filter { $0.isChinese }.count)
        let numberCount = Float(input.filter { $0.isNumber }.count)
        let symbolCount = Float(input.filter { $0.isSymbol }.count)
        let wordCount = Float(input.components(separatedBy: .whitespaces).filter { !$0.isEmpty }.count)
        let sentenceCount = Float(input.components(separatedBy: .punctuationCharacters).filter { !$0.isEmpty }.count)
        let avgWordLength = wordCount > 0 ? textLength / wordCount : 0
        let lastCharType = getLastCharType(input)
        let inputSpeed = calculateInputSpeed()
        
        // 上下文特征
        let appType = encodeAppType(context.appType)
        let inputFieldType = encodeInputFieldType(context.inputFieldType)
        let timeOfDay = encodeTimeOfDay(context.timeOfDay)
        let userActivity = encodeUserActivity(context.userActivity)
        let previousLayout: Float = 0 // 需要从布局管理器获取
        let layoutSwitchCount: Float = 0 // 需要从布局管理器获取
        let sessionDuration: Float = 0 // 需要计算会话持续时间
        let deviceOrientation: Float = 0 // 需要获取设备方向
        
        // 用户特征
        let preferredLayout: Float = 0 // 需要从用户偏好获取
        let qwertyUsage: Float = 0 // 需要从使用统计获取
        let chineseUsage: Float = 0
        let numberUsage: Float = 0
        let symbolUsage: Float = 0
        let emojiUsage: Float = 0
        
        return FeatureVector(
            textLength: textLength,
            englishCharCount: englishCharCount,
            chineseCharCount: chineseCharCount,
            numberCount: numberCount,
            symbolCount: symbolCount,
            wordCount: wordCount,
            sentenceCount: sentenceCount,
            avgWordLength: avgWordLength,
            lastCharType: lastCharType,
            inputSpeed: inputSpeed,
            appType: appType,
            inputFieldType: inputFieldType,
            timeOfDay: timeOfDay,
            userActivity: userActivity,
            previousLayout: previousLayout,
            layoutSwitchCount: layoutSwitchCount,
            sessionDuration: sessionDuration,
            deviceOrientation: deviceOrientation,
            preferredLayout: preferredLayout,
            qwertyUsage: qwertyUsage,
            chineseUsage: chineseUsage,
            numberUsage: numberUsage,
            symbolUsage: symbolUsage,
            emojiUsage: emojiUsage
        )
    }
    
    func preprocessFeatures(_ features: FeatureVector) -> [Float] {
        // 特征标准化和归一化
        return normalizeFeatures(features.toArray())
    }
    
    private func getLastCharType(_ input: String) -> Float {
        guard let lastChar = input.last else { return 0 }
        
        if lastChar.isEnglish {
            return 1.0
        } else if lastChar.isChinese {
            return 2.0
        } else if lastChar.isNumber {
            return 3.0
        } else if lastChar.isSymbol {
            return 4.0
        } else {
            return 0.0
        }
    }
    
    private func calculateInputSpeed() -> Float {
        // 这里应该实现实际的输入速度计算
        return 1.0
    }
    
    private func encodeAppType(_ appType: AppType) -> Float {
        switch appType {
        case .messaging: return 1.0
        case .social: return 2.0
        case .productivity: return 3.0
        case .browser: return 4.0
        case .other: return 5.0
        }
    }
    
    private func encodeInputFieldType(_ fieldType: InputFieldType) -> Float {
        switch fieldType {
        case .text: return 1.0
        case .email: return 2.0
        case .password: return 3.0
        case .search: return 4.0
        case .url: return 5.0
        }
    }
    
    private func encodeTimeOfDay(_ time: TimeOfDay) -> Float {
        switch time {
        case .morning: return 1.0
        case .afternoon: return 2.0
        case .evening: return 3.0
        case .night: return 4.0
        }
    }
    
    private func encodeUserActivity(_ activity: UserActivity) -> Float {
        switch activity {
        case .typing: return 1.0
        case .editing: return 2.0
        case .searching: return 3.0
        case .browsing: return 4.0
        case .idle: return 5.0
        }
    }
    
    private func normalizeFeatures(_ features: [Float]) -> [Float] {
        // 简单的特征归一化
        return features.map { min(max($0, 0), 1) }
    }
}

// MARK: - Result Handler
private class ResultHandler {
    func processResults(_ output: MLFeatureProvider) -> LayoutRecommendation? {
        // 这里应该处理实际的模型输出
        // 目前返回默认推荐
        return LayoutRecommendation(
            recommendedLayout: .qwerty,
            confidence: 0.8,
            alternatives: [.chinese, .number],
            reasoning: "Default recommendation based on current context"
        )
    }
}

// MARK: - Mock MLFeatureProvider
private class MockMLFeatureProvider: MLFeatureProvider {
    private let features: [Float]
    
    init(features: [Float]) {
        self.features = features
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var featureNames: Set<String> {
        return Set(["output"])
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        let shape = [NSNumber(value: 1), NSNumber(value: features.count)]
        guard let multiArray = try? MLMultiArray(shape: shape, dataType: .float32) else {
            return nil
        }
        return MLFeatureValue(multiArray: multiArray)
    }
}

// MARK: - Errors
enum AIPredictorError: Error {
    case modelNotLoaded
    case processingFailed
    case invalidInput
}

// MARK: - Character Extensions
private extension Character {
    var isChinese: Bool {
        return self.unicodeScalars.contains { scalar in
            scalar.properties.generalCategory == .otherLetter &&
            scalar.value >= 0x4E00 && scalar.value <= 0x9FFF
        }
    }
    
    var isEnglish: Bool {
        return self.isLetter && self.unicodeScalars.first?.properties.generalCategory == .lowercaseLetter ||
               self.unicodeScalars.first?.properties.generalCategory == .uppercaseLetter
    }
    
    var isSymbol: Bool {
        return self.unicodeScalars.contains { scalar in
            scalar.properties.generalCategory == .otherPunctuation ||
            scalar.properties.generalCategory == .mathSymbol ||
            scalar.properties.generalCategory == .currencySymbol
        }
    }
}
