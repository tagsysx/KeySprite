# KeySprite 键盘扩展

## 概述

KeySprite是一个基于AI模型的智能iOS输入法应用，能够根据用户输入内容自动推荐最合适的键盘布局。本项目包含完整的键盘扩展实现和主应用设置界面。

## 功能特性

### 🎯 核心功能
- **智能布局推荐**: 基于AI模型自动推荐最适合的键盘布局
- **多种布局支持**: QWERTY、中文、数字符号、Emoji等
- **上下文感知**: 考虑应用类型、输入框类型等因素
- **用户习惯学习**: AI会学习您的使用模式，提供更准确的推荐

### 🎨 用户体验
- **现代化UI设计**: 采用iOS设计规范，美观易用
- **触觉反馈**: 支持按键触觉反馈
- **声音反馈**: 可选的按键声音
- **流畅动画**: 平滑的布局切换和按键动画

### ⚙️ 设置选项
- **键盘外观**: 可调节键盘高度
- **反馈设置**: 触觉和声音反馈开关
- **AI设置**: AI功能开关、学习模式、预测频率
- **布局设置**: 默认布局、自动切换、切换阈值

## 项目结构

```
KeySpirte/
├── KeySpirte/                    # 主应用
│   ├── ContentView.swift         # 主界面
│   ├── KeySpirteApp.swift        # 应用入口
│   └── Item.swift               # 数据模型
├── KeySpirteKeyboard/            # 键盘扩展
│   ├── KeyboardViewController.swift  # 键盘主控制器
│   ├── KeyboardView.swift           # 键盘视图
│   ├── KeyboardKeyView.swift        # 按键视图
│   ├── Models.swift                 # 数据模型
│   ├── KeyboardLayoutSpecs.swift    # 布局规格
│   ├── KeyboardLayoutManager.swift  # 布局管理器
│   ├── AIPredictor.swift            # AI预测器
│   ├── InputEngine.swift            # 输入引擎
│   ├── Info.plist                   # 扩展配置
│   └── MainInterface.storyboard    # 主界面故事板
└── README.md                     # 项目说明
```

## 安装配置

### 1. 项目设置

1. 在Xcode中打开项目
2. 确保项目支持iOS 17.0+
3. 检查Bundle Identifier设置

### 2. 添加键盘扩展Target

1. 在Xcode中选择项目
2. 点击"+"按钮添加新的Target
3. 选择"Custom Keyboard Extension"
4. 配置扩展的Bundle Identifier（建议在主应用ID后加".keyboard"）

### 3. 配置键盘扩展

1. 在扩展的Info.plist中确保以下设置：
   - `NSExtensionPointIdentifier`: `com.apple.keyboard-service`
   - `NSExtensionPrincipalClass`: 指向`KeyboardViewController`
   - `RequestsOpenAccess`: `true`（启用完全访问）

2. 在扩展的Capabilities中启用：
   - App Groups（如果需要数据共享）
   - Keychain Sharing（如果需要安全存储）

### 4. 编译和运行

1. 选择正确的Target
2. 编译项目
3. 在模拟器或真机上运行

## 使用方法

### 1. 启用键盘

1. 在iOS设备上打开"设置"应用
2. 导航到"通用" > "键盘" > "键盘"
3. 点击"添加新键盘"
4. 选择"KeySprite"
5. 启用"允许完全访问"以使用AI功能

### 2. 切换键盘

1. 在任何文本输入框中点击
2. 长按键盘上的地球图标
3. 选择"KeySprite"键盘

### 3. 使用AI推荐

1. 开始输入文本
2. AI会自动分析输入内容
3. 推荐最适合的键盘布局
4. 可以接受或拒绝推荐

## 技术架构

### 核心组件

- **KeyboardViewController**: 键盘扩展的主控制器
- **KeyboardView**: 键盘UI的主要视图
- **KeyboardLayoutManager**: 管理不同布局之间的切换
- **AIPredictor**: AI模型推理和布局推荐
- **InputEngine**: 处理用户输入和上下文管理

### AI模型集成

- 使用Core ML框架进行本地AI推理
- 特征提取：文本特征、上下文特征、用户特征
- 模型输出：布局概率分布
- 缓存机制：避免重复计算

### 数据流

```
用户输入 → InputEngine → 特征提取 → AI推理 → 布局推荐 → 布局切换
    ↓
用户反馈 → 模型更新 → 改进推荐
```

## 开发说明

### 添加新布局

1. 在`KeyboardLayout`枚举中添加新类型
2. 创建对应的`KeyboardLayoutSpec`类
3. 在`KeyboardView`的`getLayoutSpec`方法中添加case
4. 更新布局管理器的推荐逻辑

### 自定义AI模型

1. 准备Core ML模型文件（.mlmodel）
2. 在`AIPredictor`中加载模型
3. 调整特征提取逻辑
4. 更新结果处理逻辑

### 性能优化

- 使用缓存避免重复计算
- 后台队列处理AI推理
- 优化UI更新频率
- 内存使用监控

## 测试

### 单元测试

```bash
# 运行所有测试
xcodebuild test -scheme KeySpirte -destination 'platform=iOS Simulator,name=iPhone 15'

# 运行特定测试
xcodebuild test -scheme KeySpirte -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:KeySpirteTests/KeyboardLayoutManagerTests
```

### 集成测试

1. 在真机上测试键盘扩展
2. 测试不同应用的兼容性
3. 验证AI推荐功能
4. 测试布局切换功能

## 发布

### App Store发布

1. 配置正确的Bundle Identifier
2. 设置版本号和构建号
3. 准备应用截图和描述
4. 提交审核

### 注意事项

- 确保键盘扩展遵循Apple的指导原则
- 测试在不同iOS版本上的兼容性
- 验证隐私政策和数据使用说明
- 准备用户支持文档

## 故障排除

### 常见问题

1. **键盘不显示**
   - 检查是否正确添加了键盘扩展
   - 验证Info.plist配置
   - 确保启用了"允许完全访问"

2. **AI推荐不工作**
   - 检查Core ML模型是否正确加载
   - 验证特征提取逻辑
   - 查看控制台错误信息

3. **布局切换失败**
   - 检查布局规格配置
   - 验证布局管理器逻辑
   - 确保UI更新在主线程

### 调试技巧

- 使用Xcode的调试器
- 添加详细的日志输出
- 使用Instruments进行性能分析
- 在不同设备上测试

## 贡献指南

1. Fork项目
2. 创建功能分支
3. 提交更改
4. 创建Pull Request

## 许可证

本项目采用MIT许可证。详见LICENSE文件。

## 联系方式

- 项目主页: https://github.com/yourusername/KeySprite
- 问题反馈: https://github.com/yourusername/KeySprite/issues
- 邮箱: support@keysprite.com

---

**注意**: 这是一个开发中的项目，某些功能可能尚未完全实现。请参考开发计划了解当前进度。
