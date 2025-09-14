import SwiftUI

// MARK: - 다크모드 지원을 위한 색상 스키마
extension Color {
    // 배경 색상
    static let appBackground = Color(.systemBackground)
    static let appSecondaryBackground = Color(.secondarySystemBackground)
    static let appTertiaryBackground = Color(.tertiarySystemBackground)
    
    // 그룹 배경 색상
    static let appGroupedBackground = Color(.systemGroupedBackground)
    static let appSecondaryGroupedBackground = Color(.secondarySystemGroupedBackground)
    
    // 텍스트 색상
    static let appPrimaryText = Color(.label)
    static let appSecondaryText = Color(.secondaryLabel)
    static let appTertiaryText = Color(.tertiaryLabel)
    
    // 구분선 색상
    static let appSeparator = Color(.separator)
    static let appOpaqueSeparator = Color(.opaqueSeparator)
    
    // 시스템 색상
    static let appSystemGray = Color(.systemGray)
    static let appSystemGray2 = Color(.systemGray2)
    static let appSystemGray3 = Color(.systemGray3)
    static let appSystemGray4 = Color(.systemGray4)
    static let appSystemGray5 = Color(.systemGray5)
    static let appSystemGray6 = Color(.systemGray6)
    
    // 앱 테마 색상
    static let appOrange = Color.orange
    static let appGreen = Color.green
    static let appRed = Color.red
    static let appBlue = Color.blue
}

// MARK: - 다크모드 지원 뷰 모디파이어
struct DarkModeSupport: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .preferredColorScheme(nil) // 시스템 설정을 따름
    }
}

extension View {
    func darkModeSupport() -> some View {
        modifier(DarkModeSupport())
    }
}

// MARK: - 다크모드별 색상 정의
struct AppColors {
    // 다크모드에 따른 동적 색상
    static func background(for colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .dark:
            return Color(.systemBackground)
        default:
            return Color(.systemBackground)
        }
    }
    
    static func secondaryBackground(for colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .dark:
            return Color(.secondarySystemBackground)
        default:
            return Color(.secondarySystemBackground)
        }
    }
    
    static func groupedBackground(for colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .dark:
            return Color(.systemGroupedBackground)
        default:
            return Color(.systemGroupedBackground)
        }
    }
    
    static func cardBackground(for colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .dark:
            return Color(.secondarySystemBackground)
        default:
            return Color(.systemBackground)
        }
    }
    
    static func buttonBackground(for colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .dark:
            return Color(.systemGray5)
        default:
            return Color(.systemGray5)
        }
    }
    
    static func calculatorButtonBackground(for colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .dark:
            return Color(.systemGray4)
        default:
            return Color(.systemGray4)
        }
    }
    
    static func calculatorButtonText(for colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .dark:
            return Color(.label)
        default:
            return Color.white
        }
    }
    
    // 다크모드별 그림자 효과
    static func shadowColor(for colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .dark:
            return Color.black.opacity(0.3)
        default:
            return Color.black.opacity(0.1)
        }
    }
    
    // 다크모드별 테두리 색상
    static func borderColor(for colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .dark:
            return Color(.separator)
        default:
            return Color(.separator)
        }
    }
}
