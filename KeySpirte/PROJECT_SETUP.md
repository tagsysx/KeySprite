# KeySprite 项目设置指南

## 🚀 快速开始

本指南将帮助您快速设置和运行KeySprite项目。

## 📋 前置要求

- **macOS**: 14.0+ (推荐最新版本)
- **Xcode**: 15.0+ (推荐最新版本)
- **iOS SDK**: iOS 17.0+
- **Swift**: 5.0+
- **设备**: iPhone (支持iOS 17的设备)

## 🔧 项目设置步骤

### 1. 克隆项目

```bash
git clone https://github.com/yourusername/KeySprite.git
cd KeySprite
```

### 2. 打开Xcode项目

```bash
open KeySpirte/KeySpirte.xcodeproj
```

### 3. 配置项目设置

#### 3.1 基本配置

1. 选择项目根节点
2. 在"General"标签页中：
   - 设置Bundle Identifier (例如: `com.yourcompany.KeySprite`)
   - 设置Display Name: `KeySprite`
   - 设置Deployment Target: `iOS 17.0`

#### 3.2 添加键盘扩展Target

1. 选择项目根节点
2. 点击"+"按钮添加新Target
3. 选择"Custom Keyboard Extension"
4. 配置扩展设置：
   - Product Name: `KeySpirteKeyboard`
   - Bundle Identifier: `com.yourcompany.KeySprite.keyboard`
   - Language: `Swift`
   - Project: `KeySpirte`

#### 3.3 配置键盘扩展

1. 选择新创建的键盘扩展Target
2. 在"General"标签页中：
   - 设置Display Name: `KeySprite`
   - 确保Deployment Target为`iOS 17.0`

3. 在"Signing & Capabilities"中：
   - 选择您的开发者账号
   - 启用"App Groups" (如果需要数据共享)
   - 启用"Keychain Sharing" (如果需要安全存储)

#### 3.4 配置Info.plist

确保键盘扩展的Info.plist包含以下配置：

```xml
<key>NSExtension</key>
<dict>
    <key>NSExtensionAttributes</key>
    <dict>
        <key>IsASCIICapable</key>
        <true/>
        <key>PrefersRightToLeft</key>
        <false/>
        <key>PrimaryLanguage</key>
        <string>en-US</string>
        <key>RequestsOpenAccess</key>
        <true/>
    </dict>
    <key>NSExtensionMainStoryboard</key>
    <string>MainInterface</string>
    <key>NSExtensionPointIdentifier</key>
    <string>com.apple.keyboard-service</string>
    <key>NSExtensionPrincipalClass</key>
    <string>$(PRODUCT_MODULE_NAME).KeyboardViewController</string>
</dict>
```

### 4. 配置代码签名

#### 4.1 主应用

1. 选择主应用Target
2. 在"Signing & Capabilities"中：
   - 选择您的开发者账号
   - 确保"Automatically manage signing"已启用

#### 4.2 键盘扩展

1. 选择键盘扩展Target
2. 在"Signing & Capabilities"中：
   - 选择相同的开发者账号
   - 确保"Automatically manage signing"已启用

### 5. 配置构建设置

#### 5.1 主应用

1. 选择主应用Target
2. 在"Build Settings"中搜索以下设置：
   - `PRODUCT_BUNDLE_IDENTIFIER`: 设置为主应用ID
   - `SWIFT_VERSION`: 确保为`5.0`

#### 5.2 键盘扩展

1. 选择键盘扩展Target
2. 在"Build Settings"中搜索以下设置：
   - `PRODUCT_BUNDLE_IDENTIFIER`: 设置为扩展ID
   - `SWIFT_VERSION`: 确保为`5.0`
   - `ENABLE_BITCODE`: 设置为`NO`

### 6. 添加依赖

#### 6.1 Core ML模型

1. 将您的Core ML模型文件(.mlmodel)添加到项目中
2. 确保模型文件包含在键盘扩展Target中
3. 在`AIPredictor.swift`中更新模型加载逻辑

#### 6.2 第三方库 (可选)

如果需要使用第三方库，可以通过Swift Package Manager添加：

1. 选择项目根节点
2. 在"Package Dependencies"标签页中点击"+"
3. 输入包的URL或搜索包名
4. 选择版本并添加到相应的Target

## 🧪 测试配置

### 1. 模拟器测试

1. 选择主应用Target
2. 选择iOS模拟器作为运行目标
3. 点击运行按钮

### 2. 真机测试

1. 将iOS设备连接到Mac
2. 在Xcode中选择您的设备
3. 确保设备已信任开发者证书
4. 点击运行按钮

### 3. 键盘扩展测试

1. 在真机上运行主应用
2. 前往"设置" > "通用" > "键盘" > "键盘"
3. 添加KeySprite键盘
4. 在任何文本输入框中测试键盘

## 🔍 常见问题解决

### 1. 编译错误

#### 错误: "Module 'KeySpirteKeyboard' not found"

**解决方案**:
1. 确保键盘扩展Target已正确创建
2. 检查Target Membership设置
3. 清理项目并重新构建

#### 错误: "Signing for 'KeySpirteKeyboard' requires a development team"

**解决方案**:
1. 选择键盘扩展Target
2. 在"Signing & Capabilities"中选择开发团队
3. 确保Bundle Identifier唯一

### 2. 运行时错误

#### 错误: "Keyboard extension not found"

**解决方案**:
1. 确保键盘扩展已正确安装
2. 检查Info.plist配置
3. 重新安装应用

#### 错误: "Request for full access denied"

**解决方案**:
1. 在设置中启用"允许完全访问"
2. 重新启动应用

### 3. 性能问题

#### 键盘响应慢

**解决方案**:
1. 检查AI推理是否在主线程执行
2. 优化特征提取算法
3. 使用缓存减少重复计算

#### 内存使用过高

**解决方案**:
1. 检查是否有内存泄漏
2. 优化图像和资源使用
3. 使用Instruments分析内存使用

## 📱 部署配置

### 1. App Store发布

1. 设置正确的版本号和构建号
2. 配置App Store Connect信息
3. 创建Archive
4. 上传到App Store Connect

### 2. 企业分发

1. 配置企业证书
2. 创建IPA文件
3. 使用企业分发工具部署

### 3. 测试分发

1. 使用TestFlight进行测试分发
2. 配置测试用户
3. 收集反馈并迭代

## 🔧 开发工具配置

### 1. Xcode设置

推荐在Xcode中启用以下设置：

- **Editor**: 启用"Show Line Numbers"
- **Text Editing**: 启用"Show Invisibles"
- **Source Control**: 启用"Enable Source Control"

### 2. 调试配置

在"Edit Scheme"中配置：

- **Run**: 启用"Allow running when built"
- **Test**: 启用"Allow testing when built"

### 3. 代码风格

项目使用以下代码风格：

- 使用SwiftLint进行代码规范检查
- 遵循Apple的Swift API设计指南
- 使用MARK注释组织代码

## 📚 学习资源

### 1. 官方文档

- [Custom Keyboard Extension](https://developer.apple.com/documentation/inputmethodkit)
- [Core ML Framework](https://developer.apple.com/documentation/coreml)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines)

### 2. 示例代码

- [Keyboard Extension Sample](https://developer.apple.com/documentation/inputmethodkit/creating_a_custom_keyboard_extension)
- [Core ML Examples](https://developer.apple.com/documentation/coreml/integrating_a_core_ml_model_into_your_app)

### 3. 社区资源

- [Apple Developer Forums](https://developer.apple.com/forums/)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/ios)
- [GitHub](https://github.com/topics/ios-keyboard-extension)

## 🆘 获取帮助

如果您遇到问题：

1. 查看本文档的常见问题部分
2. 检查项目的README文件
3. 在GitHub Issues中搜索类似问题
4. 创建新的Issue描述您的问题
5. 联系开发团队获取支持

## 📝 更新日志

| 版本 | 日期 | 更新内容 |
|------|------|----------|
| 1.0.0 | 2024-01-08 | 初始项目设置指南 |

---

**注意**: 本指南会随着项目的发展而更新。请定期查看最新版本。
