# KeySprite - AI驱动的智能输入法

一个基于AI模型的智能iOS输入法应用，能够根据用户输入内容自动推荐最合适的键盘布局。

## 🚀 功能特性

- **多语言支持**: 英文、中文、数字、符号、Emoji
- **AI智能推荐**: 基于预训练模型自动推荐最合适的键盘布局
- **自适应布局**: 根据输入内容动态调整键盘显示
- **个性化体验**: 学习用户习惯，提供个性化推荐
- **高性能**: 本地AI推理，快速响应

## 🏗️ 技术架构

- **开发语言**: Swift 5.0+
- **iOS版本**: iOS 17.0+
- **框架**: SwiftUI + UIKit
- **AI引擎**: Core ML + 预训练模型
- **数据存储**: Core Data + UserDefaults
- **架构模式**: MVVM + Coordinator

## 📱 支持的键盘布局

1. **英文QWERTY键盘**: 标准英文输入
2. **中文拼音键盘**: 智能拼音输入，支持手写
3. **数字键盘**: 数字和常用符号
4. **符号键盘**: 标点符号和特殊字符
5. **Emoji键盘**: 表情符号分类浏览

## 🔧 开发环境要求

- Xcode 15.0+
- iOS 17.0+ SDK
- macOS 14.0+
- Apple Developer Account

## 📦 安装和运行

### 1. 克隆项目
```bash
git clone https://github.com/yourusername/KeySprite.git
cd KeySprite
```

### 2. 打开项目
```bash
open KeySprite.xcodeproj
```

### 3. 配置开发者账号
- 在Xcode中登录你的Apple Developer账号
- 更新Bundle Identifier
- 配置开发证书和Provisioning Profile

### 4. 运行项目
- 选择目标设备（真机或模拟器）
- 按Cmd+R运行项目

## 🧪 测试

### 单元测试
```bash
# 运行所有测试
Cmd+U

# 运行特定测试
Cmd+Shift+U
```

### UI测试
```bash
# 运行UI测试
Product > Test > Test Plan
```

## 📊 项目结构

```
KeySprite/
├── KeySprite.xcodeproj/          # 主项目文件
├── KeySprite/                    # 主应用
├── KeySpriteKeyboard/            # 键盘扩展
├── Shared/                       # 共享代码
├── Resources/                    # 资源文件
├── Tests/                        # 测试文件
└── Documentation/                # 项目文档
```

## 🚀 开发计划

### 阶段1: 项目搭建 (1周)
- [x] 创建项目结构
- [ ] 配置键盘扩展
- [ ] 集成预训练模型
- [ ] 设置开发环境

### 阶段2: 基础框架 (2周)
- [ ] 实现键盘扩展基础
- [ ] 创建布局系统
- [ ] 集成AI预测服务
- [ ] 实现基本输入处理

### 阶段3: 核心功能 (4周)
- [ ] 英文键盘实现
- [ ] 中文输入支持
- [ ] 数字符号键盘
- [ ] Emoji键盘
- [ ] AI推荐集成

### 阶段4: 优化发布 (2周)
- [ ] 性能优化
- [ ] 用户体验优化
- [ ] 测试和调试
- [ ] App Store发布

## 🤝 贡献指南

1. Fork 项目
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 创建 Pull Request

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情

## 📞 联系方式

- 项目维护者: [Your Name]
- 邮箱: [your.email@example.com]
- 项目链接: [https://github.com/yourusername/KeySprite](https://github.com/yourusername/KeySprite)

## 🙏 致谢

感谢所有为这个项目做出贡献的开发者和设计师。

---

**注意**: 这是一个iOS输入法应用，需要在真机上测试键盘扩展功能。模拟器无法完全测试键盘扩展的所有功能。
