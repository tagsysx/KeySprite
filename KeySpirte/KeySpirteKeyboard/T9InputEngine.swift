//
//  T9InputEngine.swift
//  KeySpirteKeyboard
//
//  Created by Lei Yang on 12/8/2025.
//

import Foundation

// MARK: - T9 Input Engine
class T9InputEngine {
    
    // MARK: - Properties
    private var currentInput: String = ""
    private var candidateWords: [String] = []
    private var currentWordIndex: Int = 0
    
    // MARK: - T9 Key Mapping
    private let t9KeyMapping: [String: [String]] = [
        "1": [".", "!", "?"],
        "2": ["A", "B", "C", "a", "b", "c"],
        "3": ["D", "E", "F", "d", "e", "f"],
        "4": ["G", "H", "I", "g", "h", "i"],
        "5": ["J", "K", "L", "j", "k", "l"],
        "6": ["M", "N", "O", "m", "n", "o"],
        "7": ["P", "Q", "R", "S", "p", "q", "r", "s"],
        "8": ["T", "U", "V", "t", "u", "v"],
        "9": ["W", "X", "Y", "Z", "w", "x", "y", "z"],
        "0": [" "],
        "*": ["*"],
        "#": ["#"]
    ]
    
    // MARK: - Chinese Pinyin Mapping (简化版)
    private let pinyinToChinese: [String: [String]] = [
        "ni": ["你", "尼", "泥", "逆", "拟"],
        "hao": ["好", "号", "毫", "豪", "耗"],
        "wo": ["我", "握", "卧", "沃", "涡"],
        "de": ["的", "得", "德", "地"],
        "shi": ["是", "时", "事", "世", "市"],
        "le": ["了", "乐", "勒", "肋"],
        "zai": ["在", "再", "载", "灾", "宰"],
        "you": ["有", "又", "右", "由", "游"],
        "he": ["和", "河", "合", "何", "喝"],
        "ma": ["吗", "妈", "马", "麻", "骂"],
        "bu": ["不", "步", "部", "布", "补"],
        "ke": ["可", "科", "课", "客", "刻"],
        "yi": ["一", "以", "已", "意", "易"],
        "ge": ["个", "各", "格", "哥", "歌"],
        "ren": ["人", "任", "认", "忍", "仁"],
        "men": ["们", "门", "闷", "扪"],
        "zhe": ["这", "着", "者", "折", "哲"],
        "na": ["那", "哪", "拿", "纳", "娜"],
        "li": ["里", "理", "力", "立", "利"],
        "dao": ["到", "道", "倒", "刀", "导"]
    ]
    
    // MARK: - Initialization
    init() {
        reset()
    }
    
    // MARK: - Public Methods
    func inputKey(_ key: String) -> T9InputResult {
        switch key {
        case "0":
            return .space
        case "删除":
            return deleteLastInput()
        case "确定":
            return confirmInput()
        case "候选词":
            return nextCandidate()
        case "1", "2", "3", "4", "5", "6", "7", "8", "9", "*", "#":
            return addInput(key)
        default:
            return .none
        }
    }
    
    func getCurrentInput() -> String {
        return currentInput
    }
    
    func getCandidateWords() -> [String] {
        return candidateWords
    }
    
    func getCurrentCandidate() -> String? {
        guard !candidateWords.isEmpty else { return nil }
        return candidateWords[currentWordIndex]
    }
    
    func reset() {
        currentInput = ""
        candidateWords = []
        currentWordIndex = 0
    }
    
    // MARK: - Private Methods
    private func addInput(_ key: String) -> T9InputResult {
        currentInput += key
        updateCandidates()
        
        if let candidate = getCurrentCandidate() {
            return .candidate(candidate)
        } else {
            return .input(currentInput)
        }
    }
    
    private func deleteLastInput() -> T9InputResult {
        guard !currentInput.isEmpty else { return .none }
        
        currentInput.removeLast()
        updateCandidates()
        
        if currentInput.isEmpty {
            return .cleared
        } else if let candidate = getCurrentCandidate() {
            return .candidate(candidate)
        } else {
            return .input(currentInput)
        }
    }
    
    private func confirmInput() -> T9InputResult {
        guard let candidate = getCurrentCandidate() else { return .none }
        
        let result: T9InputResult = .confirmed(candidate)
        reset()
        return result
    }
    
    private func nextCandidate() -> T9InputResult {
        guard !candidateWords.isEmpty else { return .none }
        
        currentWordIndex = (currentWordIndex + 1) % candidateWords.count
        if let candidate = getCurrentCandidate() {
            return .candidate(candidate)
        }
        return .none
    }
    
    private func updateCandidates() {
        candidateWords = generateCandidates(from: currentInput)
        currentWordIndex = 0
    }
    
    private func generateCandidates(from input: String) -> [String] {
        var candidates: [String] = []
        
        // 1. 直接匹配拼音
        if let chineseWords = pinyinToChinese[input.lowercased()] {
            candidates.append(contentsOf: chineseWords)
        }
        
        // 2. 生成可能的拼音组合
        let possiblePinyins = generatePossiblePinyins(from: input)
        for pinyin in possiblePinyins {
            if let chineseWords = pinyinToChinese[pinyin] {
                candidates.append(contentsOf: chineseWords)
            }
        }
        
        // 3. 添加数字输入
        if input.count <= 3 {
            candidates.append(input)
        }
        
        // 4. 去重并限制数量
        candidates = Array(Set(candidates)).prefix(10).map { $0 }
        
        return Array(candidates)
    }
    
    private func generatePossiblePinyins(from input: String) -> [String] {
        var pinyins: [String] = []
        
        // 简单的拼音组合生成（实际应用中需要更复杂的算法）
        if input.count >= 2 {
            // 尝试不同的分割方式
            for i in 1..<input.count {
                let part1 = String(input.prefix(i))
                let part2 = String(input.suffix(from: input.index(input.startIndex, offsetBy: i)))
                
                if pinyinToChinese[part1.lowercased()] != nil || pinyinToChinese[part2.lowercased()] != nil {
                    pinyins.append(part1)
                    pinyins.append(part2)
                }
            }
        }
        
        return pinyins
    }
}

// MARK: - T9 Input Result
enum T9InputResult {
    case none
    case input(String)           // 显示当前输入
    case candidate(String)       // 显示候选词
    case confirmed(String)       // 确认输入
    case space                   // 空格
    case cleared                 // 清空输入
}
