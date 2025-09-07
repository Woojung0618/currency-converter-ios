# 환율변환기 iOS 앱

S3에서 매일 업데이트되는 한국수출입은행 환율 데이터를 사용한 환율변환기 iOS 앱입니다.

## 🚀 주요 기능

- **일일 업데이트 환율**: S3에 저장된 한국수출입은행 공식 환율 데이터 사용 (매일 오후 1시 업데이트)
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

### 1. 앱 실행
1. Xcode에서 프로젝트 열기
2. 시뮬레이터 또는 실제 기기에서 실행

**참고**: 이제 API 키가 필요하지 않습니다. S3에서 직접 환율 데이터를 가져옵니다.

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

- API 키가 더 이상 필요하지 않으므로 보안 설정이 간소화되었습니다
- S3에서 직접 데이터를 가져오므로 안전합니다

## 🛠 기술 스택

- **SwiftUI**: UI 프레임워크
- **Combine**: 비동기 데이터 처리
- **URLSession**: 네트워크 통신
- **AWS S3**: 환율 데이터 저장소
- **한국수출입은행 데이터**: 환율 데이터 소스

## 📄 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다.

## 🤝 기여

버그 리포트나 기능 제안은 이슈를 통해 제출해 주세요.
