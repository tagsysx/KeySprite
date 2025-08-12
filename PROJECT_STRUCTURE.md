# KeySprite 项目目录结构

## 📁 完整项目结构

```
KeySprite/
├── 📄 README.md                           # 项目主要说明文档
├── 📄 DEVELOPMENT_PLAN.md                 # 详细开发计划
├── 📄 LICENSE                             # MIT许可证
├── 📄 .gitignore                          # Git忽略文件配置
├── 📄 PROJECT_STRUCTURE.md                # 项目结构说明（本文件）
│
├── 📁 Documentation/                      # 项目文档目录
│   ├── 📄 API_DOCUMENTATION.md           # API接口文档
│   ├── 📄 CORE_ML_INTEGRATION.md         # Core ML集成指南
│   ├── 📄 KEYBOARD_EXTENSION_GUIDE.md    # 键盘扩展开发指南
│   ├── 📄 TECHNICAL_SPECIFICATION.md     # 技术规格文档
│   └── 📄 GETTING_STARTED.md             # 快速开始指南
│
├── 📁 KeySprite.xcodeproj/               # Xcode项目文件
│   ├── 📁 project.xcworkspace/           # 工作空间配置
│   ├── 📁 xcuserdata/                    # 用户数据（已忽略）
│   └── 📄 project.pbxproj                # 项目配置文件
│
├── 📁 KeySprite/                          # 主应用Target
│   ├── 📄 AppDelegate.swift               # 应用委托
│   ├── 📄 SceneDelegate.swift             # 场景委托
│   ├── 📄 Info.plist                      # 主应用配置
│   │
│   ├── 📁 Views/                          # 主应用界面
│   │   ├── 📄 ContentView.swift           # 主内容视图
│   │   ├── 📄 SettingsView.swift          # 设置页面
│   │   ├── 📄 StatisticsView.swift        # 统计页面
│   │   ├── 📄 HelpView.swift              # 帮助页面
│   │   └── 📄 Components/                 # 可复用组件
│   │       ├── 📄 CustomButton.swift      # 自定义按钮
│   │       ├── 📄 CustomTextField.swift   # 自定义输入框
│   │       └── 📄 LoadingView.swift       # 加载视图
│   │
│   ├── 📁 Models/                         # 主应用数据模型
│   │   ├── 📄 UserSettings.swift          # 用户设置模型
│   │   ├── 📄 Statistics.swift            # 统计数据模型
│   │   └── 📄 AppConfiguration.swift      # 应用配置模型
│   │
│   ├── 📁 Controllers/                    # 主应用业务逻辑
│   │   ├── 📄 SettingsController.swift    # 设置控制器
│   │   ├── 📄 StatisticsController.swift  # 统计控制器
│   │   └── 📄 HelpController.swift        # 帮助控制器
│   │
│   ├── 📁 Resources/                      # 主应用资源
│   │   ├── 📁 Assets.xcassets/            # 图片和颜色资源
│   │   ├── 📄 Localizable.strings         # 本地化字符串
│   │   └── 📄 LaunchScreen.storyboard     # 启动屏幕
│   │
│   └── 📁 Supporting Files/               # 支持文件
│       ├── 📄 Entitlements.plist          # 权限配置
│       └── 📄 AppIcon.appiconset/         # 应用图标
│
├── 📁 KeySpriteKeyboard/                  # 键盘扩展Target
│   ├── 📄 KeyboardViewController.swift    # 键盘主控制器
│   ├── 📄 Info.plist                      # 键盘扩展配置
│   │
│   ├── 📁 Views/                          # 键盘界面组件
│   │   ├── 📄 KeyboardView.swift          # 主键盘视图
│   │   ├── 📄 CandidateView.swift         # 候选词视图
│   │   ├── 📄 LayoutIndicatorView.swift   # 布局指示器
│   │   ├── 📄 KeyPreviewView.swift        # 按键预览视图
│   │   └── 📄 EmojiPickerView.swift       # Emoji选择器
│   │
│   ├── 📁 InputEngine/                    # 输入处理引擎
│   │   ├── 📄 InputEngine.swift           # 输入引擎主类
│   │   ├── 📄 PinyinEngine.swift          # 拼音输入引擎
│   │   ├── 📄 HandwritingEngine.swift     # 手写识别引擎
│   │   └── 📄 InputProcessor.swift        # 输入处理器
│   │
│   ├── 📁 Layouts/                        # 键盘布局实现
│   │   ├── 📄 KeyboardLayout.swift        # 布局协议
│   │   ├── 📄 QWERTYLayout.swift          # QWERTY布局
│   │   ├── 📄 ChineseLayout.swift         # 中文布局
│   │   ├── 📄 NumberLayout.swift          # 数字布局
│   │   ├── 📄 SymbolLayout.swift          # 符号布局
│   │   └── 📄 EmojiLayout.swift           # Emoji布局
│   │
│   ├── 📁 AIPredictor/                    # AI预测引擎
│   │   ├── 📄 AIPredictor.swift           # AI预测器主类
│   │   ├── 📄 FeatureExtractor.swift      # 特征提取器
│   │   ├── 📄 InferenceEngine.swift       # 推理引擎
│   │   └── 📄 ResultProcessor.swift       # 结果处理器
│   │
│   ├── 📁 Resources/                      # 键盘扩展资源
│   │   ├── 📁 Assets.xcassets/            # 键盘相关图片
│   │   ├── 📄 Localizable.strings         # 键盘本地化
│   │   └── 📁 MLModels/                   # 机器学习模型
│   │       └── 📄 LayoutRecommendationModel.mlmodel  # 预训练模型
│   │
│   └── 📁 Supporting Files/               # 支持文件
│       ├── 📄 Entitlements.plist          # 键盘权限配置
│       └── 📄 MainInterface.storyboard    # 键盘主界面
│
├── 📁 Shared/                              # 共享代码模块
│   ├── 📁 Models/                          # 共享数据模型
│   │   ├── 📄 InputContext.swift           # 输入上下文模型
│   │   ├── 📄 LayoutRecommendation.swift  # 布局推荐模型
│   │   ├── 📄 UserFeedback.swift           # 用户反馈模型
│   │   ├── 📄 KeyboardKey.swift            # 键盘按键模型
│   │   └── 📄 AppTypes.swift               # 应用类型定义
│   │
│   ├── 📁 Utilities/                       # 工具类
│   │   ├── 📄 Constants.swift              # 常量定义
│   │   ├── 📄 Extensions.swift             # Swift扩展方法
│   │   ├── 📄 Helpers.swift                # 辅助函数
│   │   └── 📄 Validators.swift             # 验证工具
│   │
│   ├── 📁 Services/                        # 共享服务
│   │   ├── 📄 StorageService.swift         # 存储服务
│   │   ├── 📄 ConfigurationService.swift   # 配置服务
│   │   └── 📄 LoggingService.swift         # 日志服务
│   │
│   └── 📁 Protocols/                       # 协议定义
│       ├── 📄 KeyboardLayoutProtocol.swift # 键盘布局协议
│       ├── 📄 InputEngineProtocol.swift    # 输入引擎协议
│       └── 📄 AIPredictorProtocol.swift    # AI预测器协议
│
├── 📁 Tests/                               # 测试文件目录
│   ├── 📁 KeySpriteTests/                  # 主应用测试
│   │   ├── 📄 KeySpriteTests.swift         # 主应用测试类
│   │   ├── 📄 SettingsTests.swift          # 设置测试
│   │   ├── 📄 StatisticsTests.swift        # 统计测试
│   │   └── 📄 HelpTests.swift              # 帮助测试
│   │
│   ├── 📁 KeySpriteKeyboardTests/          # 键盘扩展测试
│   │   ├── 📄 KeyboardViewControllerTests.swift  # 键盘控制器测试
│   │   ├── 📄 LayoutManagerTests.swift     # 布局管理测试
│   │   ├── 📄 InputEngineTests.swift       # 输入引擎测试
│   │   └── 📄 AIPredictorTests.swift       # AI预测器测试
│   │
│   └── 📁 SharedTests/                     # 共享模块测试
│       ├── 📄 ModelsTests.swift            # 模型测试
│       ├── 📄 UtilitiesTests.swift         # 工具类测试
│       └── 📄 ServicesTests.swift          # 服务测试
│
├── 📁 UI Tests/                            # UI测试目录
│   ├── 📄 KeySpriteUITests.swift           # 主应用UI测试
│   └── 📄 KeyboardUITests.swift            # 键盘UI测试
│
├── 📁 Fastlane/                            # 自动化部署配置
│   ├── 📄 Fastfile                         # 自动化脚本
│   ├── 📄 Appfile                          # 应用配置
│   └── 📄 Deliverfile                      # 发布配置
│
├── 📁 Scripts/                             # 构建脚本
│   ├── 📄 build.sh                         # 构建脚本
│   ├── 📄 test.sh                          # 测试脚本
│   └── 📄 deploy.sh                        # 部署脚本
│
└── 📁 Resources/                            # 项目资源
    ├── 📁 Screenshots/                     # 应用截图
    ├── 📁 App Store/                       # App Store资源
    │   ├── 📄 app_store_icon.png           # App Store图标
    │   ├── 📄 app_store_screenshots/       # App Store截图
    │   └── 📄 app_store_description.txt    # App Store描述
    │
    └── 📁 Design/                          # 设计资源
        ├── 📁 Mockups/                     # 设计稿
        ├── 📁 Icons/                       # 图标源文件
        └── 📁 Assets/                      # 设计资源
```

## 🔧 关键目录说明

### 1. 主应用 (KeySprite/)
- **Views/**: 使用SwiftUI构建的用户界面
- **Models/**: 主应用的数据模型
- **Controllers/**: 业务逻辑控制器
- **Resources/**: 主应用的资源文件

### 2. 键盘扩展 (KeySpriteKeyboard/)
- **Views/**: 键盘界面的UI组件
- **InputEngine/**: 输入处理的核心引擎
- **Layouts/**: 不同键盘布局的实现
- **AIPredictor/**: AI智能推荐系统
- **MLModels/**: 预训练的机器学习模型

### 3. 共享模块 (Shared/)
- **Models/**: 在多个模块间共享的数据模型
- **Utilities/**: 通用工具类和扩展方法
- **Services/**: 共享的服务层
- **Protocols/**: 协议定义和接口规范

### 4. 测试文件 (Tests/)
- **单元测试**: 测试各个组件的功能
- **集成测试**: 测试模块间的协作
- **UI测试**: 测试用户界面交互

## 📱 文件命名规范

### 1. Swift文件命名
- **类文件**: 使用PascalCase，如 `KeyboardViewController.swift`
- **协议文件**: 以Protocol结尾，如 `KeyboardLayoutProtocol.swift`
- **扩展文件**: 以Extension结尾，如 `StringExtension.swift`

### 2. 资源文件命名
- **图片资源**: 使用小写字母和下划线，如 `keyboard_background.png`
- **本地化文件**: 使用标准命名，如 `Localizable.strings`
- **配置文件**: 使用标准命名，如 `Info.plist`

### 3. 目录命名
- **功能目录**: 使用PascalCase，如 `Views/`, `Models/`
- **资源目录**: 使用小写字母，如 `resources/`, `assets/`
- **测试目录**: 使用Tests后缀，如 `KeySpriteTests/`

## 🚀 开发工作流

### 1. 新功能开发
```bash
# 1. 在相应目录下创建新文件
# 2. 遵循命名规范
# 3. 添加到正确的target
# 4. 编写对应的测试
```

### 2. 文件组织
```bash
# 1. 按功能模块组织文件
# 2. 相关文件放在同一目录
# 3. 共享代码放在Shared目录
# 4. 保持目录结构清晰
```

### 3. 资源管理
```bash
# 1. 图片资源放在Assets.xcassets
# 2. 本地化文件统一管理
# 3. 配置文件放在对应target
# 4. 第三方资源放在Resources目录
```

## 📋 注意事项

### 1. Target配置
- 确保文件添加到正确的target
- 主应用和键盘扩展的配置要分开
- 共享代码要添加到多个target

### 2. 依赖管理
- 使用Swift Package Manager管理依赖
- 避免循环依赖
- 保持模块间的松耦合

### 3. 版本控制
- 遵循Git工作流
- 提交信息要清晰明确
- 定期同步远程代码

---

这个项目结构为KeySprite提供了清晰的组织架构，便于团队协作开发和维护。每个目录都有明确的职责，遵循iOS开发的最佳实践。
