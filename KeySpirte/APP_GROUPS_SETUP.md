# App Groups 配置说明

## 📋 配置概述

本文档说明了如何在KeySprite项目中配置App Groups，以实现主应用和键盘扩展之间的数据共享。

## 🔧 已完成的配置

### 1. Entitlements文件

已创建以下entitlements文件：

- **主应用**: `KeySpirte/KeySpirte.entitlements`
- **键盘扩展**: `KeySpirteKeyboard/KeySpirteKeyboard.entitlements`

两个文件都包含相同的App Group标识符：`group.org.tagsys.KeySpirte`

### 2. 项目配置

已在项目配置中添加：

- `CODE_SIGN_ENTITLEMENTS` 引用
- `ENABLE_BITCODE = NO` 设置
- App Groups capability配置

### 3. 数据共享管理器

已创建 `SharedDataManager.swift` 类，提供：

- 用户偏好设置管理
- 键盘配置管理
- 输入历史记录
- 应用状态跟踪

## 🚀 使用方法

### 在主应用中使用

```swift
import Foundation

// 保存用户设置
SharedDataManager.shared.saveKeyboardTheme("dark")
SharedDataManager.shared.saveAIPredictionEnabled(true)

// 获取用户设置
let theme = SharedDataManager.shared.getKeyboardTheme()
let aiEnabled = SharedDataManager.shared.getAIPredictionEnabled()
```

### 在键盘扩展中使用

```swift
import Foundation

// 获取用户设置
let theme = SharedDataManager.shared.getKeyboardTheme()
let layout = SharedDataManager.shared.getKeyboardLayout()

// 保存用户输入历史
SharedDataManager.shared.addToInputHistory("用户输入的文字")
```

## 🔍 验证配置

### 1. 检查Entitlements文件

确保以下文件存在且内容正确：

- `KeySpirte/KeySpirte.entitlements`
- `KeySpirteKeyboard/KeySpirteKeyboard.entitlements`

### 2. 检查项目设置

在Xcode中：

1. 选择项目根节点
2. 选择主应用Target
3. 在"Signing & Capabilities"中：
   - 确保"App Groups"已添加
   - 确保包含 `group.org.tagsys.KeySpirte`

4. 选择键盘扩展Target
5. 在"Signing & Capabilities"中：
   - 确保"App Groups"已添加
   - 确保包含 `group.org.tagsys.KeySpirte`

### 3. 检查构建设置

确保以下设置已配置：

- `ENABLE_BITCODE = NO`
- `CODE_SIGN_ENTITLEMENTS` 指向正确的entitlements文件

## ⚠️ 注意事项

### 1. Bundle Identifier

确保App Group标识符与你的Bundle Identifier匹配：

- 当前配置：`group.org.tagsys.KeySpirte`
- 如果你的Bundle ID不同，需要相应修改

### 2. 开发者账号

确保你的开发者账号支持App Groups功能：

- 个人开发者账号：支持
- 企业开发者账号：支持
- 免费开发者账号：不支持

### 3. 真机测试

App Groups功能需要在真机上测试：

- 模拟器可能无法正确测试App Groups
- 确保设备已信任开发者证书

## 🧪 测试数据共享

### 1. 在主应用中设置数据

```swift
// 在ContentView或其他地方
Button("设置键盘主题") {
    SharedDataManager.shared.saveKeyboardTheme("dark")
    SharedDataManager.shared.saveAIPredictionEnabled(true)
}
```

### 2. 在键盘扩展中读取数据

```swift
// 在KeyboardViewController中
let theme = SharedDataManager.shared.getKeyboardTheme()
let aiEnabled = SharedDataManager.shared.getAIPredictionEnabled()

print("当前主题: \(theme)")
print("AI预测: \(aiEnabled)")
```

### 3. 验证数据同步

1. 在主应用中修改设置
2. 切换到键盘扩展
3. 检查设置是否同步

## 🔧 故障排除

### 1. App Group不可用

**症状**: `SharedDataManager.shared.isAppGroupAvailable` 返回 `false`

**解决方案**:
1. 检查entitlements文件配置
2. 检查项目Capabilities设置
3. 重新构建项目
4. 在真机上测试

### 2. 数据不同步

**症状**: 主应用和键盘扩展的数据不一致

**解决方案**:
1. 检查App Group标识符是否一致
2. 确保两个Target都正确配置
3. 检查代码签名设置
4. 重新安装应用

### 3. 构建错误

**症状**: 构建时出现entitlements相关错误

**解决方案**:
1. 检查entitlements文件路径
2. 确保文件包含在正确的Target中
3. 清理项目并重新构建

## 📚 相关资源

- [App Groups Programming Guide](https://developer.apple.com/library/archive/documentation/Miscellaneous/Reference/EntitlementKeyReference/Chapters/EnablingAppSandbox.html#//apple_ref/doc/uid/TP40011195-CH4-SW19)
- [Custom Keyboard Extension](https://developer.apple.com/documentation/inputmethodkit)
- [UserDefaults](https://developer.apple.com/documentation/foundation/userdefaults)

## 📝 更新日志

| 版本 | 日期 | 更新内容 |
|------|------|----------|
| 1.0.0 | 2024-01-08 | 初始App Groups配置说明 |

---

**注意**: 本配置说明会随着项目的发展而更新。请定期查看最新版本。
