import Foundation

struct Currency: Identifiable, Hashable {
    let id = UUID()
    let code: String
    let name: String
    let flag: String
    let symbol: String
    
    static let allCurrencies: [Currency] = [
        // 주요 통화 (상단에 배치)
        Currency(code: "KRW", name: "대한민국 원", flag: "🇰🇷", symbol: "₩"),
        Currency(code: "USD", name: "미국 달러", flag: "🇺🇸", symbol: "$"),
        Currency(code: "EUR", name: "유로", flag: "🇪🇺", symbol: "€"),
        Currency(code: "JPY", name: "일본 엔화", flag: "🇯🇵", symbol: "¥"),
        Currency(code: "CNY", name: "중국 위안화", flag: "🇨🇳", symbol: "¥"),
        Currency(code: "GBP", name: "영국 파운드", flag: "🇬🇧", symbol: "£"),
        Currency(code: "HKD", name: "홍콩 달러", flag: "🇭🇰", symbol: "HK$"),
        Currency(code: "SGD", name: "싱가포르 달러", flag: "🇸🇬", symbol: "S$"),
        Currency(code: "AUD", name: "호주 달러", flag: "🇦🇺", symbol: "A$"),
        Currency(code: "CAD", name: "캐나다 달러", flag: "🇨🇦", symbol: "C$"),
        Currency(code: "CHF", name: "스위스 프랑", flag: "🇨🇭", symbol: "CHF"),
        Currency(code: "NZD", name: "뉴질랜드 달러", flag: "🇳🇿", symbol: "NZ$"),
        
        // 아시아 통화
        Currency(code: "TWD", name: "신 타이완 달러", flag: "🇹🇼", symbol: "NT$"),
        Currency(code: "THB", name: "태국 바트", flag: "🇹🇭", symbol: "฿"),
        Currency(code: "MYR", name: "말레이지아 링기트", flag: "🇲🇾", symbol: "RM"),
        Currency(code: "IDR", name: "인도네시아 루피아", flag: "🇮🇩", symbol: "Rp"),
        Currency(code: "PHP", name: "필리핀 페소", flag: "🇵🇭", symbol: "₱"),
        Currency(code: "VND", name: "베트남 동", flag: "🇻🇳", symbol: "₫"),
        
        // 중동 통화
        Currency(code: "AED", name: "아랍에미리트 디르함", flag: "🇦🇪", symbol: "د.إ"),
        Currency(code: "SAR", name: "사우디 리얄", flag: "🇸🇦", symbol: "ر.س"),
        Currency(code: "KWD", name: "쿠웨이트 디나르", flag: "🇰🇼", symbol: "د.ك"),
        Currency(code: "BHD", name: "바레인 디나르", flag: "🇧🇭", symbol: ".د.ب"),
        
        // 유럽 통화
        Currency(code: "SEK", name: "스웨덴 크로나", flag: "🇸🇪", symbol: "kr"),
        Currency(code: "NOK", name: "노르웨이 크로네", flag: "🇳🇴", symbol: "kr"),
        Currency(code: "DKK", name: "덴마아크 크로네", flag: "🇩🇰", symbol: "kr"),
        
        // 기타 통화
        Currency(code: "RUB", name: "러시아 루블", flag: "🇷🇺", symbol: "₽"),
        Currency(code: "XOF", name: "씨에프에이 프랑", flag: "🌍", symbol: "CFA"),
        
        // 폐지된 통화 (참고용)
        Currency(code: "ATS", name: "오스트리아 실링", flag: "🇦🇹", symbol: "ATS"),
        Currency(code: "BEF", name: "벨기에 프랑", flag: "🇧🇪", symbol: "BEF"),
        Currency(code: "DEM", name: "독일 마르크", flag: "🇩🇪", symbol: "DEM"),
        Currency(code: "ESP", name: "스페인 페세타", flag: "🇪🇸", symbol: "ESP"),
        Currency(code: "FIM", name: "핀란드 마르카", flag: "🇫🇮", symbol: "FIM"),
        Currency(code: "FRF", name: "프랑스 프랑", flag: "🇫🇷", symbol: "FRF"),
        Currency(code: "ITL", name: "이태리 리라", flag: "🇮🇹", symbol: "ITL"),
        Currency(code: "NLG", name: "네델란드 길더", flag: "🇳🇱", symbol: "NLG")
    ]
    
    static func findByCode(_ code: String) -> Currency? {
        return allCurrencies.first { $0.code == code }
    }
}
