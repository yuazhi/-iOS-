# 📝 Todu - 优雅的 iOS 待办事项应用

<div align="center">


[![iOS](https://img.shields.io/badge/iOS-15.0+-blue.svg)](https://developer.apple.com/ios/)
[![Swift](https://img.shields.io/badge/Swift-5.0+-orange.svg)](https://swift.org/)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-3.0+-green.svg)](https://developer.apple.com/xcode/swiftui/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

**简洁、优雅、高效的待办事项管理应用**

[功能特性](#功能特性) • [截图展示](#截图展示) • [安装说明](#安装说明) • [使用指南](#使用指南) • [技术栈](#技术栈) • [贡献指南](#贡献指南)

</div>

---

## ✨ 功能特性

### 🎯 核心功能
- **智能任务管理** - 轻松添加、编辑、删除待办事项
- **分类管理** - 支持工作、学习、生活、重要等多个分类
- **优先级设置** - 三级优先级系统，重要任务一目了然
- **进度追踪** - 实时显示完成进度，激励持续改进
- **智能排序** - 支持按日期、优先级、分类等多种排序方式

### 🔔 通知系统
- **本地通知** - 及时提醒，不错过重要任务
- **自定义提醒时间** - 灵活设置提醒提前时间
- **前台通知** - 应用运行时也能收到通知提醒

### 🎨 界面设计
- **现代化 UI** - 采用 SwiftUI 构建，界面简洁美观
- **深色模式** - 支持系统主题自动切换和手动切换
- **响应式设计** - 完美适配各种 iOS 设备
- **流畅动画** - 丰富的交互动画，提升用户体验

### ⚙️ 个性化设置
- **主题定制** - 自定义主题色彩
- **显示选项** - 可控制已完成任务的显示
- **通知开关** - 灵活控制通知功能
- **数据持久化** - 本地存储，数据安全可靠

## 📱 截图展示

<div align="center">

### 主界面
![主界面](https://cdn.rjjr.cn/assets/Simulator%20Screenshot%20-%20iPhone%2016%20Pro%20-%202025-06-17%20at%2022.38.19.png)

### 添加任务
![添加任务](https://cdn.rjjr.cn/assets/Simulator%20Screenshot%20-%20iPhone%2016%20Pro%20-%202025-06-17%20at%2022.38.26.png)

### 任务详情
![任务详情](https://cdn.rjjr.cn/assets/%E6%88%AA%E5%B1%8F2025-06-17%2022.38.57.png)

### 设置界面
![设置界面](https://cdn.rjjr.cn/assets/Simulator%20Screenshot%20-%20iPhone%2016%20Pro%20-%202025-06-17%20at%2022.39.02.png)

### 深色模式
![深色模式](https://cdn.rjjr.cn/assets/%E6%88%AA%E5%B1%8F2025-06-17%2022.39.09.png)

</div>

## 🚀 安装说明

### 系统要求
- iOS 15.0 或更高版本
- Xcode 13.0 或更高版本
- Swift 5.0 或更高版本

### 安装步骤

1. **克隆项目**
   ```bash
   git clone https://github.com/your-username/todu.git
   cd todu
   ```

2. **打开项目**
   ```bash
   open todu.xcodeproj
   ```

3. **配置项目**
   - 在 Xcode 中选择你的开发者账号
   - 修改 Bundle Identifier
   - 配置签名证书

4. **运行项目**
   - 选择目标设备或模拟器
   - 点击运行按钮或使用快捷键 `Cmd + R`

### 从 App Store 安装
> 🚧 即将上线 App Store，敬请期待！

## 📖 使用指南

### 添加任务
1. 点击主界面底部的"添加新的待办事项"按钮
2. 输入任务标题和备注
3. 选择截止日期和分类
4. 设置优先级
5. 点击保存

### 管理任务
- **完成任务**: 点击任务前的圆圈
- **编辑任务**: 点击任务卡片进入编辑模式
- **删除任务**: 在编辑模式下点击删除按钮
- **分类筛选**: 使用顶部的分类选择器

### 设置通知
1. 进入设置界面
2. 开启通知功能
3. 设置提醒提前时间
4. 授权通知权限

## 🛠 技术栈

- **开发语言**: Swift 5.0+
- **UI 框架**: SwiftUI 3.0+
- **数据存储**: UserDefaults + AppStorage
- **通知系统**: UserNotifications
- **最低支持**: iOS 15.0+

### 项目结构
```
todu/
├── toduApp.swift          # 应用入口
├── ContentView.swift      # 主界面
├── TodoEditView.swift     # 任务编辑界面
├── SettingsView.swift     # 设置界面
├── TodoCategory.swift     # 任务分类定义
└── Assets.xcassets/       # 资源文件
```

## 🤝 贡献指南

我们欢迎所有形式的贡献！请查看以下指南：

### 如何贡献

1. **Fork 项目**
2. **创建功能分支**
   ```bash
   git checkout -b feature/AmazingFeature
   ```
3. **提交更改**
   ```bash
   git commit -m 'Add some AmazingFeature'
   ```
4. **推送到分支**
   ```bash
   git push origin feature/AmazingFeature
   ```
5. **创建 Pull Request**

### 贡献类型
- 🐛 Bug 修复
- ✨ 新功能开发
- 📝 文档改进
- 🎨 UI/UX 优化
- ⚡ 性能优化

### 开发规范
- 遵循 Swift 编码规范
- 添加适当的注释
- 确保代码通过编译
- 测试新功能

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 🙏 致谢

感谢所有为这个项目做出贡献的开发者！

---

<div align="center">

**如果这个项目对你有帮助，请给它一个 ⭐️**

Made with ❤️ by [鸢栀](https://github.com/your-username)

</div> 
