# 디자인 시스템 사용 규칙 (Design System Rules)

이 문서는 **강제 규칙**입니다. 컴포넌트/화면을 만들 때 반드시 지켜야 합니다.
(토큰 정의·구조 설명은 [`README.md`](./README.md) 참고)

---

## 규칙 1. 컴포넌트는 반드시 파운데이션 토큰을 사용한다

버튼, 텍스트필드, 카드 등 **모든 컴포넌트와 화면**은 아래 파운데이션 토큰만으로
스타일을 구성해야 합니다. **raw 값(하드코딩)은 금지합니다.**

| 속성 | 사용해야 하는 토큰 | iOS API |
| --- | --- | --- |
| 색상 | `color.semantic.*` | `Color.Semantic.*` |
| 타이포 | `text.semantic.*` | `TextStyle.*` + `.textStyle(_:)` |
| 여백/간격 | `spacing.*` | `Spacing.*` |
| 코너 | `radius.*` | `Radius.*` |

### 금지 (raw 값 하드코딩)

```swift
// ❌ 색상 hex 직접 사용
Color(hex: 0x8A44E3)
Color(red: 0.54, green: 0.27, blue: 0.89)

// ❌ 폰트 크기/굵기 직접 지정
.font(.system(size: 16, weight: .bold))

// ❌ 스페이싱/radius 숫자 직접 입력
.padding(16)
.cornerRadius(12)
```

### 허용 (토큰 사용)

```swift
// ✅ 색상은 semantic 토큰
.foregroundStyle(Color.Semantic.Txt.B.primary)
.background(Color.Semantic.Shape.brand)

// ✅ 타이포는 semantic 텍스트 스타일
Text("제목").textStyle(.title1)

// ✅ 스페이싱 / radius 토큰
.padding(Spacing.s16)
.clipShape(RoundedRectangle(cornerRadius: Radius.r12))
```

> 필요한 값이 토큰에 없으면, 임의로 raw 값을 쓰지 말고 **먼저 토큰을 추가**한 뒤
> 그 토큰을 사용합니다.

---

## 규칙 2. 코어 컬러는 UI에 개별적으로 사용하지 않는다

`color.core.*` (`Color.Core.*`) 는 **팔레트(원시 값)일 뿐**이며, **절대 UI에서
직접 사용해서는 안 됩니다.**

- 코어 컬러는 **오직 `color.semantic.*` 를 정의할 때만** 참조됩니다.
- 컴포넌트·화면 코드에서는 **언제나 `color.semantic.*` 를 통해서만** 색을 씁니다.
- 적절한 의미(semantic) 토큰이 없다면, 코어 컬러를 직접 쓰지 말고
  **semantic 토큰을 새로 정의**해서 사용합니다.

```swift
// ❌ 코어 컬러를 UI에 직접 사용
.background(Color.Core.green500)
.foregroundStyle(Color.Core.gs900)

// ✅ semantic 컬러를 통해 사용
.background(Color.Semantic.Shape.brand)      // -> core.green.500
.foregroundStyle(Color.Semantic.Txt.B.primary) // -> core.gs.900
```

---

## 요약

1. 컴포넌트 = **semantic 컬러 + semantic 타이포 + spacing + radius** 토큰으로만 구성. raw 값 금지.
2. **`Color.Core.*` 는 UI에서 직접 사용 금지.** 반드시 `Color.Semantic.*` 경유.
3. 토큰에 없는 값이 필요하면 → raw 값 사용 ❌ → **토큰부터 추가** ⭕.

---

## 강제 (Enforcement)

이 규칙은 **자동으로 강제**됩니다.

### 1. CI 게이트 (의존성 없음 · 필수)

[`scripts/check-design-system.sh`](../scripts/check-design-system.sh) 가
`ios/MinimalReadingApp` 의 UI 코드(`DesignSystem/` 제외)를 검사합니다.
[GitHub Actions 워크플로](../.github/workflows/design-system-rules.yml)가 push/PR
마다 실행하며, 위반이 있으면 **빌드가 실패**합니다.

로컬에서 직접 실행:

```bash
bash scripts/check-design-system.sh
```

### 2. SwiftLint (로컬 · Xcode, 선택)

[`.swiftlint.yml`](../.swiftlint.yml) 에 동일한 규칙을 커스텀 룰로 정의했습니다.
`swiftlint` 설치 시 에디터에서 즉시 에러로 표시됩니다.

### 검사 항목

| 항목 | 잡아내는 패턴 | 대체 |
| --- | --- | --- |
| 코어 컬러 직접 사용 | `Color.Core.*` | `Color.Semantic.*` |
| raw 컬러 | `Color(hex:`, `Color(red:`, `UIColor(` | `Color.Semantic.*` |
| 시스템 폰트 | `.font(.system(` | `.textStyle(.body1)` 등 |
| raw radius | `cornerRadius: 12`, `.cornerRadius(8)` | `Radius.*` |
| raw 여백 | `.padding(16)`, `.padding(.top, 8)` | `Spacing.*` |
| raw 스택 간격 | `VStack(spacing: 12)` | `Spacing.*` |
| raw lineSpacing | `.lineSpacing(10)` | `.textStyle` / `Spacing.*` |

> `0` 은 "없음"으로 보고 허용합니다(예: `spacing: 0`).
> `.font(.title)` 같은 시스템 Dynamic Type 스타일은 게이트에서 막지 않지만,
> 가능하면 `.textStyle` 사용을 권장합니다.

### 예외 처리 (suppression)

정당한 사유가 있을 때만, 해당 줄 끝에 `// ds-allow: <사유>` 를 붙이면 그 줄은
검사에서 제외됩니다. 남용하지 마세요.

```swift
.padding(.vertical, 3) // ds-allow: 1px 단위 미세 정렬, 토큰 스케일에 없음
```
