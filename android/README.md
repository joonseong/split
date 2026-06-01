# Android 앱 (예정)

Android 앱은 **Kotlin**으로 개발합니다. iOS 앱을 먼저 완성한 뒤 착수할
예정이라 현재는 자리표시자만 두었습니다.

## 계획 (초안)

- 언어/UI: Kotlin + Jetpack Compose
- iOS와 동일한 도메인 규칙 공유 (`ReadingConfig`에 대응)
  - 페이지당 약 220자
  - 시리즈당 10페이지
  - 하루 3개 시리즈 제한
- iOS의 `Paginator` / `LibraryStore`에 대응하는 분할기·상태 저장소 구현

iOS 구현이 안정되면 이 문서를 실제 모듈 구조로 채웁니다.
