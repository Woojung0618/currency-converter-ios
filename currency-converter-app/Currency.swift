import Foundation

struct Currency: Identifiable, Hashable {
    let id = UUID()
    let code: String
    let name: String
    let flag: String
    let symbol: String
    
    static let allCurrencies: [Currency] = [
        Currency(code: "KRW", name: "대한민국 원", flag: "🇰🇷", symbol: "₩"),
        Currency(code: "USD", name: "미국 달러", flag: "🇺🇸", symbol: "$"),
        Currency(code: "VND", name: "베트남 동", flag: "🇻🇳", symbol: "₫"),
        Currency(code: "EUR", name: "유로", flag: "🇪🇺", symbol: "€"),
        Currency(code: "JPY", name: "일본 엔화", flag: "🇯🇵", symbol: "¥"),
        Currency(code: "THB", name: "태국 바트", flag: "🇹🇭", symbol: "฿"),
        Currency(code: "CNY", name: "중국 위안화", flag: "🇨🇳", symbol: "¥"),
        Currency(code: "PHP", name: "필리핀 페소", flag: "🇵🇭", symbol: "₱"),
        Currency(code: "RUB", name: "러시아 루블", flag: "🇷🇺", symbol: "₽"),
        Currency(code: "TWD", name: "신 타이완 달러", flag: "🇹🇼", symbol: "NT$"),
        Currency(code: "HKD", name: "홍콩 달러", flag: "🇭🇰", symbol: "HK$")
    ]
    
    static func findByCode(_ code: String) -> Currency? {
        return allCurrencies.first { $0.code == code }
    }
}
