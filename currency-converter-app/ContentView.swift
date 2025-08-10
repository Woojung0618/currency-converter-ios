//
//  ContentView.swift
//  currency-converter-app
//
//  Created by 전우정 on 8/10/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var exchangeRateService = ExchangeRateService()
    @State private var fromCurrency = Currency.findByCode(Config.defaultFromCurrency)!
    @State private var toCurrency = Currency.findByCode(Config.defaultToCurrency)!
    @State private var displayValue = Config.defaultAmount
    @State private var currentOperation: String?
    @State private var previousValue: Double?
    @State private var shouldResetDisplay = false
    @State private var showingCurrencySelection = false
    @State private var isSelectingFromCurrency = true
    @State private var showingInfoMessage = false
    
    var convertedValue: Double {
        guard let amount = Double(displayValue) else { return 0 }
        return exchangeRateService.convert(amount: amount, from: fromCurrency.code, to: toCurrency.code)
    }
    
    var body: some View {
        ZStack {
            Color(.systemGray6)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 상단 환율 표시 영역
                VStack(spacing: 20) {
                    // 상단 통화 선택 버튼들
                    HStack {
                        Button(action: {
                            isSelectingFromCurrency = true
                            showingCurrencySelection = true
                        }) {
                            HStack {
                                Text(fromCurrency.flag)
                                    .font(.title2)
                                Text(fromCurrency.code)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color(.systemGray5))
                            .cornerRadius(20)
                        }
                        
                        Spacer()
                        
                        // 통화 교체 버튼
                        Button(action: {
                            swapCurrencies()
                        }) {
                            Image(systemName: "arrow.left.arrow.right")
                                .font(.title2)
                                .foregroundColor(.orange)
                                .padding(12)
                                .background(Color(.systemGray5))
                                .clipShape(Circle())
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            isSelectingFromCurrency = false
                            showingCurrencySelection = true
                        }) {
                            HStack {
                                Text(toCurrency.flag)
                                    .font(.title2)
                                Text(toCurrency.code)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color(.systemGray5))
                            .cornerRadius(20)
                        }
                    }
                    .padding(.horizontal)
                    
                    // 금액 표시 영역
                    VStack(spacing: 16) {
                        // 입력 금액
                        HStack {
                            Text(formatNumber(Double(displayValue) ?? 0))
                                .font(.system(size: 32, weight: .medium))
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            HStack(spacing: 8) {
                                Text(fromCurrency.flag)
                                    .font(.title2)
                                Text(fromCurrency.code)
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .onTapGesture {
                            // 숫자 입력 모드 활성화
                        }
                        
                        // 변환된 금액
                        HStack {
                            Text(formatNumber(convertedValue))
                                .font(.system(size: 32, weight: .medium))
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            HStack(spacing: 8) {
                                Text(toCurrency.flag)
                                    .font(.title2)
                                Text(toCurrency.code)
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
                .padding(.top)
                
                Spacer(minLength: 0)
                
                // 계산기 뷰
                CalculatorView(
                    displayValue: $displayValue,
                    currentOperation: $currentOperation,
                    previousValue: $previousValue,
                    shouldResetDisplay: $shouldResetDisplay,
                    onNumberTapped: { number in
                        handleNumberInput(number)
                    },
                    onOperationTapped: { operation in
                        handleOperation(operation)
                    },
                    onClear: {
                        clearCalculator()
                    },
                    onDelete: {
                        deleteLastDigit()
                    },
                    onSwap: {
                        swapCurrencies()
                    }
                )
                .background(Color(.systemBackground))
                .cornerRadius(20)
                .padding(.horizontal, 8)
                
                Spacer(minLength: 0)
                
                // 하단 정보 영역
                VStack(spacing: 8) {
                    // Info 버튼 클릭 시만 메시지 표시
                    if showingInfoMessage {
                        VStack(spacing: 4) {
                            HStack(spacing: 6) {
                                Image(systemName: exchangeRateService.isOffline ? "wifi.slash" : "wifi")
                                    .foregroundColor(exchangeRateService.isOffline ? .orange : .green)
                                    .font(.caption)
                                Text(exchangeRateService.getInfoMessage())
                                    .font(.caption)
                                    .foregroundColor(exchangeRateService.isOffline ? .orange : .green)
                                    .multilineTextAlignment(.center)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(exchangeRateService.isOffline ? Color.orange.opacity(0.1) : Color.green.opacity(0.1))
                        )
                        .padding(.horizontal)
                    }
                    
                    HStack {
                        Button(action: {
                            exchangeRateService.refreshRates()
                        }) {
                            HStack(spacing: 4) {
                                if exchangeRateService.isLoading {
                                    ProgressView()
                                        .scaleEffect(0.8)
                                        .foregroundColor(.orange)
                                } else {
                                    Image(systemName: exchangeRateService.isOffline ? "wifi.slash" : "arrow.clockwise")
                                        .foregroundColor(.orange)
                                        .font(.title3)
                                }
                            }
                        }
                        .disabled(exchangeRateService.isLoading)
                        
                        Spacer()
                        
                        VStack(spacing: 4) {
                            HStack(spacing: 4) {
                                Text(formatDate(exchangeRateService.lastUpdated))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                if exchangeRateService.isOffline {
                                    Image(systemName: "wifi.slash")
                                        .foregroundColor(.orange)
                                        .font(.caption2)
                                }
                            }
                            
                            Text("1 \(fromCurrency.code) = \(String(format: "%.5f", exchangeRateService.getRate(from: fromCurrency.code, to: toCurrency.code))) \(toCurrency.code)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation {
                                showingInfoMessage.toggle()
                            }
                        }) {
                            Image(systemName: "info.circle")
                                .foregroundColor(.orange)
                                .font(.title3)
                        }
                        
                        // 테스트용 버튼들 (개발 완료 후 제거)
                        /*
                        #if DEBUG
                        VStack(spacing: 4) {
                            Button("오프라인 테스트") {
                                exchangeRateService.simulateOfflineMode()
                            }
                            .font(.caption2)
                            .foregroundColor(.blue)
                        }
                        #endif
                         */
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color(.systemBackground))
            }
        }
        .sheet(isPresented: $showingCurrencySelection) {
            CurrencySelectionView(selectedCurrency: isSelectingFromCurrency ? $fromCurrency : $toCurrency)
        }
    }
    
    // MARK: - Helper Functions
    
    private func formatNumber(_ number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = Config.maxDecimalPlaces
        return formatter.string(from: NSNumber(value: number)) ?? "0"
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. M.d. a h:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    private func handleNumberInput(_ number: String) {
        if shouldResetDisplay {
            displayValue = number
            shouldResetDisplay = false
        } else {
            if number == "." && displayValue.contains(".") {
                return
            }
            if displayValue == "0" && number != "." {
                displayValue = number
            } else {
                displayValue += number
            }
        }
    }
    
    private func handleOperation(_ operation: String) {
        guard let currentValue = Double(displayValue) else { return }
        
        switch operation {
        case "=":
            if let prevValue = previousValue, let op = currentOperation {
                let result = performCalculation(prevValue, currentValue, op)
                displayValue = String(result)
                previousValue = nil
                currentOperation = nil
            }
        case "%":
            let result = currentValue / 100
            displayValue = String(result)
        default:
            previousValue = currentValue
            currentOperation = operation
            shouldResetDisplay = true
        }
    }
    
    private func performCalculation(_ a: Double, _ b: Double, _ operation: String) -> Double {
        switch operation {
        case "+": return a + b
        case "-": return a - b
        case "×": return a * b
        case "÷": return b != 0 ? a / b : 0
        default: return b
        }
    }
    
    private func clearCalculator() {
        displayValue = "0"
        currentOperation = nil
        previousValue = nil
        shouldResetDisplay = false
    }
    
    private func deleteLastDigit() {
        if displayValue.count > 1 {
            displayValue.removeLast()
        } else {
            displayValue = "0"
        }
    }
    
    private func swapCurrencies() {
        // 현재 입력된 금액을 저장
        guard let currentAmount = Double(displayValue) else { return }
        
        // 현재 통화로 변환된 금액을 계산 (fromCurrency -> toCurrency)
        let convertedAmount = exchangeRateService.convert(amount: currentAmount, from: fromCurrency.code, to: toCurrency.code)
        
        // 통화 교체
        let temp = fromCurrency
        fromCurrency = toCurrency
        toCurrency = temp
        
        // 변환된 금액을 새로운 입력값으로 설정
        displayValue = String(format: "%.2f", convertedAmount)
        
        // 소수점이 .00으로 끝나는 경우 정수로 표시
        if displayValue.hasSuffix(".00") {
            displayValue = String(format: "%.0f", convertedAmount)
        }
        
        // 계산기 상태 초기화
        currentOperation = nil
        previousValue = nil
        shouldResetDisplay = true  // 새로운 입력이 기존 값을 대체하도록 설정
    }
}

// MARK: - View Extensions

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#Preview {
    ContentView()
}
