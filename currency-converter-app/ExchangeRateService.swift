import Foundation
import Combine

// S3에서 받아오는 환율 데이터 모델
struct S3ExchangeRateResponse: Codable {
    let timestamp: String
    let searchdate: String
    let exchange_rates: [S3ExchangeRateItem]
}

struct S3ExchangeRateItem: Codable {
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
    @Published var isOffline = false
    
    private var cancellables = Set<AnyCancellable>()
    
    // S3 객체 URL 설정
    private let s3URL = "https://exchng-rate-bucket.s3.us-east-1.amazonaws.com/exchange_rate.json"
    
    // UserDefaults 키
    private let savedRatesKey = "SavedExchangeRates"
    private let savedLastUpdatedKey = "SavedLastUpdated"
    
    init() {
        // 저장된 환율 데이터가 있으면 로드, 없으면 기본값 설정
        if hasSavedRates() {
            loadSavedRates()
        } else {
            loadMockRates()
        }
        // 그 다음 최신 환율 데이터 로드 시도
        loadExchangeRates()
    }
    
    deinit {
        // 메모리 해제를 위해 cancellables 정리
        cancellables.removeAll()
    }
    
    func loadExchangeRates() {
        // 기존 네트워크 요청 취소 (메모리 누수 방지)
        cancellables.removeAll()
        
        isLoading = true
        errorMessage = nil
        isOffline = false
        
        // S3 객체 URL에서 환율 데이터 가져오기
        guard let url = URL(string: s3URL) else {
            handleError(NSLocalizedString("invalid_url", comment: ""))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10 // 10초 타임아웃 설정
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: S3ExchangeRateResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    self.isLoading = false
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.handleError(error)
                    }
                },
                receiveValue: { response in
                    self.processExchangeRates(response.exchange_rates)
                }
            )
            .store(in: &cancellables)
    }
    
    private func processExchangeRates(_ response: [S3ExchangeRateItem]) {
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
            // 주요 통화
            case "USD":
                newRates["USD"] = krwRate
            case "EUR":
                newRates["EUR"] = krwRate
            case "JPY(100)":
                // JPY는 100엔 단위이므로 100으로 나누어 1엔 기준으로 변환
                newRates["JPY"] = krwRate / 100.0
            case "CNH":
                newRates["CNY"] = krwRate
            case "GBP":
                newRates["GBP"] = krwRate
            case "HKD":
                newRates["HKD"] = krwRate
            case "SGD":
                newRates["SGD"] = krwRate
            case "AUD":
                newRates["AUD"] = krwRate
            case "CAD":
                newRates["CAD"] = krwRate
            case "CHF":
                newRates["CHF"] = krwRate
            case "NZD":
                newRates["NZD"] = krwRate
                
            // 아시아 통화
            case "TWD":
                newRates["TWD"] = krwRate
            case "THB":
                newRates["THB"] = krwRate
            case "MYR":
                newRates["MYR"] = krwRate
            case "IDR(100)":
                // IDR은 100루피아 단위이므로 100으로 나누어 1루피아 기준으로 변환
                newRates["IDR"] = krwRate / 100.0
            case "PHP":
                newRates["PHP"] = krwRate
            case "VND":
                newRates["VND"] = krwRate
                
            // 중동 통화
            case "AED":
                newRates["AED"] = krwRate
            case "SAR":
                newRates["SAR"] = krwRate
            case "KWD":
                newRates["KWD"] = krwRate
            case "BHD":
                newRates["BHD"] = krwRate
                
            // 유럽 통화
            case "SEK":
                newRates["SEK"] = krwRate
            case "NOK":
                newRates["NOK"] = krwRate
            case "DKK":
                newRates["DKK"] = krwRate
                
            // 기타 통화
            case "RUB":
                newRates["RUB"] = krwRate
            case "XOF":
                newRates["XOF"] = krwRate
                
            // 폐지된 통화 (참고용)
            case "ATS":
                newRates["ATS"] = krwRate
            case "BEF":
                newRates["BEF"] = krwRate
            case "DEM":
                newRates["DEM"] = krwRate
            case "ESP(100)":
                // ESP는 100페세타 단위이므로 100으로 나누어 1페세타 기준으로 변환
                newRates["ESP"] = krwRate / 100.0
            case "FIM":
                newRates["FIM"] = krwRate
            case "FRF":
                newRates["FRF"] = krwRate
            case "ITL(100)":
                // ITL은 100리라 단위이므로 100으로 나누어 1리라 기준으로 변환
                newRates["ITL"] = krwRate / 100.0
            case "NLG":
                newRates["NLG"] = krwRate
                
            default:
                break
            }
        }
        
        // 지원하지 않는 통화에 대한 기본값 설정 (API에서 데이터가 없는 경우)
        // 주요 통화
        if newRates["USD"] == nil { newRates["USD"] = 0.00094 }
        if newRates["EUR"] == nil { newRates["EUR"] = 0.00078 }
        if newRates["JPY"] == nil { newRates["JPY"] = 0.105 }
        if newRates["CNY"] == nil { newRates["CNY"] = 0.0061 }
        if newRates["GBP"] == nil { newRates["GBP"] = 0.00069 }
        if newRates["HKD"] == nil { newRates["HKD"] = 0.0073 }
        if newRates["SGD"] == nil { newRates["SGD"] = 0.00125 }
        if newRates["AUD"] == nil { newRates["AUD"] = 0.00120 }
        if newRates["CAD"] == nil { newRates["CAD"] = 0.00117 }
        if newRates["CHF"] == nil { newRates["CHF"] = 0.00091 }
        if newRates["NZD"] == nil { newRates["NZD"] = 0.00132 }
        
        // 아시아 통화
        if newRates["TWD"] == nil { newRates["TWD"] = 0.030 }
        if newRates["THB"] == nil { newRates["THB"] = 0.030 }
        if newRates["MYR"] == nil { newRates["MYR"] = 0.00378 }
        if newRates["IDR"] == nil { newRates["IDR"] = 0.1266 }
        if newRates["PHP"] == nil { newRates["PHP"] = 0.053 }
        if newRates["VND"] == nil { newRates["VND"] = 23.0 }
        
        // 중동 통화
        if newRates["AED"] == nil { newRates["AED"] = 0.00343 }
        if newRates["SAR"] == nil { newRates["SAR"] = 0.00350 }
        if newRates["KWD"] == nil { newRates["KWD"] = 0.00028 }
        if newRates["BHD"] == nil { newRates["BHD"] = 0.00035 }
        
        // 유럽 통화
        if newRates["SEK"] == nil { newRates["SEK"] = 0.00766 }
        if newRates["NOK"] == nil { newRates["NOK"] = 0.00765 }
        if newRates["DKK"] == nil { newRates["DKK"] = 0.00579 }
        
        // 기타 통화
        if newRates["RUB"] == nil { newRates["RUB"] = 0.087 }
        if newRates["XOF"] == nil { newRates["XOF"] = 0.5097 }
        
        self.rates = newRates
        self.lastUpdated = Date()
        
        // 성공적으로 환율 데이터를 받아오면 로컬에 저장
        saveRatesToLocal(newRates)
    }
    
    // MARK: - Local Storage Methods
    
    private func saveRatesToLocal(_ rates: [String: Double]) {
        let userDefaults = UserDefaults.standard
        
        // 환율 데이터를 JSON으로 변환하여 저장
        if let ratesData = try? JSONEncoder().encode(rates) {
            userDefaults.set(ratesData, forKey: savedRatesKey)
        }
        
        // 마지막 업데이트 시간 저장
        userDefaults.set(lastUpdated, forKey: savedLastUpdatedKey)
    }
    
    private func loadSavedRates() {
        let userDefaults = UserDefaults.standard
        
        // 저장된 환율 데이터 로드
        if let ratesData = userDefaults.data(forKey: savedRatesKey),
           let savedRates = try? JSONDecoder().decode([String: Double].self, from: ratesData) {
            self.rates = savedRates
        }
        
        // 저장된 마지막 업데이트 시간 로드
        if let savedDate = userDefaults.object(forKey: savedLastUpdatedKey) as? Date {
            self.lastUpdated = savedDate
        }
    }
    
    private func hasSavedRates() -> Bool {
        let userDefaults = UserDefaults.standard
        return userDefaults.data(forKey: savedRatesKey) != nil
    }
    
    private func handleError(_ error: Error) {
        DispatchQueue.main.async {
            self.isLoading = false
            
            // 오류 타입에 따른 사용자 친화적 메시지 생성
            let errorMessage: String
            let isOfflineMode: Bool
            
            if let urlError = error as? URLError {
                switch urlError.code {
                case .notConnectedToInternet, .networkConnectionLost:
                    errorMessage = NSLocalizedString("offline_message", comment: "")
                    isOfflineMode = true
                case .timedOut:
                    errorMessage = NSLocalizedString("timeout_message", comment: "")
                    isOfflineMode = false
                case .cannotFindHost, .cannotConnectToHost:
                    errorMessage = NSLocalizedString("connection_error", comment: "")
                    isOfflineMode = false
                default:
                    errorMessage = NSLocalizedString("fetch_error", comment: "")
                    isOfflineMode = false
                }
            } else {
                errorMessage = NSLocalizedString("fetch_error", comment: "")
                isOfflineMode = false
            }
            
            self.errorMessage = errorMessage
            self.isOffline = isOfflineMode
            
            // 저장된 환율 데이터가 있으면 사용, 없으면 기본값 사용
            if self.hasSavedRates() {
                self.loadSavedRates()
            } else {
                self.loadMockRates()
            }
        }
    }
    
    private func handleError(_ message: String) {
        DispatchQueue.main.async {
            self.errorMessage = message
            self.isLoading = false
            self.isOffline = false
            // 저장된 환율 데이터가 있으면 사용, 없으면 기본값 사용
            if self.hasSavedRates() {
                self.loadSavedRates()
            } else {
                self.loadMockRates()
            }
        }
    }
    
    // API 호출 실패 시 사용할 기본 환율 (샘플 데이터 기반)
    func loadMockRates() {
        rates = [
            // 기본 통화
            "KRW": 1.0,
            
            // 주요 통화
            "USD": 0.00094,  // 1,066.9 KRW = 1 USD
            "EUR": 0.00078,  // 1,286.91 KRW = 1 EUR
            "JPY": 0.105,    // 951.05 KRW = 100 JPY
            "CNY": 0.0061,   // 163.65 KRW = 1 CNY
            "GBP": 0.00069,  // 1,447.3 KRW = 1 GBP
            "HKD": 0.0073,   // 137.13 KRW = 1 HKD
            "SGD": 0.00125,  // 801.08 KRW = 1 SGD
            "AUD": 0.00120,  // 836.28 KRW = 1 AUD
            "CAD": 0.00117,  // 853.26 KRW = 1 CAD
            "CHF": 0.00091,  // 1,099.44 KRW = 1 CHF
            "NZD": 0.00132,  // 760.37 KRW = 1 NZD
            
            // 아시아 통화
            "TWD": 0.030,    // 33.22 KRW = 1 TWD (추정)
            "THB": 0.030,    // 32.9 KRW = 1 THB
            "MYR": 0.00378,  // 264.74 KRW = 1 MYR
            "IDR": 0.1266,   // 7.9 KRW = 100 IDR
            "PHP": 0.053,    // 추정값
            "VND": 23.0,     // 추정값
            
            // 중동 통화
            "AED": 0.00343,  // 291.7 KRW = 1 AED
            "SAR": 0.00350,  // 285.7 KRW = 1 SAR
            "KWD": 0.00028,  // 3,545.33 KRW = 1 KWD
            "BHD": 0.00035,  // 2,839.88 KRW = 1 BHD
            
            // 유럽 통화
            "SEK": 0.00766,  // 130.61 KRW = 1 SEK
            "NOK": 0.00765,  // 130.75 KRW = 1 NOK
            "DKK": 0.00579,  // 172.87 KRW = 1 DKK
            
            // 기타 통화
            "RUB": 0.087,    // 추정값
            "XOF": 0.5097,   // 1.9618 KRW = 1 XOF
            
            // 폐지된 통화 (참고용)
            "ATS": 0.01069,  // 93.52 KRW = 1 ATS
            "BEF": 0.03135,  // 31.9 KRW = 1 BEF
            "DEM": 0.00152,  // 657.98 KRW = 1 DEM
            "ESP": 0.1294,   // 773 KRW = 100 ESP
            "FIM": 0.00462,  // 216.44 KRW = 1 FIM
            "FRF": 0.00510,  // 196.18 KRW = 1 FRF
            "ITL": 1.505,    // 66.46 KRW = 100 ITL
            "NLG": 0.00171   // 583.97 KRW = 1 NLG
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
    
    // 테스트용: 강제로 오프라인 상태 시뮬레이션
    func simulateOfflineMode() {
        isLoading = true
        errorMessage = nil
        isOffline = false
        
        // 2초 후 오프라인 상태 시뮬레이션
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isLoading = false
            self.errorMessage = NSLocalizedString("offline_message", comment: "")
            self.isOffline = true
            
            // 저장된 환율 데이터가 있으면 사용, 없으면 기본값 사용
            if self.hasSavedRates() {
                self.loadSavedRates()
            } else {
                self.loadMockRates()
            }
        }
    }
    
    // 테스트용: 강제로 API 오류 시뮬레이션
    func simulateApiError() {
        isLoading = true
        errorMessage = nil
        isOffline = false
        
        // 2초 후 API 오류 시뮬레이션
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isLoading = false
            self.errorMessage = NSLocalizedString("fetch_error", comment: "")
            self.isOffline = false
            
            // 저장된 환율 데이터가 있으면 사용, 없으면 기본값 사용
            if self.hasSavedRates() {
                self.loadSavedRates()
            } else {
                self.loadMockRates()
            }
        }
    }
    
    func getInfoMessage() -> String {
        if isOffline {
            return NSLocalizedString("offline_status", comment: "")
        } else {
            return NSLocalizedString("online_status", comment: "")
        }
    }
}
