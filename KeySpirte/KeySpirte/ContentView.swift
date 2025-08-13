//
//  ContentView.swift
//  KeySpirte
//
//  Created by Lei Yang on 12/8/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    var body: some View {
        NavigationView {
            List {
                Section("键盘设置") {
                    NavigationLink(destination: KeyboardSettingsView()) {
                        Label("键盘配置", systemImage: "keyboard")
                    }
                    
                    NavigationLink(destination: LayoutSettingsView()) {
                        Label("布局设置", systemImage: "grid")
                    }
                    
                    NavigationLink(destination: AISettingsView()) {
                        Label("AI设置", systemImage: "brain.head.profile")
                    }
                }
                
                Section("使用统计") {
                    NavigationLink(destination: UsageStatisticsView()) {
                        Label("使用统计", systemImage: "chart.bar")
                    }
                    
                    NavigationLink(destination: LayoutUsageView()) {
                        Label("布局使用", systemImage: "chart.pie")
                    }
                }
                
                Section("帮助与支持") {
                    NavigationLink(destination: HelpView()) {
                        Label("使用帮助", systemImage: "questionmark.circle")
                    }
                    
                    NavigationLink(destination: AboutView()) {
                        Label("关于应用", systemImage: "info.circle")
                    }
                }
            }
            .navigationTitle("KeySprite")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: openSystemSettings) {
                        Label("系统设置", systemImage: "gear")
                    }
                }
            }
        }
    }
    
    private func openSystemSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Keyboard Settings View
struct KeyboardSettingsView: View {
    @AppStorage("keyboardHeight") private var keyboardHeight: Double = 250
    @AppStorage("keyboardSoundEnabled") private var soundEnabled = true
    @AppStorage("keyboardHapticEnabled") private var hapticEnabled = true
    
    var body: some View {
        Form {
            Section("键盘外观") {
                VStack(alignment: .leading) {
                    Text("键盘高度")
                    Slider(value: $keyboardHeight, in: 200...350, step: 10)
                    Text("\(Int(keyboardHeight)) 点")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Section("反馈设置") {
                Toggle("按键声音", isOn: $soundEnabled)
                Toggle("触觉反馈", isOn: $hapticEnabled)
            }
            
            Section("使用说明") {
                Text("要使用KeySprite键盘，请前往：")
                Text("设置 > 通用 > 键盘 > 键盘 > 添加新键盘")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("键盘设置")
    }
}

// MARK: - Layout Settings View
struct LayoutSettingsView: View {
    @AppStorage("defaultLayout") private var defaultLayout = "QWERTY"
    @AppStorage("autoSwitchEnabled") private var autoSwitchEnabled = true
    @AppStorage("switchThreshold") private var switchThreshold: Double = 0.7
    
    let availableLayouts = ["QWERTY", "Chinese", "Number", "Symbol", "Emoji"]
    
    var body: some View {
        Form {
            Section("默认布局") {
                Picker("默认布局", selection: $defaultLayout) {
                    ForEach(availableLayouts, id: \.self) { layout in
                        Text(layout).tag(layout)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            
            Section("智能切换") {
                Toggle("启用自动切换", isOn: $autoSwitchEnabled)
                
                if autoSwitchEnabled {
                    VStack(alignment: .leading) {
                        Text("切换阈值")
                        Slider(value: $switchThreshold, in: 0.5...0.9, step: 0.1)
                        Text("\(switchThreshold, specifier: "%.1f")")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Section("布局顺序") {
                ForEach(availableLayouts, id: \.self) { layout in
                    HStack {
                        Text(layout)
                        Spacer()
                        Image(systemName: "line.3.horizontal")
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .navigationTitle("布局设置")
    }
}

// MARK: - AI Settings View
struct AISettingsView: View {
    @AppStorage("aiEnabled") private var aiEnabled = true
    @AppStorage("aiLearningEnabled") private var learningEnabled = true
    @AppStorage("predictionFrequency") private var predictionFrequency = "Medium"
    
    let frequencies = ["Low", "Medium", "High"]
    
    var body: some View {
        Form {
            Section("AI功能") {
                Toggle("启用AI推荐", isOn: $aiEnabled)
                Toggle("启用学习模式", isOn: $learningEnabled)
            }
            
            Section("预测设置") {
                Picker("预测频率", selection: $predictionFrequency) {
                    ForEach(frequencies, id: \.self) { frequency in
                        Text(frequency).tag(frequency)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            Section("模型信息") {
                HStack {
                    Text("模型版本")
                    Spacer()
                    Text("1.0.0")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("模型大小")
                    Spacer()
                    Text("25.6 MB")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("最后更新")
                    Spacer()
                    Text("2024-01-08")
                        .foregroundColor(.secondary)
                }
            }
            
            Section("数据隐私") {
                Text("所有AI推理都在本地进行，不会上传您的输入内容")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("AI设置")
    }
}

// MARK: - Usage Statistics View
struct UsageStatisticsView: View {
    var body: some View {
        List {
            Section("今日统计") {
                StatRow(title: "输入字符", value: "1,234", icon: "textformat")
                StatRow(title: "按键次数", value: "2,567", icon: "keyboard")
                StatRow(title: "布局切换", value: "15", icon: "arrow.triangle.2.circlepath")
                StatRow(title: "使用时长", value: "45分钟", icon: "clock")
            }
            
            Section("本周统计") {
                StatRow(title: "输入字符", value: "8,901", icon: "textformat")
                StatRow(title: "按键次数", value: "18,234", icon: "keyboard")
                StatRow(title: "布局切换", value: "89", icon: "arrow.triangle.2.circlepath")
                StatRow(title: "使用时长", value: "3小时12分钟", icon: "clock")
            }
            
            Section("总体统计") {
                StatRow(title: "总输入字符", value: "156,789", icon: "textformat")
                StatRow(title: "总按键次数", value: "298,456", icon: "keyboard")
                StatRow(title: "总布局切换", value: "1,234", icon: "arrow.triangle.2.circlepath")
                StatRow(title: "总使用时长", value: "42小时", icon: "clock")
            }
        }
        .navigationTitle("使用统计")
    }
}

// MARK: - Layout Usage View
struct LayoutUsageView: View {
    var body: some View {
        List {
            Section("布局使用频率") {
                LayoutUsageRow(layout: "QWERTY", usage: 65, color: .blue)
                LayoutUsageRow(layout: "Chinese", usage: 20, color: .green)
                LayoutUsageRow(layout: "Number", usage: 10, color: .orange)
                LayoutUsageRow(layout: "Symbol", usage: 3, color: .purple)
                LayoutUsageRow(layout: "Emoji", usage: 2, color: .pink)
            }
            
            Section("AI推荐准确率") {
                HStack {
                    Text("总体准确率")
                    Spacer()
                    Text("87.5%")
                        .foregroundColor(.green)
                        .fontWeight(.semibold)
                }
                
                HStack {
                    Text("用户接受率")
                    Spacer()
                    Text("92.3%")
                        .foregroundColor(.blue)
                        .fontWeight(.semibold)
                }
            }
        }
        .navigationTitle("布局使用")
    }
}

// MARK: - Help View
struct HelpView: View {
    var body: some View {
        List {
            Section("基本使用") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("1. 前往系统设置 > 通用 > 键盘 > 键盘")
                    Text("2. 点击'添加新键盘'")
                    Text("3. 选择'KeySprite'")
                    Text("4. 允许完全访问以启用AI功能")
                }
                .font(.body)
            }
            
            Section("AI功能") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("• 智能布局推荐：根据输入内容自动推荐最适合的键盘布局")
                    Text("• 学习用户习惯：AI会学习您的使用模式，提供更准确的推荐")
                    Text("• 上下文感知：考虑应用类型、输入框类型等因素")
                }
                .font(.body)
            }
            
            Section("常见问题") {
                NavigationLink("键盘不显示", destination: Text("检查是否已添加键盘并设置为默认"))
                NavigationLink("AI推荐不准确", destination: Text("AI需要时间学习您的使用习惯"))
                NavigationLink("如何重置设置", destination: Text("在设置中可以重置所有设置"))
            }
        }
        .navigationTitle("使用帮助")
    }
}

// MARK: - About View
struct AboutView: View {
    var body: some View {
        List {
            Section {
                VStack(spacing: 16) {
                    Image(systemName: "keyboard")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    Text("KeySprite")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("智能AI键盘")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("版本 1.0.0")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
            
            Section("开发信息") {
                HStack {
                    Text("开发者")
                    Spacer()
                    Text("KeySprite Team")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("技术支持")
                    Spacer()
                    Text("support@keysprite.com")
                        .foregroundColor(.blue)
                }
                
                HStack {
                    Text("官方网站")
                    Spacer()
                    Text("www.keysprite.com")
                        .foregroundColor(.blue)
                }
            }
            
            Section("法律信息") {
                NavigationLink("隐私政策", destination: Text("隐私政策内容"))
                NavigationLink("使用条款", destination: Text("使用条款内容"))
                NavigationLink("开源许可", destination: Text("开源许可信息"))
            }
        }
        .navigationTitle("关于应用")
    }
}

// MARK: - Helper Views
struct StatRow: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            Text(title)
            
            Spacer()
            
            Text(value)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
    }
}

struct LayoutUsageRow: View {
    let layout: String
    let usage: Int
    let color: Color
    
    var body: some View {
        HStack {
            Text(layout)
            
            Spacer()
            
            HStack(spacing: 8) {
                Text("\(usage)%")
                    .fontWeight(.semibold)
                
                RoundedRectangle(cornerRadius: 2)
                    .fill(color)
                    .frame(width: 60, height: 8)
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
