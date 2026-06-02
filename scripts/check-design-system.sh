#!/usr/bin/env bash
#
# check-design-system.sh
# Enforces design-system/RULES.md in component / screen (UI) code.
#
# - Scans Swift files under ios/MinimalReadingApp, EXCLUDING the DesignSystem
#   folder (where core colors and raw values legitimately live).
# - Exits non-zero if any violation is found (used as the CI gate).
# - Add a trailing "// ds-allow: <reason>" comment to a line to intentionally
#   suppress a finding (use sparingly, with a real justification).
#
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCAN_ROOT="${1:-$ROOT/ios/MinimalReadingApp}"
EXCLUDE_DIR="$SCAN_ROOT/DesignSystem"

if [[ ! -d "$SCAN_ROOT" ]]; then
  echo "ℹ️  iOS 소스를 찾지 못했습니다 ($SCAN_ROOT) — 검사를 건너뜁니다."
  exit 0
fi

# Each rule is "<extended-regex>@@@<message>".
# Numeric rules use [1-9] as the first digit so that 0 (= "none") is allowed and
# token names like Spacing.s8 / Radius.r16 are not matched.
RULES=(
  'Color\.Core\.@@@[규칙2] 코어 컬러를 UI에 직접 사용했습니다. Color.Semantic.* 를 사용하세요.'
  'Color\(hex:@@@[규칙1] raw hex 컬러입니다. Color.Semantic.* 를 사용하세요.'
  'Color\(red:@@@[규칙1] raw RGB 컬러입니다. Color.Semantic.* 를 사용하세요.'
  'UIColor\(@@@[규칙1] raw UIColor 입니다. Color.Semantic.* 를 사용하세요.'
  '\.font\(\.system\(@@@[규칙1] 시스템 폰트를 직접 지정했습니다. .textStyle(.body1) 등 text.semantic 토큰을 사용하세요.'
  '\.cornerRadius\([[:space:]]*[1-9]@@@[규칙1] raw cornerRadius 값입니다. Radius.* 를 사용하세요.'
  'cornerRadius:[[:space:]]*[1-9]@@@[규칙1] raw cornerRadius 값입니다. Radius.* 를 사용하세요.'
  '\.padding\([[:space:]]*[1-9]@@@[규칙1] raw padding 값입니다. Spacing.* 를 사용하세요.'
  '\.padding\([[:space:]]*\.[A-Za-z]+,[[:space:]]*[1-9]@@@[규칙1] raw padding 값입니다. Spacing.* 를 사용하세요.'
  'spacing:[[:space:]]*[1-9]@@@[규칙1] raw 스택 spacing 값입니다. Spacing.* 를 사용하세요.'
  '\.lineSpacing\([[:space:]]*[1-9]@@@[규칙1] raw lineSpacing 값입니다. .textStyle 또는 Spacing.* 를 사용하세요.'
)

mapfile -t FILES < <(find "$SCAN_ROOT" -name '*.swift' -not -path "$EXCLUDE_DIR/*" | sort)

violations=0
for rule in "${RULES[@]}"; do
  regex="${rule%%@@@*}"
  message="${rule##*@@@}"
  for file in "${FILES[@]}"; do
    while IFS= read -r match; do
      [[ -z "$match" ]] && continue
      lineno="${match%%:*}"
      content="${match#*:}"
      # Skip intentional, justified suppressions.
      [[ "$content" == *"ds-allow"* ]] && continue
      printf '❌ %s:%s\n   %s\n   > %s\n\n' \
        "${file#"$ROOT"/}" "$lineno" "$message" "$(echo "$content" | sed 's/^[[:space:]]*//')"
      violations=$((violations + 1))
    done < <(grep -nE "$regex" "$file")
  done
done

if [[ "$violations" -gt 0 ]]; then
  echo "💥 디자인 시스템 규칙 위반 ${violations}건. design-system/RULES.md 를 참고하세요."
  exit 1
fi

echo "✅ 디자인 시스템 규칙 통과 (검사한 파일 ${#FILES[@]}개)."
exit 0
