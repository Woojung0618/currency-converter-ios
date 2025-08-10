import Foundation
import Combine

// 한국수출입은행 환율 API 응답 모델
struct KoreaEximExchangeRateItem: Codable {
    let result: Int
    let cur_unit: String
    let ttb: String
    let tts: String
    let deal_bas_r: String
    let bkpr: String
    let yy_efee_r: String
    let ten_dd_efee_r: String
    let kftc_bkpr: String
    let kftc_deal_bas_r: String
    let cur_nm: String
}

class ExchangeRateService: ObservableObject {
    @Published var rates: [String: Double] = [:]
    @Published var lastUpdated: Date = Date()
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    // 한국수출입은행 API 설정
    private let apiKey = Config.koreaEximApiKey
    private let baseURL = Config.koreaEximBaseURL
    
    init() {
        loadExchangeRates()
    }
    
    func loadExchangeRates() {
        isLoading = true
        errorMessage = nil
        
        // 오늘 날짜를 YYYYMMDD 형식으로 변환
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let today = dateFormatter.string(from: Date())
        
        // 한국수출입은행 환율정보조회 API 호출
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.queryItems = [
            URLQueryItem(name: "authkey", value: apiKey),
            URLQueryItem(name: "searchdate", value: today),
            URLQueryItem(name: "data", value: "AP01")
        ]
        
        guard let url = urlComponents?.url else {
            handleError("잘못된 URL입니다.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: [KoreaEximExchangeRateItem].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    self.isLoading = false
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.handleError("환율 데이터를 가져오는데 실패했습니다: \(error.localizedDescription)")
                    }
                },
                receiveValue: { response in
                    self.processExchangeRates(response)
                }
            )
            .store(in: &cancellables)
    }
    
    private func processExchangeRates(_ response: [KoreaEximExchangeRateItem]) {
        var newRates: [String: Double] = [:]
        
        // KRW를 기준으로 환율 설정 (1 KRW = 1)
        newRates["KRW"] = 1.0
        
        for item in response {
            // result가 1이면 성공
            guard item.result == 1 else { continue }
            
            // deal_bas_r (매매기준율) 사용
            let rateString = item.deal_bas_r.replacingOccurrences(of: ",", with: "")
            guard let rate = Double(rateString) else { continue }
            
            // API에서 받은 환율은 1 외화 = X KRW 형태이므로
            // KRW 기준으로 변환 (1 KRW = 1/rate 외화)
            let krwRate = 1.0 / rate
            
            switch item.cur_unit {
            case "USD":
                newRates["USD"] = krwRate
            case "EUR":
                newRates["EUR"] = krwRate
            case "JPY(100)":
                // JPY는 100엔 단위이므로 100으로 나누어 1엔 기준으로 변환
                newRates["JPY"] = krwRate / 100.0
            case "CNH":
                newRates["CNY"] = krwRate
            case "HKD":
                newRates["HKD"] = krwRate
            case "TWD":
                newRates["TWD"] = krwRate
            case "THB":
                newRates["THB"] = krwRate
            case "VND":
                newRates["VND"] = krwRate
            case "PHP":
                newRates["PHP"] = krwRate
            case "RUB":
                newRates["RUB"] = krwRate
            case "GBP":
                newRates["GBP"] = krwRate
            case "AUD":
                newRates["AUD"] = krwRate
            case "CAD":
                newRates["CAD"] = krwRate
            case "CHF":
                newRates["CHF"] = krwRate
            case "SGD":
                newRates["SGD"] = krwRate
            case "NZD":
                newRates["NZD"] = krwRate
            case "SEK":
                newRates["SEK"] = krwRate
            case "NOK":
                newRates["NOK"] = krwRate
            case "DKK":
                newRates["DKK"] = krwRate
            case "MYR":
                newRates["MYR"] = krwRate
            case "IDR(100)":
                // IDR은 100루피아 단위이므로 100으로 나누어 1루피아 기준으로 변환
                newRates["IDR"] = krwRate / 100.0
            default:
                break
            }
        }
        
        // 지원하지 않는 통화에 대한 기본값 설정 (API에서 데이터가 없는 경우)
        if newRates["USD"] == nil { newRates["USD"] = 0.00094 }
        if newRates["EUR"] == nil { newRates["EUR"] = 0.00078 }
        if newRates["JPY"] == nil { newRates["JPY"] = 0.105 }
        if newRates["CNY"] == nil { newRates["CNY"] = 0.0061 }
        if newRates["HKD"] == nil { newRates["HKD"] = 0.0073 }
        if newRates["TWD"] == nil { newRates["TWD"] = 0.030 }
        if newRates["THB"] == nil { newRates["THB"] = 0.030 }
        if newRates["VND"] == nil { newRates["VND"] = 23.0 }
        if newRates["PHP"] == nil { newRates["PHP"] = 0.053 }
        if newRates["RUB"] == nil { newRates["RUB"] = 0.087 }
        
        self.rates = newRates
        self.lastUpdated = Date()
    }
    
    private func handleError(_ message: String) {
        DispatchQueue.main.async {
            self.errorMessage = message
            self.isLoading = false
            // 오류 발생 시 기본값 사용
            self.loadMockRates()
        }
    }
    
    // API 호출 실패 시 사용할 기본 환율 (샘플 데이터 기반)
    func loadMockRates() {
        rates = [
            "KRW": 1.0,
            "USD": 0.00094,  // 1,066.9 KRW = 1 USD
            "EUR": 0.00078,  // 1,286.91 KRW = 1 EUR
            "JPY": 0.105,    // 951.05 KRW = 100 JPY
            "CNY": 0.0061,   // 163.65 KRW = 1 CNY
            "HKD": 0.0073,   // 137.13 KRW = 1 HKD
            "TWD": 0.030,    // 33.22 KRW = 1 TWD (추정)
            "THB": 0.030,    // 32.9 KRW = 1 THB
            "VND": 23.0,     // 추정값
            "PHP": 0.053,    // 추정값
            "RUB": 0.087,    // 추정값
            "GBP": 0.00069,  // 1,447.3 KRW = 1 GBP
            "AUD": 0.00120,  // 836.28 KRW = 1 AUD
            "CAD": 0.00117,  // 853.26 KRW = 1 CAD
            "CHF": 0.00091,  // 1,099.44 KRW = 1 CHF
            "SGD": 0.00125,  // 801.08 KRW = 1 SGD
            "NZD": 0.00132,  // 760.37 KRW = 1 NZD
            "SEK": 0.00766,  // 130.61 KRW = 1 SEK
            "NOK": 0.00765,  // 130.75 KRW = 1 NOK
            "DKK": 0.00579,  // 172.87 KRW = 1 DKK
            "MYR": 0.00378,  // 264.74 KRW = 1 MYR
            "IDR": 0.1266    // 7.9 KRW = 100 IDR
        ]
        lastUpdated = Date()
    }
    
    func getRate(from: String, to: String) -> Double {
        guard let fromRate = rates[from], let toRate = rates[to] else {
            return 1.0
        }
        return toRate / fromRate
    }
    
    func convert(amount: Double, from: String, to: String) -> Double {
        let rate = getRate(from: from, to: to)
        return amount * rate
    }
    
    func refreshRates() {
        loadExchangeRates()
    }
}
