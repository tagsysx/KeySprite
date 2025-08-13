//
//  KeyboardLayoutSpecs.swift
//  KeySpirteKeyboard
//
//  Created by Lei Yang on 12/8/2025.
//

import Foundation

// MARK: - Base Layout Specification
protocol KeyboardLayoutSpec {
    var rows: Int { get }
    var keysPerRow: [Int] { get }
    var keyHeight: CGFloat { get }
    var keySpacing: CGFloat { get }
    var rowSpacing: CGFloat { get }
    var layout: [[String]] { get }
}

// MARK: - QWERTY Layout
class QWERTYLayoutSpec: KeyboardLayoutSpec {
    let rows = 4
    let keysPerRow = [10, 9, 9, 5]  // 修复：第3行应该是9，第4行应该是5
    let keyHeight: CGFloat = 45
    let keySpacing: CGFloat = 6
    let rowSpacing: CGFloat = 8
    
    let layout: [[String]] = [
        ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
        ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
        ["⇧", "Z", "X", "C", "V", "B", "N", "M", "⌫"],
        ["123", "🌐", "Space", "Return", "😀"]
    ]
}

// MARK: - Chinese T9 Layout
class ChineseLayoutSpec: KeyboardLayoutSpec {
    let rows = 5
    let keysPerRow = [3, 3, 3, 3, 3]  // T9键盘：3x3数字键 + 功能键
    let keyHeight: CGFloat = 45
    let keySpacing: CGFloat = 6
    let rowSpacing: CGFloat = 8
    
    let layout: [[String]] = [
        ["1", "2", "3"],           // 1(.), 2(ABC), 3(DEF)
        ["4", "5", "6"],           // 4(GHI), 5(JKL), 6(MNO)
        ["7", "8", "9"],           // 7(PQRS), 8(TUV), 9(WXYZ)
        ["*", "0", "#"],           // *, 0(空格), #
        ["Candidates", "Delete", "Confirm"]    // 候选词显示、删除、确定
    ]
    
    // T9键盘数字键对应的字母映射
    let t9LetterMapping: [String: String] = [
        "1": ".",
        "2": "ABC",
        "3": "DEF", 
        "4": "GHI",
        "5": "JKL",
        "6": "MNO",
        "7": "PQRS",
        "8": "TUV",
        "9": "WXYZ",
        "0": "Space",
        "*": "*",
        "#": "#"
    ]
}

// MARK: - Number Layout (优化后的数字键盘)
class NumberLayoutSpec: KeyboardLayoutSpec {
    let rows = 4
    let keysPerRow = [3, 3, 3, 3]  // 3x4布局，按钮更大更易点击
    let keyHeight: CGFloat = 50      // 稍微增加高度，让数字按钮更易点击
    let keySpacing: CGFloat = 8      // 增加间距
    let rowSpacing: CGFloat = 10     // 增加行间距
    
    let layout: [[String]] = [
        ["1", "2", "3"],             // 第一行：1, 2, 3
        ["4", "5", "6"],             // 第二行：4, 5, 6
        ["7", "8", "9"],             // 第三行：7, 8, 9
        ["Symbols", "0", "⌫"]            // 第四行：符号、0、删除
    ]
}

// MARK: - Symbol Layout (符号键盘)
class SymbolLayoutSpec: KeyboardLayoutSpec {
    let rows = 4
    let keysPerRow = [10, 10, 10, 6]  // 保持原有的符号布局
    let keyHeight: CGFloat = 45
    let keySpacing: CGFloat = 6
    let rowSpacing: CGFloat = 8
    
    let layout: [[String]] = [
        ["-", "/", ":", ";", "(", ")", "$", "&", "@", "\""],
        ["#", "=", "+", "[", "]", "{", "}", "\\", "|", "~"],
        ["_", "<", ">", "€", "£", "¥", "•", "°", "±", "×"],
        ["123", "🌐", "Space", "↵", "⌫", "😀"]
    ]
}

// MARK: - Emoji Layout
class EmojiLayoutSpec: KeyboardLayoutSpec {
    let rows = 4
    let keysPerRow = [8, 8, 8, 6]  // 这个是正确的
    let keyHeight: CGFloat = 45
    let keySpacing: CGFloat = 6
    let rowSpacing: CGFloat = 8
    
    let layout: [[String]] = [
        ["😀", "😂", "🥰", "😎", "🤔", "😭", "😡", "🤗"],
        ["❤️", "💔", "💕", "💖", "💗", "💘", "💝", "💞"],
        ["👍", "👎", "👌", "✌️", "🤞", "🤟", "🤘", "👆"],
        ["ABC", "🌐", "Space", "↵", "⌫", "😀"]
    ]
}
