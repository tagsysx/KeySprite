//
//  InputEngine.swift
//  KeySpirteKeyboard
//
//  Created by Lei Yang on 12/8/2025.
//

import Foundation
import UIKit

class InputEngine {
    
    // MARK: - Properties
    private var currentInput: String = ""
    private var inputHistory: [String] = []
    private var sessionStartTime: Date = Date()
    private var lastInputTime: Date = Date()
    private var inputSpeed: Double = 0.0
    private var currentContext: InputContext?
    
    // MARK: - Configuration
    private let maxHistorySize = 100
    private let sessionTimeout: TimeInterval = 300 // 5分钟
    
    // MARK: - Initialization
    init() {
        startNewSession()
    }
    
    // MARK: - Session Management
    private func startNewSession() {
        sessionStartTime = Date()
        lastInputTime = Date()
        inputSpeed = 0.0
        currentInput = ""
    }
    
    private func checkSessionTimeout() {
        let timeSinceLastInput = Date().timeIntervalSince(lastInputTime)
        if timeSinceLastInput > sessionTimeout {
            startNewSession()
        }
    }
    
    // MARK: - Input Processing
    func handleKeyPress(_ key: KeyboardKey) {
        // 检查会话超时
        checkSessionTimeout()
        
        // 更新最后输入时间
        lastInputTime = Date()
        
        // 处理按键输入
        switch key.type {
        case .character:
            processCharacterInput(key.character)
        case .backspace:
            processBackspace()
        case .space:
            processSpaceInput()
        case .return:
            processReturnInput()
        case .shift:
            processShiftInput()
        case .layout:
            processLayoutInput(key.character)
        case .emoji:
            processEmojiInput(key.character)
        }
        
        // 更新输入速度
        updateInputSpeed()
        
        // 更新当前上下文
        updateCurrentContext()
    }
    
    private func processCharacterInput(_ character: String) {
        currentInput += character
        addToHistory(character)
    }
    
    private func processBackspace() {
        if !currentInput.isEmpty {
            currentInput.removeLast()
        }
    }
    
    private func processSpaceInput() {
        currentInput += " "
        addToHistory(" ")
    }
    
    private func processReturnInput() {
        currentInput += "\n"
        addToHistory("\n")
    }
    
    private func processShiftInput() {
        // 处理大小写切换
        // 这里可以实现更复杂的逻辑
    }
    
    private func processLayoutInput(_ layoutString: String) {
        // 处理布局切换
        // 这里可以实现更复杂的逻辑
    }
    
    private func processEmojiInput(_ emoji: String) {
        currentInput += emoji
        addToHistory(emoji)
    }
    
    // MARK: - History Management
    private func addToHistory(_ input: String) {
        inputHistory.append(input)
        
        // 限制历史记录大小
        if inputHistory.count > maxHistorySize {
            inputHistory.removeFirst()
        }
    }
    
    func getInputHistory() -> [String] {
        return inputHistory
    }
    
    func clearHistory() {
        inputHistory.removeAll()
    }
    
    // MARK: - Input Speed Calculation
    private func updateInputSpeed() {
        let timeSinceSessionStart = Date().timeIntervalSince(sessionStartTime)
        let totalInputs = inputHistory.count
        
        if timeSinceSessionStart > 0 {
            inputSpeed = Double(totalInputs) / timeSinceSessionStart
        }
    }
    
    func getCurrentInputSpeed() -> Double {
        return inputSpeed
    }
    
    // MARK: - Context Management
    private func updateCurrentContext() {
        let context = createInputContext()
        currentContext = context
    }
    
    func getCurrentContext() -> InputContext {
        return currentContext ?? createInputContext()
    }
    
    private func createInputContext() -> InputContext {
        let textBeforeCursor = currentInput
        let textAfterCursor = ""
        let currentWord = extractCurrentWord()
        let appType = detectAppType()
        let inputFieldType = detectInputFieldType()
        let timeOfDay = getCurrentTimeOfDay()
        let userActivity = determineUserActivity()
        
        return InputContext(
            currentInput: currentInput,
            textBeforeCursor: textBeforeCursor,
            textAfterCursor: textAfterCursor,
            currentWord: currentWord,
            appType: appType,
            inputFieldType: inputFieldType,
            timeOfDay: timeOfDay,
            userActivity: userActivity
        )
    }
    
    private func extractCurrentWord() -> String {
        // 提取当前正在输入的单词
        let words = currentInput.components(separatedBy: .whitespacesAndNewlines)
        return words.last ?? ""
    }
    
    private func detectAppType() -> AppType {
        // 这里应该实现应用类型检测
        // 目前返回默认值
        return .other
    }
    
    private func detectInputFieldType() -> InputFieldType {
        // 这里应该实现输入框类型检测
        // 基于当前输入内容进行推测
        if currentInput.contains("@") && currentInput.contains(".") {
            return .email
        } else if currentInput.hasPrefix("http://") || currentInput.hasPrefix("https://") {
            return .url
        } else if currentInput.contains("password") || currentInput.contains("密码") {
            return .password
        } else if currentInput.contains("search") || currentInput.contains("搜索") {
            return .search
        } else {
            return .text
        }
    }
    
    private func getCurrentTimeOfDay() -> TimeOfDay {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 6..<12:
            return .morning
        case 12..<18:
            return .afternoon
        case 18..<22:
            return .evening
        default:
            return .night
        }
    }
    
    private func determineUserActivity() -> UserActivity {
        let timeSinceLastInput = Date().timeIntervalSince(lastInputTime)
        
        if timeSinceLastInput < 1.0 {
            return .typing
        } else if timeSinceLastInput < 5.0 {
            return .editing
        } else if timeSinceLastInput < 30.0 {
            return .searching
        } else if timeSinceLastInput < 300.0 {
            return .browsing
        } else {
            return .idle
        }
    }
    
    // MARK: - Text Analysis
    func analyzeText(_ text: String) -> TextAnalysis {
        let chineseCharCount = text.filter { $0.isChinese }.count
        let englishCharCount = text.filter { $0.isEnglish }.count
        let numberCount = text.filter { $0.isNumber }.count
        let symbolCount = text.filter { $0.isSymbol }.count
        let wordCount = text.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }.count
        let sentenceCount = text.components(separatedBy: .punctuationCharacters).filter { !$0.isEmpty }.count
        
        let primaryLanguage: Language
        if chineseCharCount > englishCharCount {
            primaryLanguage = .chinese
        } else if englishCharCount > 0 {
            primaryLanguage = .english
        } else if numberCount > 0 {
            primaryLanguage = .numeric
        } else if symbolCount > 0 {
            primaryLanguage = .symbolic
        } else {
            primaryLanguage = .unknown
        }
        
        return TextAnalysis(
            primaryLanguage: primaryLanguage,
            chineseCharCount: chineseCharCount,
            englishCharCount: englishCharCount,
            numberCount: numberCount,
            symbolCount: symbolCount,
            wordCount: wordCount,
            sentenceCount: sentenceCount,
            averageWordLength: wordCount > 0 ? Double(text.count) / Double(wordCount) : 0
        )
    }
    
    // MARK: - Reset
    func reset() {
        currentInput = ""
        inputHistory.removeAll()
        startNewSession()
    }
}

// MARK: - Text Analysis
struct TextAnalysis {
    let primaryLanguage: Language
    let chineseCharCount: Int
    let englishCharCount: Int
    let numberCount: Int
    let symbolCount: Int
    let wordCount: Int
    let sentenceCount: Int
    let averageWordLength: Double
}

enum Language {
    case chinese
    case english
    case numeric
    case symbolic
    case unknown
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
