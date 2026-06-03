import Foundation

/// Reading genres offered during onboarding. Declaration order is the canonical
/// order used for the home top tabs (selected genres appear leftmost, right
/// after "베스트셀러", in this order).
enum Genre: String, CaseIterable, Identifiable, Codable {
    case fantasy = "판타지"
    case sf = "SF(과학 소설)"
    case romance = "로맨스"
    case mysteryThriller = "미스터리/스릴러"
    case historical = "역사 소설"
    case classic = "고전 문학"
    case essay = "에세이"
    case selfDevelopment = "자기계발"
    case philosophy = "철학"
    case humanities = "인문학"
    case economyBusiness = "경제/경영"
    case liberalArts = "교양"
    case poetry = "시"
    case drama = "희곡"

    var id: String { rawValue }
    var title: String { rawValue }
}
