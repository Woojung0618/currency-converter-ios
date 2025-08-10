import SwiftUI

struct CalculatorView: View {
    @Binding var displayValue: String
    @Binding var currentOperation: String?
    @Binding var previousValue: Double?
    @Binding var shouldResetDisplay: Bool
    
    let onNumberTapped: (String) -> Void
    let onOperationTapped: (String) -> Void
    let onClear: () -> Void
    let onDelete: () -> Void
    let onSwap: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            // 상단 버튼들
            HStack(spacing: 12) {
                CalculatorButton(title: "C", backgroundColor: .gray) {
                    onClear()
                }
                
                CalculatorButton(title: "", backgroundColor: .gray) {
                    onDelete()
                } content: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.white)
                }
                
                CalculatorButton(title: "", backgroundColor: .gray) {
                    onSwap()
                } content: {
                    Image(systemName: "arrow.up.arrow.down")
                        .foregroundColor(.white)
                }
                
                CalculatorButton(title: "÷", backgroundColor: .orange) {
                    onOperationTapped("÷")
                }
            }
            
            // 숫자 키패드
            HStack(spacing: 12) {
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        CalculatorButton(title: "7") {
                            onNumberTapped("7")
                        }
                        CalculatorButton(title: "8") {
                            onNumberTapped("8")
                        }
                        CalculatorButton(title: "9") {
                            onNumberTapped("9")
                        }
                    }
                    
                    HStack(spacing: 12) {
                        CalculatorButton(title: "4") {
                            onNumberTapped("4")
                        }
                        CalculatorButton(title: "5") {
                            onNumberTapped("5")
                        }
                        CalculatorButton(title: "6") {
                            onNumberTapped("6")
                        }
                    }
                    
                    HStack(spacing: 12) {
                        CalculatorButton(title: "1") {
                            onNumberTapped("1")
                        }
                        CalculatorButton(title: "2") {
                            onNumberTapped("2")
                        }
                        CalculatorButton(title: "3") {
                            onNumberTapped("3")
                        }
                    }
                    
                    HStack(spacing: 12) {
                        CalculatorButton(title: "0") {
                            onNumberTapped("0")
                        }
                        CalculatorButton(title: ".") {
                            onNumberTapped(".")
                        }
                        CalculatorButton(title: "%") {
                            onOperationTapped("%")
                        }
                    }
                }
                
                // 오른쪽 연산자 버튼들
                VStack(spacing: 12) {
                    CalculatorButton(title: "×", backgroundColor: .orange) {
                        onOperationTapped("×")
                    }
                    
                    CalculatorButton(title: "-", backgroundColor: .orange) {
                        onOperationTapped("-")
                    }
                    
                    CalculatorButton(title: "+", backgroundColor: .orange) {
                        onOperationTapped("+")
                    }
                    
                    CalculatorButton(title: "=", backgroundColor: .orange) {
                        onOperationTapped("=")
                    }
                }
            }
        }
        .padding()
    }
}

struct CalculatorButton: View {
    let title: String
    let backgroundColor: Color
    let action: () -> Void
    let customContent: AnyView?
    
    init(title: String, backgroundColor: Color = Color(.systemGray4), action: @escaping () -> Void) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.action = action
        self.customContent = nil
    }
    
    init<Content: View>(title: String, backgroundColor: Color = Color(.systemGray4), action: @escaping () -> Void, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.action = action
        self.customContent = AnyView(content())
    }
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(backgroundColor)
                    .frame(width: 70, height: 70)
                
                if let customContent = customContent {
                    customContent
                } else {
                    Text(title)
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                }
            }
        }
    }
}
