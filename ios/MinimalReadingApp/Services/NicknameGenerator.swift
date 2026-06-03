import Foundation

/// Generates a default nickname as "형용사 + 명사" (adjective + noun), e.g.
/// "철학적인 니체".
///
/// NOTE: the canonical word lists live in Notion but that page isn't accessible
/// to this integration, so these are stand-in lists matching the example
/// pattern. Replace `adjectives` / `nouns` with the real lists when available.
enum NicknameGenerator {

    static let adjectives = [
        "철학적인", "사색하는", "차분한", "느긋한", "깊이있는", "다정한",
        "호기심많은", "우아한", "성실한", "발랄한", "진중한", "따뜻한",
        "섬세한", "용감한", "자유로운", "신비로운", "영리한", "꾸준한",
        "단단한", "잔잔한",
    ]

    static let nouns = [
        "니체", "소크라테스", "플라톤", "칸트", "데카르트", "헤겔",
        "톨스토이", "도스토옙스키", "헤밍웨이", "카뮈", "사르트르", "보르헤스",
        "카프카", "괴테", "헤세", "울프", "디킨슨", "릴케", "호메로스", "단테",
    ]

    /// Returns a random "형용사 명사" nickname (space-separated).
    static func random() -> String {
        let adjective = adjectives.randomElement() ?? "철학적인"
        let noun = nouns.randomElement() ?? "니체"
        return "\(adjective) \(noun)"
    }
}
