import SwiftUI

struct TodoEditView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @AppStorage("useSystemTheme") private var useSystemTheme = true
    @AppStorage("isDarkMode") private var isDarkMode = false
    @Binding var todoItem: TodoItem
    let isNewItem: Bool
    
    private let themeColor = Color(red: 248/255, green: 174/255, blue: 175/255)
    
    private var isCurrentlyDark: Bool {
        useSystemTheme ? (colorScheme == .dark) : isDarkMode
    }
    
    private var formBackgroundColor: Color {
        isCurrentlyDark ? Color(.systemBackground) : Color(.systemGroupedBackground)
    }
    
    private var sectionBackgroundColor: Color {
        isCurrentlyDark ? Color(.secondarySystemBackground) : Color(.systemBackground)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                formBackgroundColor.ignoresSafeArea()
                
                Form {
                    Section {
                        TextField("任务标题", text: $todoItem.title)
                            .font(.system(size: 16))
                            .textInputAutocapitalization(.never)
                        
                        DatePicker("截止时间", selection: $todoItem.date, displayedComponents: [.date, .hourAndMinute])
                            .font(.system(size: 16))
                            .tint(themeColor)
                    }
                    .listRowBackground(sectionBackgroundColor)
                    
                    Section(header: Text("任务信息").textCase(.none)) {
                        HStack {
                            Text("分类")
                            Spacer()
                            Picker("分类", selection: $todoItem.category) {
                                ForEach(TodoCategory.allCases, id: \.self) { category in
                                    HStack {
                                        Image(systemName: category.icon)
                                        Text(category.rawValue)
                                    }
                                    .foregroundColor(category.color)
                                    .tag(category)
                                }
                            }
                            .pickerStyle(.menu)
                            .tint(todoItem.category.color)
                        }
                        
                        HStack {
                            Text("优先级")
                            Spacer()
                            Picker("优先级", selection: $todoItem.priority) {
                                Text("低").tag(0)
                                Text("中").tag(1)
                                Text("高").tag(2)
                            }
                            .pickerStyle(.segmented)
                            .frame(width: 180)
                        }
                    }
                    .listRowBackground(sectionBackgroundColor)
                    
                    Section(header: Text("备注").textCase(.none)) {
                        TextEditor(text: $todoItem.note)
                            .frame(minHeight: 100)
                            .font(.system(size: 16))
                            .scrollContentBackground(.hidden)
                            .background(sectionBackgroundColor)
                    }
                    .listRowBackground(sectionBackgroundColor)
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle(isNewItem ? "新建任务" : "编辑任务")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                    .foregroundColor(themeColor)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        dismiss()
                    }
                    .disabled(todoItem.title.isEmpty)
                    .foregroundColor(todoItem.title.isEmpty ? .gray : themeColor)
                }
            }
            .tint(themeColor)
        }
        .preferredColorScheme(useSystemTheme ? nil : (isDarkMode ? .dark : .light))
    }
} 