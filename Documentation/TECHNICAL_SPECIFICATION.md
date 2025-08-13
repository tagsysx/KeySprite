# KeySprite 技术规格文档

## 📱 项目概述

KeySprite是一个基于AI模型的智能iOS输入法应用，能够根据用户输入内容自动推荐最合适的键盘布局。本文档详细描述了项目的技术规格和实现细节。

## 🏗️ 系统架构

### 1. 整体架构

```
┌─────────────────────────────────────────────────────────────┐
│                    iOS System Layer                         │
├─────────────────────────────────────────────────────────────┤
│  Input Method Kit  │  Text Input Mode  │  Keyboard UI      │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                KeySprite App Layer                          │
├─────────────────────────────────────────────────────────────┤
│  Main App  │  Settings  │  Statistics  │  User Profile   │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                Keyboard Extension Layer                     │
├─────────────────────────────────────────────────────────────┤
│  Input Engine  │  Layout Manager  │  AI Predictor        │
├─────────────────────────────────────────────────────────────┤
│  QWERTY  │  Chinese  │  Number  │  Symbol  │  Emoji      │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    AI Model Layer                           │
├─────────────────────────────────────────────────────────────┤
│  Feature Extractor  │  Model Inference  │  Result Handler │
└─────────────────────────────────────────────────────────────┘
```

### 2. 模块划分

#### 2.1 主应用模块 (KeySprite)
- **功能**: 设置、统计、用户配置、帮助
- **技术**: SwiftUI + UIKit
- **架构**: MVVM

#### 2.2 键盘扩展模块 (KeySpriteKeyboard)
- **功能**: 输入处理、布局管理、AI推荐
- **技术**: UIKit + InputMethodKit
- **架构**: MVC

#### 2.3 共享模块 (Shared)
- **功能**: 数据模型、工具类、扩展方法
- **技术**: Swift Foundation
- **架构**: 工具类

#### 2.4 AI模块 (AI)
- **功能**: 模型管理、特征提取、推理预测
- **技术**: Core ML + Foundation
- **架构**: 服务层

## 🔧 技术规格

### 1. 开发环境

#### 1.1 系统要求
- **操作系统**: macOS 14.0+
- **开发工具**: Xcode 15.0+
- **iOS SDK**: iOS 17.0+
- **编程语言**: Swift 5.0+

#### 1.2 目标设备
- **最低版本**: iOS 17.0
- **推荐版本**: iOS 17.0+
- **设备类型**: iPhone (所有支持iOS 17的设备)
- **屏幕尺寸**: 支持所有iPhone屏幕尺寸

### 2. 核心技术

#### 2.1 框架和库
```swift
// 主要框架
import UIKit                    // 用户界面
import SwiftUI                  // 现代UI框架
import InputMethodKit          // 输入法扩展
import CoreML                  // 机器学习
import Foundation              // 基础功能
import CoreData                // 数据持久化

// 第三方库 (可选)
import SnapKit                 // 自动布局
import RxSwift                 // 响应式编程
import Alamofire               // 网络请求
```

#### 2.2 架构模式
- **主应用**: MVVM + Coordinator
- **键盘扩展**: MVC + Service Layer
- **AI模块**: Service + Repository Pattern

### 3. 数据模型

#### 3.1 核心数据结构

```swift
// 输入上下文
struct InputContext {
    let textBeforeCursor: String      // 光标前文本
    let textAfterCursor: String       // 光标后文本
    let currentWord: String           // 当前单词
    let appType: AppType              // 应用类型
    let inputFieldType: InputFieldType // 输入框类型
    let timeOfDay: TimeOfDay          // 时间特征
    let userActivity: UserActivity    // 用户活动
}

// 布局推荐
struct LayoutRecommendation {
    let recommendedLayout: KeyboardLayout  // 推荐布局
    let confidence: Float                 // 置信度
    let alternatives: [KeyboardLayout]    // 备选布局
    let reasoning: String                 // 推荐理由
}

// 用户反馈
struct UserFeedback {
    let recommendation: LayoutRecommendation  // 推荐结果
    let userAction: UserAction                // 用户行为
    let timestamp: Date                       // 时间戳
    let context: InputContext                 // 输入上下文
}
```

#### 3.2 枚举类型

```swift
// 键盘布局类型
enum KeyboardLayout: String, CaseIterable {
    case qwerty = "QWERTY"
    case chinese = "Chinese"
    case number = "Number"
    case symbol = "Symbol"
    case emoji = "Emoji"
}

// 按键类型
enum KeyType {
    case character      // 字符键
    case backspace     // 删除键
    case space         // 空格键
    case return        // 回车键
    case shift         // 大小写切换
    case layout        // 布局切换
    case emoji         // 表情键
}

// 应用类型
enum AppType {
    case messaging     // 消息应用
    case social        // 社交应用
    case productivity  // 生产力应用
    case browser       // 浏览器
    case other         // 其他
}

// 输入框类型
enum InputFieldType {
    case text          // 普通文本
    case email         // 邮箱
    case password      // 密码
    case search        // 搜索
    case url           // URL
}

// 时间特征
enum TimeOfDay {
    case morning       // 早晨 (6-12点)
    case afternoon     // 下午 (12-18点)
    case evening       // 晚上 (18-22点)
    case night         // 夜晚 (22-6点)
}

// 用户活动
enum UserActivity {
    case typing        // 输入中
    case editing       // 编辑中
    case searching     // 搜索中
    case browsing      // 浏览中
    case idle          // 空闲
}

// 用户行为
enum UserAction {
    case accepted      // 接受推荐
    case rejected      // 拒绝推荐
    case ignored       // 忽略推荐
}
```

### 4. AI模型集成

#### 4.1 模型规格
- **模型格式**: Core ML (.mlmodel)
- **输入特征**: 浮点数数组
- **输出格式**: 布局概率分布
- **模型大小**: < 50MB
- **推理时间**: < 100ms

#### 4.2 特征工程
```swift
// 特征向量结构
struct FeatureVector {
    // 文本特征 (10维)
    let textLength: Float              // 文本长度
    let englishCharCount: Float        // 英文字符数
    let chineseCharCount: Float        // 中文字符数
    let numberCount: Float             // 数字数量
    let symbolCount: Float             // 符号数量
    let wordCount: Float               // 单词数量
    let sentenceCount: Float           // 句子数量
    let avgWordLength: Float           // 平均单词长度
    let lastCharType: Float            // 最后一个字符类型
    let inputSpeed: Float              // 输入速度
    
    // 上下文特征 (8维)
    let appType: Float                 // 应用类型编码
    let inputFieldType: Float          // 输入框类型编码
    let timeOfDay: Float               // 时间特征编码
    let userActivity: Float            // 用户活动编码
    let previousLayout: Float          // 上一个布局编码
    let layoutSwitchCount: Float       // 布局切换次数
    let sessionDuration: Float         // 会话持续时间
    let deviceOrientation: Float       // 设备方向
    
    // 用户特征 (6维)
    let preferredLayout: Float         // 偏好布局编码
    let qwertyUsage: Float            // QWERTY使用频率
    let chineseUsage: Float            // 中文使用频率
    let numberUsage: Float             // 数字使用频率
    let symbolUsage: Float             // 符号使用频率
    let emojiUsage: Float              // Emoji使用频率
}
```

#### 4.3 推理流程
```swift
// AI推理流程
class AIInferencePipeline {
    
    // 1. 特征提取
    func extractFeatures(from input: String, context: InputContext) -> FeatureVector {
        let textFeatures = extractTextFeatures(input)
        let contextFeatures = extractContextFeatures(context)
        let userFeatures = extractUserFeatures()
        
        return FeatureVector(
            textFeatures: textFeatures,
            contextFeatures: contextFeatures,
            userFeatures: userFeatures
        )
    }
    
    // 2. 特征预处理
    func preprocessFeatures(_ features: FeatureVector) -> [Float] {
        // 特征标准化和归一化
        return normalizeFeatures(features.toArray())
    }
    
    // 3. 模型推理
    func runInference(features: [Float]) throws -> MLFeatureProvider {
        let modelInput = createModelInput(features: features)
        return try model.prediction(from: modelInput)
    }
    
    // 4. 结果处理
    func processResults(_ output: MLFeatureProvider) -> LayoutRecommendation {
        let probabilities = extractProbabilities(from: output)
        let recommendation = selectBestLayout(from: probabilities)
        return recommendation
    }
}
```

### 5. 键盘布局规格

#### 5.1 QWERTY布局
```swift
// QWERTY键盘布局规格
struct QWERTYLayoutSpec {
    static let rows = 4
    static let keysPerRow = [10, 9, 7, 6]  // 每行按键数
    static let keyHeight: CGFloat = 45
    static let keySpacing: CGFloat = 6
    static let rowSpacing: CGFloat = 8
    
    static let layout: [[String]] = [
        ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
        ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
        ["⇧", "Z", "X", "C", "V", "B", "N", "M", "⌫"],
        ["123", "🌐", "空格", "↵", "😀"]
    ]
}
```

#### 5.2 中文布局
```swift
// 中文键盘布局规格
struct ChineseLayoutSpec {
    static let rows = 5
    static let keysPerRow = [10, 9, 7, 6, 5]
    static let keyHeight: CGFloat = 45
    static let keySpacing: CGFloat = 6
    static let rowSpacing: CGFloat = 8
    
    static let layout: [[String]] = [
        ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
        ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
        ["⇧", "Z", "X", "C", "V", "B", "N", "M", "⌫"],
        ["123", "🌐", "空格", "↵", "😀"],
        ["候选词显示区域"]
    ]
}
```

#### 5.3 数字符号布局
```swift
// 数字符号键盘布局规格
struct NumberSymbolLayoutSpec {
    static let rows = 4
    static let keysPerRow = [10, 10, 10, 6]
    static let keyHeight: CGFloat = 45
    static let keySpacing: CGFloat = 6
    static let rowSpacing: CGFloat = 8
    
    static let layout: [[String]] = [
        ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
        ["-", "/", ":", ";", "(", ")", "$", "&", "@", "\""],
        ["#", "=", "+", "[", "]", "{", "}", "\\", "|", "~"],
        ["ABC", "🌐", "空格", "↵", "⌫", "😀"]
    ]
}
```

### 6. 性能规格

#### 6.1 响应时间
- **键盘显示**: < 200ms
- **按键响应**: < 50ms
- **布局切换**: < 200ms
- **AI推理**: < 100ms
- **候选词显示**: < 100ms

#### 6.2 内存使用
- **总内存占用**: < 100MB
- **AI模型内存**: < 50MB
- **UI缓存内存**: < 20MB
- **数据缓存内存**: < 10MB

#### 6.3 电池消耗
- **后台运行**: 最小化
- **AI推理频率**: 智能控制
- **网络请求**: 本地优先
- **CPU使用**: < 10% (平均)

### 7. 安全规格

#### 7.1 数据安全
- **本地存储**: 所有数据本地存储
- **网络传输**: 不传输用户输入内容
- **模型数据**: 预训练模型，不包含用户数据
- **隐私保护**: 遵循Apple隐私政策

#### 7.2 权限管理
- **键盘访问**: 用户主动启用
- **网络访问**: 仅用于模型更新
- **文件访问**: 仅访问应用沙盒
- **系统权限**: 最小权限原则

### 8. 兼容性规格

#### 8.1 iOS版本兼容
- **最低版本**: iOS 17.0
- **目标版本**: iOS 17.0+
- **未来版本**: 向前兼容

#### 8.2 设备兼容
- **iPhone**: 所有支持iOS 17的设备
- **屏幕尺寸**: 支持所有iPhone屏幕
- **分辨率**: 支持所有分辨率
- **方向**: 支持横竖屏切换

#### 8.3 应用兼容
- **系统应用**: 完全兼容
- **第三方应用**: 大部分兼容
- **特殊应用**: 部分功能受限

## 🔌 接口规格

### 1. 公共API

#### 1.1 键盘扩展接口
```swift
// 键盘扩展主接口
protocol KeyboardExtensionProtocol {
    func setupKeyboard()
    func updateLayout(_ layout: KeyboardLayout)
    func handleInput(_ input: String)
    func getCurrentContext() -> InputContext
}

// 布局管理接口
protocol LayoutManagerProtocol {
    func switchToLayout(_ layout: KeyboardLayout)
    func getCurrentLayout() -> KeyboardLayout
    func getRecommendedLayout() -> KeyboardLayout
}
```

#### 1.2 AI服务接口
```swift
// AI预测服务接口
protocol AIPredictorProtocol {
    func predictNextLayout(
        input: String,
        context: InputContext,
        completion: @escaping (Result<LayoutRecommendation, Error>) -> Void
    )
    
    func updateModel(with feedback: UserFeedback)
}

// 特征提取接口
protocol FeatureExtractorProtocol {
    func extractFeatures(from input: String, context: InputContext) -> [Float]
}
```

### 2. 数据接口

#### 2.1 本地存储
```swift
// 用户偏好存储
protocol UserPreferencesProtocol {
    func getValue<T>(for key: String) -> T?
    func setValue<T>(_ value: T, for key: String)
    func resetToDefaults()
}

// 输入历史存储
protocol InputHistoryProtocol {
    func saveInput(_ input: String)
    func getRecentInputs(limit: Int) -> [String]
    func clearHistory()
}
```

#### 2.2 配置管理
```swift
// 应用配置接口
protocol AppConfigurationProtocol {
    func getAppVersion() -> String
    func getBuildNumber() -> String
    func getMinimumiOSVersion() -> String
    func isAIEnabled() -> Bool
    func setAIEnabled(_ enabled: Bool)
}
```

## 🧪 测试规格

### 1. 测试类型

#### 1.1 单元测试
- **覆盖率**: > 80%
- **核心模块**: 100%覆盖
- **AI模块**: > 90%覆盖
- **UI模块**: > 70%覆盖

#### 1.2 集成测试
- **模块集成**: 所有模块
- **数据流**: 完整数据流
- **错误处理**: 异常情况
- **性能测试**: 关键路径

#### 1.3 UI测试
- **用户交互**: 所有交互
- **布局适配**: 不同屏幕
- **方向切换**: 横竖屏
- **无障碍**: 辅助功能

### 2. 测试环境

#### 2.1 开发环境
- **模拟器**: iOS 17.0+
- **真机**: 开发设备
- **工具**: Xcode测试框架

#### 2.2 测试环境
- **测试设备**: 多种iPhone型号
- **iOS版本**: 17.0, 17.1, 17.2
- **网络环境**: WiFi, 4G, 5G

#### 2.3 生产环境
- **用户反馈**: 真实用户数据
- **性能监控**: 应用性能
- **崩溃报告**: 错误统计

## 📊 质量指标

### 1. 代码质量
- **代码规范**: 遵循Swift规范
- **文档覆盖率**: > 90%
- **注释质量**: 清晰易懂
- **命名规范**: 语义化命名

### 2. 性能质量
- **启动时间**: < 2秒
- **内存泄漏**: 0个
- **CPU峰值**: < 30%
- **电池消耗**: 最小化

### 3. 用户体验
- **响应速度**: 流畅
- **界面美观**: 现代化设计
- **操作便捷**: 直观易用
- **错误处理**: 友好提示

## 📝 更新日志

| 版本 | 日期 | 更新内容 | 负责人 |
|------|------|----------|--------|
| 1.0.0 | 2024-01-XX | 初始技术规格 | 技术团队 |

---

**注意**: 本技术规格文档为项目开发的基础规范，将根据开发进度和需求变化进行调整。
