# 환율변환기 iOS 앱

한국수출입은행 API를 사용한 실시간 환율변환기 iOS 앱입니다.

## 🚀 주요 기능

- **실시간 환율**: 한국수출입은행 공식 환율 데이터 사용
- **35개 통화 지원**: 주요 통화(USD, EUR, JPY, CNY, GBP, HKD, SGD, AUD, CAD, CHF, NZD), 아시아 통화(TWD, THB, MYR, IDR, PHP, VND), 중동 통화(AED, SAR, KWD, BHD), 유럽 통화(SEK, NOK, DKK), 기타 통화(RUB, XOF), 폐지된 통화(ATS, BEF, DEM, ESP, FIM, FRF, ITL, NLG)
- **계산기 기능**: 완전한 계산기 키패드로 금액 입력
- **통화 교체**: 상단/하단 교체 버튼으로 직관적인 통화 변경
- **한국어 지원**: 모든 UI가 한국어로 표시

## 📱 스크린샷

- 상단 통화 선택 및 교체 버튼
- 실시간 환율 변환 표시
- 계산기 키패드
- 하단 정보 영역 (새로고침, 날짜, 환율 정보)

## 🔧 설정 방법

### 1. API 키 발급
1. [한국수출입은행 API](https://www.koreaexim.go.kr/ir/HPHKIR020M01?apino=2&viewtype=C&searchselect=&searchword=) 접속
2. API 키 발급 신청
3. 발급받은 API 키 복사

### 2. API 키 설정
1. `Config.example.swift` 파일을 참고하여 `Config.swift` 파일 생성
2. `Config.swift`에서 `YOUR_ACTUAL_API_KEY_HERE`를 실제 API 키로 교체

```swift
static let koreaEximApiKey = "실제_API_키_입력"
```

### 3. 앱 실행
1. Xcode에서 프로젝트 열기
2. 시뮬레이터 또는 실제 기기에서 실행

## 📁 프로젝트 구조

```
currency-converter-app/
├── ContentView.swift          # 메인 화면
├── ExchangeRateService.swift  # 환율 API 서비스
├── Currency.swift            # 통화 데이터 모델
├── CurrencySelectionView.swift # 통화 선택 화면
├── CalculatorView.swift      # 계산기 뷰
├── Config.swift              # 설정 파일 (Git 제외)
├── Config.example.swift      # 설정 예시
└── README.md                 # 프로젝트 설명
```

## 🔒 보안

- `Config.swift` 파일은 `.gitignore`에 포함되어 Git에 업로드되지 않습니다
- API 키는 로컬에서만 관리되며, 원격 저장소에 노출되지 않습니다

## 🛠 기술 스택

- **SwiftUI**: UI 프레임워크
- **Combine**: 비동기 데이터 처리
- **URLSession**: 네트워크 통신
- **한국수출입은행 API**: 환율 데이터

## 📄 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다.

## 🤝 기여

버그 리포트나 기능 제안은 이슈를 통해 제출해 주세요.
