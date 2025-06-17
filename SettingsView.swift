import SwiftUI

struct SettingsView: View {
    @AppStorage("reminderHours") private var reminderHours: Double = 2.0
    @AppStorage("enableNotifications") private var enableNotifications: Bool = true
    @AppStorage("showCompletedTasks") private var showCompletedTasks: Bool = true
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("useSystemTheme") private var useSystemTheme = true
    @Environment(\.colorScheme) private var systemColorScheme
    @Environment(\.dismiss) private var dismiss
    
    private let themeColor = Color(red: 248/255, green: 174/255, blue: 175/255)
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("外观设置")) {
                    Toggle("跟随系统", isOn: $useSystemTheme)
                        .tint(themeColor)
                    
                    if !useSystemTheme {
                        Toggle("深色模式", isOn: $isDarkMode)
                            .tint(themeColor)
                    }
                }
                
                Section(header: Text("通知设置")) {
                    Toggle("启用通知提醒", isOn: $enableNotifications)
                        .tint(themeColor)
                    
                    if enableNotifications {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("提前提醒时间")
                                Spacer()
                                Text("\(Int(reminderHours))小时")
                                    .foregroundColor(.gray)
                            }
                            
                            Slider(value: $reminderHours, in: 1...24, step: 1)
                                .tint(themeColor)
                        }
                    }
                }
                
                Section(header: Text("显示设置")) {
                    Toggle("显示已完成的任务", isOn: $showCompletedTasks)
                        .tint(themeColor)
                }
                
                Section(header: Text("关于")) {
                    HStack {
                        Text("版本")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.gray)
                    }
                    
                    Link(destination: URL(string: "https://example.com/privacy")!) {
                        Text("隐私政策")
                    }
                    
                    Link(destination: URL(string: "https://example.com/terms")!) {
                        Text("使用条款")
                    }
                }
            }
            .navigationTitle("设置")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
        }
        .preferredColorScheme(useSystemTheme ? nil : (isDarkMode ? .dark : .light))
    }
} 