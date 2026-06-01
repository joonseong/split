# MinimalReadingApp

책 한 권을 잘게 쪼개 **하루에 조금씩** 읽도록 돕는 독서 습관 앱입니다.

## 콘셉트

- 책의 전체 텍스트를 모바일 한 페이지에 **약 220자**씩 잘라냅니다.
- **10페이지**를 하나로 묶어 **"시리즈"(한 화)** 로 제공합니다.
- 사용자는 **하루에 3개 시리즈**까지만 읽을 수 있습니다. (절제된 독서)

이 분할 규칙은 모두 [`ReadingConfig`](ios/MinimalReadingApp/Models/ReadingConfig.swift)
한 곳에서 조정합니다.

## 저장소 구조

```
.
├── ios/        # iOS 앱 (Swift / SwiftUI)  ← 현재 개발 중
├── android/    # Android 앱 (Kotlin)        ← iOS 이후 개발 예정
└── docs/       # 제품/설계 문서
```

먼저 **iOS(Swift)** 앱을 만들고, 그다음 **Android(Kotlin)** 앱을 개발합니다.

## iOS 앱 실행

> 요구사항: macOS + Xcode 16 이상 (iOS 17.0+ 타깃)

```bash
open ios/MinimalReadingApp.xcodeproj
```

Xcode에서 시뮬레이터를 선택하고 **Run (⌘R)** 하면 됩니다.

### iOS 코드 구성

| 영역 | 파일 | 설명 |
| --- | --- | --- |
| 모델 | `Models/Book.swift`, `Series.swift`, `ReadingPage.swift` | 책 → 시리즈 → 페이지 도메인 모델 |
| 설정 | `Models/ReadingConfig.swift` | 220자 / 10페이지 / 하루 3시리즈 |
| 분할 | `Services/Paginator.swift` | 원문을 정리하고 페이지·시리즈로 분할 |
| 상태 | `Services/LibraryStore.swift` | 서재, 진도, 일일 제한 (UserDefaults 영속) |
| 샘플 | `Services/SampleLibrary.swift` | 번들 텍스트를 읽어 샘플 책 생성 |
| 화면 | `Views/` | 서재 → 시리즈 목록 → 리더 |

### 샘플 데이터

`ios/MinimalReadingApp/Resources/memorandum.txt` — *존재하지 않는 것들의 비망록
(A Memorandum of Things That Do Not Exist)* 전문(42챕터, 약 6.7만 자)을 번들에
포함해 두었습니다. 앱은 실행 시 이 텍스트를 220자 페이지로 잘라 약 30개의
시리즈로 보여줍니다.

## Android 앱

iOS 앱을 먼저 완성한 뒤 Kotlin으로 개발할 예정입니다. 자세한 내용은
[`android/README.md`](android/README.md)를 참고하세요.
