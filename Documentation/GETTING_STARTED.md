# KeySprite 快速开始指南

## 🚀 快速开始

欢迎使用KeySprite！这是一个基于AI模型的智能iOS输入法应用。本指南将帮助你快速上手开发。

## 📋 前置要求

### 1. 开发环境
- **macOS**: 14.0 或更高版本
- **Xcode**: 15.0 或更高版本
- **iOS SDK**: 17.0 或更高版本
- **Swift**: 5.0 或更高版本

### 2. 开发者账号
- **Apple Developer Account**: 付费开发者账号（用于真机测试和发布）
- **Provisioning Profile**: 配置开发证书

### 3. 设备要求
- **测试设备**: iPhone（支持iOS 17.0+）
- **模拟器**: 可用于基础功能测试，但键盘扩展功能有限

## 🔧 环境搭建

### 步骤1: 克隆项目

```bash
# 克隆项目到本地
git clone https://github.com/yourusername/KeySprite.git

# 进入项目目录
cd KeySprite

# 检查项目结构
ls -la
```

### 步骤2: 打开项目

```bash
# 使用Xcode打开项目
open KeySprite.xcodeproj
```

或者在Xcode中：
1. 选择 `File` > `Open...`
2. 选择 `KeySprite.xcodeproj` 文件
3. 点击 `Open`

### 步骤3: 配置开发者账号

1. 在Xcode中登录你的Apple Developer账号
2. 选择项目 `KeySprite`
3. 选择 `KeySprite` target
4. 在 `Signing & Capabilities` 标签页中：
   - 选择你的 `Team`
   - 确保 `Automatically manage signing` 已勾选
   - 检查 `Bundle Identifier` 是否唯一

5. 选择 `KeySpriteKeyboard` target
6. 重复上述配置步骤

### 步骤4: 配置Bundle Identifier

确保Bundle Identifier唯一：

```
主应用: com.yourcompany.keysprite
键盘扩展: com.yourcompany.keysprite.keyboard
```

## 🏗️ 项目结构

### 目录结构

```
KeySprite/
├── KeySprite.xcodeproj/          # 主项目文件
├── KeySprite/                    # 主应用
│   ├── AppDelegate.swift         # 应用委托
│   ├── SceneDelegate.swift       # 场景委托
│   ├── Views/                    # 主应用界面
│   ├── Models/                   # 数据模型
│   └── Controllers/              # 业务逻辑
├── KeySpriteKeyboard/            # 键盘扩展
│   ├── KeyboardViewController.swift  # 键盘主控制器
│   ├── Views/                    # 键盘界面
│   ├── InputEngine/              # 输入引擎
│   └── Layouts/                  # 键盘布局
├── Shared/                       # 共享代码
│   ├── Models/                   # 共享数据模型
│   ├── Utilities/                # 工具类
│   └── Extensions/               # 扩展方法
├── Resources/                    # 资源文件
│   ├── Assets.xcassets          # 图片资源
│   ├── Localizable.strings      # 本地化文件
│   └── Info.plist               # 配置文件
├── Tests/                        # 测试文件
│   ├── KeySpriteTests/           # 主应用测试
│   └── KeySpriteKeyboardTests/   # 键盘扩展测试
└── Documentation/                # 项目文档
    ├── README.md                 # 项目说明
    ├── DEVELOPMENT_PLAN.md       # 开发计划
    ├── API_DOCUMENTATION.md      # API文档
    ├── CORE_ML_INTEGRATION.md    # Core ML集成指南
    ├── KEYBOARD_EXTENSION_GUIDE.md # 键盘扩展指南
    ├── TECHNICAL_SPECIFICATION.md # 技术规格
    └── GETTING_STARTED.md        # 快速开始指南
```

### 关键文件说明

#### 主应用文件
- **AppDelegate.swift**: 应用生命周期管理
- **SceneDelegate.swift**: 界面场景管理
- **Views/**: 主应用的用户界面
- **Models/**: 数据模型定义
- **Controllers/**: 业务逻辑控制器

#### 键盘扩展文件
- **KeyboardViewController.swift**: 键盘扩展的主控制器
- **Views/**: 键盘界面组件
- **InputEngine/**: 输入处理引擎
- **Layouts/**: 不同键盘布局的实现

#### 共享文件
- **Models/**: 在多个模块间共享的数据模型
- **Utilities/**: 通用工具类
- **Extensions/**: Swift扩展方法

## 🚀 首次运行

### 步骤1: 选择目标设备

1. 在Xcode顶部选择目标设备
2. 推荐选择真机设备（键盘扩展在模拟器上功能有限）
3. 如果没有真机，可以选择iOS模拟器

### 步骤2: 构建项目

1. 按 `Cmd + B` 构建项目
2. 检查是否有编译错误
3. 解决所有编译问题

### 步骤3: 运行项目

1. 按 `Cmd + R` 运行项目
2. 如果是真机，需要信任开发者证书：
   - 在设备上：`设置` > `通用` > `VPN与设备管理`
   - 选择你的开发者证书
   - 点击 `信任`

### 步骤4: 启用键盘扩展

1. 在主应用中，进入 `设置` 页面
2. 点击 `启用键盘扩展`
3. 按照提示操作：
   - 进入 `设置` > `通用` > `键盘`
   - 点击 `添加新键盘`
   - 选择 `KeySprite`
   - 允许 `完全访问`

## 🔍 基础功能测试

### 1. 主应用测试

1. **启动测试**: 应用是否正常启动
2. **界面测试**: 各个页面是否正常显示
3. **设置测试**: 设置项是否可正常修改
4. **导航测试**: 页面间跳转是否正常

### 2. 键盘扩展测试

1. **键盘显示**: 在任意输入框中是否显示自定义键盘
2. **按键响应**: 按键是否正常响应
3. **布局切换**: 不同布局间切换是否正常
4. **输入功能**: 文本输入是否正常

### 3. AI功能测试

1. **模型加载**: AI模型是否正常加载
2. **特征提取**: 特征提取是否正常
3. **推理预测**: AI推荐是否正常工作
4. **结果处理**: 推荐结果是否正确显示

## 🐛 常见问题解决

### 1. 编译错误

#### 问题: 找不到某些文件
```bash
# 解决方案: 检查文件是否在正确的target中
# 在Xcode中右键点击文件，选择 "Show File Inspector"
# 确保在 "Target Membership" 中勾选了正确的target
```

#### 问题: 签名错误
```bash
# 解决方案: 检查签名配置
# 1. 确保开发者账号已登录
# 2. 检查Bundle Identifier是否唯一
# 3. 确保Provisioning Profile配置正确
```

### 2. 运行错误

#### 问题: 应用崩溃
```bash
# 解决方案: 检查控制台日志
# 1. 在Xcode中查看控制台输出
# 2. 检查是否有异常信息
# 3. 使用断点调试定位问题
```

#### 问题: 键盘不显示
```bash
# 解决方案: 检查键盘扩展配置
# 1. 确保键盘扩展已启用
# 2. 检查Info.plist配置
# 3. 验证Bundle Identifier设置
```

### 3. 功能问题

#### 问题: AI模型无法加载
```bash
# 解决方案: 检查模型文件
# 1. 确保.mlmodel文件已添加到项目中
# 2. 检查文件是否在正确的target中
# 3. 验证模型文件格式是否正确
```

#### 问题: 布局切换失败
```bash
# 解决方案: 检查布局管理器
# 1. 验证布局数据是否正确
# 2. 检查约束设置
# 3. 确保视图更新逻辑正确
```

## 📚 学习资源

### 1. 官方文档
- [iOS App Development](https://developer.apple.com/develop/)
- [Custom Keyboard Extension](https://developer.apple.com/documentation/inputmethodkit)
- [Core ML Framework](https://developer.apple.com/documentation/coreml)

### 2. 示例代码
- [Keyboard Extension Sample](https://developer.apple.com/documentation/inputmethodkit/building_a_custom_keyboard_extension)
- [Core ML Integration](https://developer.apple.com/documentation/coreml/integrating_a_core_ml_model_into_your_app)

### 3. 社区资源
- [Apple Developer Forums](https://developer.apple.com/forums/)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/ios)
- [GitHub](https://github.com/topics/ios-keyboard-extension)

## 🔄 开发流程

### 1. 日常开发流程

```bash
# 1. 拉取最新代码
git pull origin main

# 2. 创建功能分支
git checkout -b feature/your-feature-name

# 3. 开发功能
# ... 编写代码 ...

# 4. 测试功能
# 在真机上测试所有功能

# 5. 提交代码
git add .
git commit -m "feat: add your feature description"

# 6. 推送分支
git push origin feature/your-feature-name

# 7. 创建Pull Request
# 在GitHub上创建PR，等待代码审查
```

### 2. 测试流程

```bash
# 1. 单元测试
Cmd + U

# 2. 集成测试
# 在真机上测试完整流程

# 3. UI测试
# 测试用户界面交互

# 4. 性能测试
# 检查内存使用和响应时间
```

### 3. 发布流程

```bash
# 1. 版本更新
# 更新版本号和构建号

# 2. 构建发布版本
# Product > Archive

# 3. 上传到App Store Connect
# 通过Xcode上传

# 4. 提交审核
# 在App Store Connect中提交审核
```

## 📱 真机测试注意事项

### 1. 设备准备
- 确保设备已解锁
- 确保设备已连接到Mac
- 确保设备信任了开发者证书

### 2. 键盘扩展测试
- 键盘扩展只能在真机上完全测试
- 模拟器无法测试键盘扩展的所有功能
- 测试时需要启用键盘扩展

### 3. 性能测试
- 在真机上测试内存使用
- 测试电池消耗情况
- 检查应用响应速度

## 🎯 下一步

### 1. 熟悉代码结构
- 阅读主要类的实现
- 理解架构设计
- 熟悉数据流

### 2. 理解AI集成
- 阅读Core ML集成指南
- 了解特征提取逻辑
- 理解推理流程

### 3. 学习键盘扩展
- 阅读键盘扩展指南
- 理解布局管理
- 熟悉输入处理

### 4. 开始开发
- 选择一个小功能开始
- 遵循开发计划
- 保持代码质量

## 📞 获取帮助

### 1. 项目内帮助
- 查看项目文档
- 阅读代码注释
- 查看测试用例

### 2. 外部资源
- 搜索Stack Overflow
- 查看Apple开发者文档
- 参与开发者社区讨论

### 3. 项目维护者
- 创建Issue报告问题
- 提交Pull Request贡献代码
- 参与项目讨论

---

**恭喜！** 你已经成功搭建了KeySprite开发环境。现在可以开始你的开发之旅了！

如果在过程中遇到任何问题，请参考本文档的常见问题解决部分，或者查看项目中的其他文档。
