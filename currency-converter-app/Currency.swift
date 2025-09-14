import Foundation

struct Currency: Identifiable, Hashable {
    let id = UUID()
    let code: String
    let nameKey: String
    let flag: String
    let symbol: String
    
    var localizedName: String {
        return NSLocalizedString(nameKey, comment: "")
    }
    
    static let allCurrencies: [Currency] = [
        // 주요 통화 (상단에 배치)
        Currency(code: "KRW", nameKey: "currency_krw", flag: "🇰🇷", symbol: "₩"),
        Currency(code: "USD", nameKey: "currency_usd", flag: "🇺🇸", symbol: "$"),
        Currency(code: "EUR", nameKey: "currency_eur", flag: "🇪🇺", symbol: "€"),
        Currency(code: "JPY", nameKey: "currency_jpy", flag: "🇯🇵", symbol: "¥"),
        Currency(code: "CNY", nameKey: "currency_cny", flag: "🇨🇳", symbol: "¥"),
        Currency(code: "GBP", nameKey: "currency_gbp", flag: "🇬🇧", symbol: "£"),
        Currency(code: "HKD", nameKey: "currency_hkd", flag: "🇭🇰", symbol: "HK$"),
        Currency(code: "SGD", nameKey: "currency_sgd", flag: "🇸🇬", symbol: "S$"),
        Currency(code: "AUD", nameKey: "currency_aud", flag: "🇦🇺", symbol: "A$"),
        Currency(code: "CAD", nameKey: "currency_cad", flag: "🇨🇦", symbol: "C$"),
        Currency(code: "CHF", nameKey: "currency_chf", flag: "🇨🇭", symbol: "CHF"),
        Currency(code: "NZD", nameKey: "currency_nzd", flag: "🇳🇿", symbol: "NZ$"),
        
        // 아시아 통화
        Currency(code: "TWD", nameKey: "currency_twd", flag: "🇹🇼", symbol: "NT$"),
        Currency(code: "THB", nameKey: "currency_thb", flag: "🇹🇭", symbol: "฿"),
        Currency(code: "MYR", nameKey: "currency_myr", flag: "🇲🇾", symbol: "RM"),
        Currency(code: "IDR", nameKey: "currency_idr", flag: "🇮🇩", symbol: "Rp"),
        Currency(code: "PHP", nameKey: "currency_php", flag: "🇵🇭", symbol: "₱"),
        Currency(code: "VND", nameKey: "currency_vnd", flag: "🇻🇳", symbol: "₫"),
        
        // 중동 통화
        Currency(code: "AED", nameKey: "currency_aed", flag: "🇦🇪", symbol: "د.إ"),
        Currency(code: "SAR", nameKey: "currency_sar", flag: "🇸🇦", symbol: "ر.س"),
        Currency(code: "KWD", nameKey: "currency_kwd", flag: "🇰🇼", symbol: "د.ك"),
        Currency(code: "BHD", nameKey: "currency_bhd", flag: "🇧🇭", symbol: ".د.ب"),
        
        // 유럽 통화
        Currency(code: "SEK", nameKey: "currency_sek", flag: "🇸🇪", symbol: "kr"),
        Currency(code: "NOK", nameKey: "currency_nok", flag: "🇳🇴", symbol: "kr"),
        Currency(code: "DKK", nameKey: "currency_dkk", flag: "🇩🇰", symbol: "kr"),
        
        // 기타 통화
        Currency(code: "RUB", nameKey: "currency_rub", flag: "🇷🇺", symbol: "₽"),
        Currency(code: "XOF", nameKey: "currency_xof", flag: "🌍", symbol: "CFA"),
        
        // 폐지된 통화 (참고용)
        Currency(code: "ATS", nameKey: "currency_ats", flag: "🇦🇹", symbol: "ATS"),
        Currency(code: "BEF", nameKey: "currency_bef", flag: "🇧🇪", symbol: "BEF"),
        Currency(code: "DEM", nameKey: "currency_dem", flag: "🇩🇪", symbol: "DEM"),
        Currency(code: "ESP", nameKey: "currency_esp", flag: "🇪🇸", symbol: "ESP"),
        Currency(code: "FIM", nameKey: "currency_fim", flag: "🇫🇮", symbol: "FIM"),
        Currency(code: "FRF", nameKey: "currency_frf", flag: "🇫🇷", symbol: "FRF"),
        Currency(code: "ITL", nameKey: "currency_itl", flag: "🇮🇹", symbol: "ITL"),
        Currency(code: "NLG", nameKey: "currency_nlg", flag: "🇳🇱", symbol: "NLG")
    ]
    
    static func findByCode(_ code: String) -> Currency? {
        return allCurrencies.first { $0.code == code }
    }
}
