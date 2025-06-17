import SwiftUI

enum TodoCategory: String, CaseIterable {
    case general = "普通"
    case work = "工作"
    case study = "学习"
    case life = "生活"
    case important = "重要"
    
    var icon: String {
        switch self {
        case .general: return "tray"
        case .work: return "briefcase"
        case .study: return "book"
        case .life: return "house"
        case .important: return "star"
        }
    }
    
    var color: Color {
        switch self {
        case .general: return .gray
        case .work: return .blue
        case .study: return .green
        case .life: return .orange
        case .important: return .red
        }
    }
} 