import SwiftUI

struct CurrencySelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedCurrency: Currency
    @State private var searchText = ""
    
    var filteredCurrencies: [Currency] {
        if searchText.isEmpty {
            return Currency.allCurrencies
        } else {
            return Currency.allCurrencies.filter { currency in
                currency.name.localizedCaseInsensitiveContains(searchText) ||
                currency.code.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 검색바
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("검색", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                
                // 통화 목록
                List(filteredCurrencies) { currency in
                    HStack {
                        Text(currency.flag)
                            .font(.title2)
                        
                        VStack(alignment: .leading) {
                            Text(currency.name)
                                .font(.body)
                                .foregroundColor(.primary)
                            Text(currency.code)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedCurrency = currency
                        dismiss()
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("통화")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.orange)
                    }
                }
            }
        }
    }
}
