//
//  Models.swift
//  KeySpirteKeyboard
//
//  Created by Lei Yang on 12/8/2025.
//

import Foundation

// MARK: - Keyboard Layout
enum KeyboardLayout: String, CaseIterable {
    case qwerty = "QWERTY"
    case chinese = "Chinese"
    case number = "Number"
    case symbol = "Symbol"
    case emoji = "Emoji"
}

// MARK: - Key Types
enum KeyType {
    case character      // 字符键
    case backspace     // 删除键
    case space         // 空格键
    case `return`      // 回车键
    case shift         // 大小写切换
    case layout        // 布局切换
    case emoji         // 表情键
}

// MARK: - Keyboard Key
struct KeyboardKey {
    let character: String
    let type: KeyType
    
    init(character: String, type: KeyType) {
        self.character = character
        self.type = type
    }
}

// MARK: - Input Context
struct InputContext {
    let currentInput: String
    let textBeforeCursor: String
    let textAfterCursor: String
    let currentWord: String
    let appType: AppType
    let inputFieldType: InputFieldType
    let timeOfDay: TimeOfDay
    let userActivity: UserActivity
    
    init(currentInput: String = "", 
         textBeforeCursor: String = "", 
         textAfterCursor: String = "", 
         currentWord: String = "",
         appType: AppType = .other,
         inputFieldType: InputFieldType = .text,
         timeOfDay: TimeOfDay = .morning,
         userActivity: UserActivity = .typing) {
        self.currentInput = currentInput
        self.textBeforeCursor = textBeforeCursor
        self.textAfterCursor = textAfterCursor
        self.currentWord = currentWord
        self.appType = appType
        self.inputFieldType = inputFieldType
        self.timeOfDay = timeOfDay
        self.userActivity = userActivity
    }
}

// MARK: - Layout Recommendation
class LayoutRecommendation {
    let recommendedLayout: KeyboardLayout
    let confidence: Float
    let alternatives: [KeyboardLayout]
    let reasoning: String
    
    init(recommendedLayout: KeyboardLayout, 
         confidence: Float, 
         alternatives: [KeyboardLayout] = [], 
         reasoning: String = "") {
        self.recommendedLayout = recommendedLayout
        self.confidence = confidence
        self.alternatives = alternatives
        self.reasoning = reasoning
    }
}

// MARK: - User Feedback
struct UserFeedback {
    let recommendation: LayoutRecommendation
    let userAction: UserAction
    let timestamp: Date
    let context: InputContext
    
    init(recommendation: LayoutRecommendation, 
         userAction: UserAction, 
         timestamp: Date = Date(), 
         context: InputContext) {
        self.recommendation = recommendation
        self.userAction = userAction
        self.timestamp = timestamp
        self.context = context
    }
}

// MARK: - Enums
enum AppType: String, CaseIterable {
    case messaging = "Messaging"
    case social = "Social"
    case productivity = "Productivity"
    case browser = "Browser"
    case other = "Other"
}

enum InputFieldType: String, CaseIterable {
    case text = "Text"
    case email = "Email"
    case password = "Password"
    case search = "Search"
    case url = "URL"
}

enum TimeOfDay: String, CaseIterable {
    case morning = "Morning"      // 6-12点
    case afternoon = "Afternoon"  // 12-18点
    case evening = "Evening"      // 18-22点
    case night = "Night"          // 22-6点
}

enum UserActivity: String, CaseIterable {
    case typing = "Typing"
    case editing = "Editing"
    case searching = "Searching"
    case browsing = "Browsing"
    case idle = "Idle"
}

enum UserAction: String, CaseIterable {
    case accepted = "Accepted"
    case rejected = "Rejected"
    case ignored = "Ignored"
}

// MARK: - Feature Vector
struct FeatureVector {
    // 文本特征 (10维)
    let textLength: Float
    let englishCharCount: Float
    let chineseCharCount: Float
    let numberCount: Float
    let symbolCount: Float
    let wordCount: Float
    let sentenceCount: Float
    let avgWordLength: Float
    let lastCharType: Float
    let inputSpeed: Float
    
    // 上下文特征 (8维)
    let appType: Float
    let inputFieldType: Float
    let timeOfDay: Float
    let userActivity: Float
    let previousLayout: Float
    let layoutSwitchCount: Float
    let sessionDuration: Float
    let deviceOrientation: Float
    
    // 用户特征 (6维)
    let preferredLayout: Float
    let qwertyUsage: Float
    let chineseUsage: Float
    let numberUsage: Float
    let symbolUsage: Float
    let emojiUsage: Float
    
    func toArray() -> [Float] {
        return [
            textLength, englishCharCount, chineseCharCount, numberCount, symbolCount,
            wordCount, sentenceCount, avgWordLength, lastCharType, inputSpeed,
            appType, inputFieldType, timeOfDay, userActivity, previousLayout,
            layoutSwitchCount, sessionDuration, deviceOrientation,
            preferredLayout, qwertyUsage, chineseUsage, numberUsage, symbolUsage, emojiUsage
        ]
    }
}
