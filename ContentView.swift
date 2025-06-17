//
//  ContentView.swift
//  todu
//
//  Created by 鸢栀 on 2025/1/9.
//

import SwiftUI
import UserNotifications

struct TodoItem: Identifiable {
    let id = UUID()
    var title: String
    var date: Date
    var isCompleted: Bool = false
    var notificationId: String
    var category: TodoCategory = .general
    var note: String = ""  // 添加备注
    var priority: Int = 0  // 优先级 0-2
    
    init(title: String, date: Date, isCompleted: Bool = false) {
        self.title = title
        self.date = date
        self.isCompleted = isCompleted
        self.notificationId = UUID().uuidString
    }
}

struct RoundedBackgroundStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct ContentView: View {
    @AppStorage("reminderHours") private var reminderHours: Double = 2.0
    @AppStorage("enableNotifications") private var enableNotifications: Bool = true
    @AppStorage("showCompletedTasks") private var showCompletedTasks: Bool = true
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("useSystemTheme") private var useSystemTheme = true
    @Environment(\.colorScheme) private var systemColorScheme
    @State private var showingSettings = false
    @State private var todoItems: [TodoItem] = []
    @State private var newTodoTitle: String = ""
    @AppStorage("sortBy") private var sortBy = "date" // date, priority, category
    @AppStorage("selectedCategory") private var selectedCategory = "all"
    @State private var showingNewTodo = false
    @State private var newTodoItem = TodoItem(title: "", date: Date())
    @State private var isAddingNewTodo = false  // 添加新的状态
    @State private var editingItem: TodoItem?
    
    private let themeColor = Color(red: 248/255, green: 174/255, blue: 175/255) // #f8aeaf
    
    // 添加计算属性来获取进度
    private var progressValue: Double {
        guard !todoItems.isEmpty else { return 0 }
        let completedCount = todoItems.filter { $0.isCompleted }.count
        return Double(completedCount) / Double(todoItems.count)
    }
    
    // 计算当前是否是深色模式
    private var isCurrentlyDark: Bool {
        useSystemTheme ? (systemColorScheme == .dark) : isDarkMode
    }
    
    // 修改颜色方案
    private var backgroundColor: Color {
        isCurrentlyDark ? Color(.systemBackground) : Color(.systemGray6)
    }
    
    private var cardBackgroundColor: Color {
        isCurrentlyDark ? Color(.secondarySystemBackground) : Color(.systemBackground)
    }
    
    private var secondaryTextColor: Color {
        isCurrentlyDark ? Color(.systemGray) : Color(.systemGray2)
    }
    
    // 在 init 中请求通知权限
    init() {
        requestNotificationPermission()
    }
    
    // 添加排序逻辑
    private var sortedAndFilteredItems: [TodoItem] {
        var items = filteredTodoItems
        
        // 先按分类筛选
        if selectedCategory != "all" {
            items = items.filter { $0.category.rawValue == selectedCategory }
        }
        
        // 再排序
        switch sortBy {
        case "date":
            items.sort { $0.date < $1.date }
        case "priority":
            items.sort { $0.priority > $1.priority }
        case "category":
            items.sort { $0.category.rawValue < $1.category.rawValue }
        default:
            break
        }
        
        return items
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor  // 使用动态背景色
                    .ignoresSafeArea()
                
                VStack(spacing: 15) {
                    // 修改输入区域
                    HStack(spacing: 12) {
                        Button(action: {
                            newTodoItem = TodoItem(title: "", date: Date())  // 重置新任务
                            isAddingNewTodo = true
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(themeColor)
                                Text("添加新的待办事项...")
                                    .foregroundColor(secondaryTextColor)
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(cardBackgroundColor)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    // 添加进度条
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("今日进度")
                                .font(.system(size: 14))
                                .foregroundColor(secondaryTextColor)  // 使用动态文字颜色
                            
                            Spacer()
                            
                            Text("\(Int(progressValue * 100))%")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(themeColor)
                        }
                        
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                // 背景条
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color(.systemGray5))
                                    .frame(height: 8)
                                
                                // 进度条
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(themeColor)
                                    .frame(width: geometry.size.width * progressValue, height: 8)
                                    .animation(.spring(duration: 0.5), value: progressValue)
                            }
                        }
                        .frame(height: 8)
                    }
                    .padding(.horizontal)
                    .padding(.top, 5)
                    
                    // 待办事项列表区域
                    if todoItems.isEmpty {
                        Spacer()
                        VStack(spacing: 20) {
                            Image(systemName: "clipboard")
                                .font(.system(size: 60))
                                .foregroundColor(themeColor.opacity(0.8))
                            Text("开始添加你的第一个待办事项吧！")
                                .font(.system(size: 16))
                                .foregroundColor(secondaryTextColor)
                        }
                        .frame(maxHeight: .infinity, alignment: .center)
                        .offset(y: -40)
                        Spacer()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(sortedAndFilteredItems) { item in
                                    Button(action: {
                                        showEditView(for: item)
                                    }) {
                                        HStack(spacing: 12) {
                                            Button(action: {
                                                toggleTodoComplete(item)
                                            }) {
                                                ZStack {
                                                    Circle()
                                                        .stroke(Color(.systemGray4), lineWidth: 1.5)
                                                        .frame(width: 22, height: 22)
                                                    
                                                    if item.isCompleted {
                                                        Circle()
                                                            .fill(themeColor)
                                                            .frame(width: 16, height: 16)
                                                    }
                                                }
                                            }
                                            
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(item.title)
                                                    .font(.system(size: 16))
                                                    .strikethrough(item.isCompleted)
                                                    .foregroundColor(item.isCompleted ? secondaryTextColor : .primary)
                                                    .lineLimit(1)
                                                
                                                HStack(spacing: 8) {
                                                    HStack(spacing: 4) {
                                                        Image(systemName: item.category.icon)
                                                            .font(.system(size: 12))
                                                        Text(item.category.rawValue)
                                                            .font(.system(size: 12))
                                                    }
                                                    .foregroundColor(item.category.color)
                                                    
                                                    Text(formatDate(item.date))
                                                        .font(.system(size: 12))
                                                        .foregroundColor(secondaryTextColor)
                                                }
                                            }
                                            
                                            Spacer()
                                            
                                            HStack(spacing: 16) {
                                                if !item.note.isEmpty {
                                                    Image(systemName: "text.alignleft")
                                                        .font(.system(size: 12))
                                                        .foregroundColor(secondaryTextColor)
                                                }
                                                
                                                Button(action: {
                                                    deleteTodo(item)
                                                }) {
                                                    Image(systemName: "trash")
                                                        .font(.system(size: 14))
                                                        .foregroundColor(themeColor)
                                                }
                                            }
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 14)
                                        .background(cardBackgroundColor)
                                        .cornerRadius(12)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .padding(.horizontal)
                                }
                            }
                            .padding(.vertical, 8)
                        }
                    }
                }
            }
            .navigationTitle("待办清单")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Menu {
                        Picker("排序方式", selection: $sortBy) {
                            Text("按时间").tag("date")
                            Text("按优先级").tag("priority")
                            Text("按分类").tag("category")
                        }
                        
                        Picker("分类筛选", selection: $selectedCategory) {
                            Text("全部").tag("all")
                            ForEach(TodoCategory.allCases, id: \.self) { category in
                                Text(category.rawValue).tag(category.rawValue)
                            }
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .foregroundColor(themeColor)
                    }
                    
                    Button(action: {
                        showingSettings = true
                    }) {
                        Image(systemName: "gear")
                            .foregroundColor(themeColor)
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .sheet(item: $editingItem) { item in
                if let index = todoItems.firstIndex(where: { $0.id == item.id }) {
                    TodoEditView(todoItem: $todoItems[index], isNewItem: false)
                }
            }
            .sheet(isPresented: $isAddingNewTodo) {
                TodoEditView(todoItem: $newTodoItem, isNewItem: true)
                    .onDisappear {
                        if !newTodoItem.title.isEmpty {
                            todoItems.append(newTodoItem)
                            scheduleNotification(for: newTodoItem)
                        }
                    }
            }
        }
        .preferredColorScheme(useSystemTheme ? nil : (isDarkMode ? .dark : .light))
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd HH:mm"
        return formatter.string(from: date)
    }
    
    private func toggleTodoComplete(_ item: TodoItem) {
        if let index = todoItems.firstIndex(where: { $0.id == item.id }) {
            todoItems[index].isCompleted.toggle()
            
            // 如果完成了，取消通知
            if todoItems[index].isCompleted {
                cancelNotification(for: item)
            }
        }
    }
    
    private func deleteTodo(_ item: TodoItem) {
        if let index = todoItems.firstIndex(where: { $0.id == item.id }) {
            cancelNotification(for: item)
            todoItems.remove(at: index)
        }
    }
    
    // 请求通知权限
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if let error = error {
                print("通知权限请求失败: \(error.localizedDescription)")
            }
        }
    }
    
    // 设置通知
    private func scheduleNotification(for item: TodoItem) {
        guard enableNotifications else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "待办提醒"
        content.body = "您有一个待办事项「\(item.title)」尚未完成"
        content.sound = .default
        
        let calendar = Calendar.current
        
        // 使用设置中的提醒时间
        if let reminderTime = calendar.date(byAdding: .hour, value: -Int(reminderHours), to: item.date) {
            if reminderTime > Date() {
                let reminderComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: reminderTime)
                let reminderTrigger = UNCalendarNotificationTrigger(dateMatching: reminderComponents, repeats: false)
                let reminderRequest = UNNotificationRequest(identifier: "\(item.notificationId)-reminder", content: content, trigger: reminderTrigger)
                UNUserNotificationCenter.current().add(reminderRequest)
            }
        }
        
        // 到期时的提醒
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: item.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: item.notificationId, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    // 取消通知
    private func cancelNotification(for item: TodoItem) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [
            item.notificationId,
            "\(item.notificationId)-2hours"
        ])
    }
    
    // 修改显示逻辑
    var filteredTodoItems: [TodoItem] {
        if showCompletedTasks {
            return todoItems
        } else {
            return todoItems.filter { !$0.isCompleted }
        }
    }
    
    // 添加一个辅助函数来获取选中项的绑定
    private func binding(for item: TodoItem) -> Binding<TodoItem> {
        Binding(
            get: {
                if let index = todoItems.firstIndex(where: { $0.id == item.id }) {
                    return todoItems[index]
                }
                return item
            },
            set: { newValue in
                if let index = todoItems.firstIndex(where: { $0.id == item.id }) {
                    todoItems[index] = newValue
                    // 如果修改了时间，需要更新通知
                    cancelNotification(for: item)
                    scheduleNotification(for: newValue)
                }
            }
        )
    }
    
    // 修改点击事件处理
    private func showEditView(for item: TodoItem) {
        editingItem = item
    }
}

#Preview {
    ContentView()
}
