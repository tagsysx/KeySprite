//
//  KeyboardLayoutManager.swift
//  KeySpirteKeyboard
//
//  Created by Lei Yang on 12/8/2025.
//

import Foundation

class KeyboardLayoutManager {
    
    // MARK: - Properties
    private var currentLayout: KeyboardLayout = .qwerty
    private var layoutHistory: [KeyboardLayout] = []
    private var layoutUsageStats: [KeyboardLayout: Int] = [:]
    
    // MARK: - Initialization
    init() {
        setupDefaultStats()
    }
    
    private func setupDefaultStats() {
        for layout in KeyboardLayout.allCases {
            layoutUsageStats[layout] = 0
        }
    }
    
    // MARK: - Layout Management
    func getCurrentLayout() -> KeyboardLayout {
        return currentLayout
    }
    
    func setCurrentLayout(_ layout: KeyboardLayout) {
        // 记录布局历史
        if currentLayout != layout {
            layoutHistory.append(currentLayout)
            
            // 限制历史记录长度
            if layoutHistory.count > 10 {
                layoutHistory.removeFirst()
            }
            
            // 更新使用统计
            layoutUsageStats[layout, default: 0] += 1
            
            currentLayout = layout
        }
    }
    
    func switchToNextLayout() {
        let allLayouts = KeyboardLayout.allCases
        guard let currentIndex = allLayouts.firstIndex(of: currentLayout) else { return }
        
        let nextIndex = (currentIndex + 1) % allLayouts.count
        let nextLayout = allLayouts[nextIndex]
        setCurrentLayout(nextLayout)
    }
    
    func switchToPreviousLayout() {
        let allLayouts = KeyboardLayout.allCases
        guard let currentIndex = allLayouts.firstIndex(of: currentLayout) else { return }
        
        let previousIndex = (currentIndex - 1 + allLayouts.count) % allLayouts.count
        let previousLayout = allLayouts[previousIndex]
        setCurrentLayout(previousLayout)
    }
    
    func switchToLayout(_ layout: KeyboardLayout) {
        setCurrentLayout(layout)
    }
    
    // MARK: - Layout History
    func getPreviousLayout() -> KeyboardLayout? {
        return layoutHistory.last
    }
    
    func canGoBack() -> Bool {
        return !layoutHistory.isEmpty
    }
    
    func goBack() -> Bool {
        guard let previousLayout = layoutHistory.popLast() else { return false }
        setCurrentLayout(previousLayout)
        return true
    }
    
    // MARK: - Usage Statistics
    func getLayoutUsageStats() -> [KeyboardLayout: Int] {
        return layoutUsageStats
    }
    
    func getMostUsedLayout() -> KeyboardLayout? {
        return layoutUsageStats.max(by: { $0.value < $1.value })?.key
    }
    
    func getLayoutUsageCount(for layout: KeyboardLayout) -> Int {
        return layoutUsageStats[layout] ?? 0
    }
    
    // MARK: - Smart Layout Switching
    func getRecommendedLayout(for context: InputContext) -> KeyboardLayout {
        // 基于上下文的智能布局推荐
        switch context.inputFieldType {
        case .email, .url:
            return .qwerty
        case .password:
            return .qwerty
        case .search:
            return .qwerty
        case .text:
            // 基于文本内容推荐
            return recommendLayoutForText(context.currentInput)
        }
    }
    
    private func recommendLayoutForText(_ text: String) -> KeyboardLayout {
        let chineseCharCount = text.filter { $0.isChinese }.count
        let englishCharCount = text.filter { $0.isEnglish }.count
        let numberCount = text.filter { $0.isNumber }.count
        let symbolCount = text.filter { $0.isSymbol }.count
        
        // 如果中文字符占主导，推荐中文布局
        if chineseCharCount > englishCharCount && chineseCharCount > 0 {
            return .chinese
        }
        
        // 如果数字和符号占主导，推荐数字符号布局
        if numberCount + symbolCount > englishCharCount {
            return .number
        }
        
        // 默认推荐QWERTY布局
        return .qwerty
    }
    
    // MARK: - Layout Validation
    func isValidLayout(_ layout: KeyboardLayout) -> Bool {
        return KeyboardLayout.allCases.contains(layout)
    }
    
    // MARK: - Reset
    func resetStats() {
        layoutUsageStats.removeAll()
        setupDefaultStats()
    }
    
    func clearHistory() {
        layoutHistory.removeAll()
    }
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
