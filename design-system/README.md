# Design System

MinimalReadingApp의 디자인 시스템입니다. iOS·Android 양쪽에서 공유합니다.

## 구조

```
design-system/
└── tokens/                  # 플랫폼 중립 토큰 (source of truth)
    ├── color.core.json      # core 컬러 팔레트 (원시 컬러)
    ├── color.semantic.json  # semantic 컬러 (역할 기반, core를 참조)
    ├── text.core.json       # 타이포 core (fontsize/lineheight/letterspacing/fontweight)
    ├── text.semantic.json   # 타이포 semantic (Display/Title/Body/Caption/Label/Viewer)
    ├── spacing.json         # 스페이싱 스케일
    └── radius.json          # 코너 radius 스케일
```

플랫폼별 코드는 이 토큰에서 생성/동기화합니다.

- iOS 컬러: `ColorCore.swift` (`Color.Core.*`), `ColorSemantic.swift` (`Color.Semantic.*`)
- iOS 타이포: `TextCore.swift` (`TextCore.*`), `Typography.swift` (`TextStyle` + `.textStyle(_:)`), `TextSemantic.swift` (`TextStyle.display1` 등)
- iOS 스페이싱: `Spacing.swift` (`Spacing.s16` 등)
- iOS radius: `Radius.swift` (`Radius.r12`, `Radius.full` 등)
- (위 Swift 파일은 모두 `ios/MinimalReadingApp/DesignSystem/`)
- Android: (예정) Kotlin/Compose

## 토큰 계층

1. **core (원시 컬러)** — `color.core.*`. 팔레트의 날것 그대로의 색. 기능 코드에서
   직접 쓰지 않습니다. ← *현재 단계*
2. **semantic (의미 컬러)** — `shape`(면), `border`(선), `txt`(텍스트) 등 역할
   기반 토큰. core 값을 참조합니다. iOS에서는 `Color.Semantic.*`로 접근합니다.
   > 디자인 원본에서는 `sys` 네임스페이스였으나, 의미를 명확히 하기 위해
   > `semantic`으로 변경해 적용했습니다.
3. **component** — 컴포넌트별 토큰. (예정)

## 네이밍

`color.core.<group>.<weight>` — 예: `color.core.blue.500`

- group: `gs`(grayscale), `trans`, `red`, `yellow`, `green`, `blue`, `purple`
- weight: 900(가장 진함) → 100/10/0(가장 옅음)

iOS Swift에서는 `Color.Core.blue500` 형태로 접근합니다.
