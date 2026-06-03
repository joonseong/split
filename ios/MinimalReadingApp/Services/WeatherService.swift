import Foundation
import Observation

/// Weather conditions we map the greeting copy + icon to.
enum WeatherCondition: String, CaseIterable {
    case clear, cloudy, overcast, rain, sleet, snow

    /// Weather-specific lead line (shown after "{nickname}님,", with the icon).
    var lead: String {
        switch self {
        case .clear:    return "맑은 햇살과 함께"
        case .cloudy:   return "구름 사이 햇살과 함께"
        case .overcast: return "흐린 하늘 아래에서"
        case .rain:     return "잔잔한 비 소리와 함께"
        case .sleet:    return "진눈깨비 흩날리는 날"
        case .snow:     return "포근한 눈을 바라보며"
        }
    }

    /// Constant closing line.
    var closing: String { "책 한 시리즈 읽어보세요" }

    /// Custom icon asset name (user-provided later). `rain` uses the existing
    /// `ic_rain`; others fall back to an SF Symbol until assets arrive.
    var assetName: String { self == .rain ? "ic_rain" : "ic_weather_\(rawValue)" }

    var sfSymbol: String {
        switch self {
        case .clear:    return "sun.max.fill"
        case .cloudy:   return "cloud.sun.fill"
        case .overcast: return "cloud.fill"
        case .rain:     return "cloud.rain.fill"
        case .sleet:    return "cloud.sleet.fill"
        case .snow:     return "snowflake"
        }
    }
}

/// Observable weather state for the home greeting.
@Observable
final class WeatherViewModel {
    var condition: WeatherCondition = .clear

    @MainActor
    func refresh() async {
        if let condition = await WeatherService.currentCondition() {
            self.condition = condition
        }
    }
}

/// Fetches the current condition from the KMA (기상청) 초단기예보 public API.
///
/// Setup: paste your data.go.kr service key (일반 인증키, Encoding) into
/// `serviceKey` or add it as `KMAServiceKey` in Info.plist. Without a key the
/// home greeting falls back to `.clear`. Grid defaults to Seoul (nx 60, ny 127);
/// wire CoreLocation later for the device's real location.
enum WeatherService {
    static let serviceKey = "" // TODO: data.go.kr 일반 인증키(Encoding) 입력
    static let nx = 60
    static let ny = 127

    static func currentCondition() async -> WeatherCondition? {
        let key = resolvedKey
        guard !key.isEmpty, let url = makeURL(key: key) else { return nil }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return parse(data)
        } catch {
            return nil
        }
    }

    private static var resolvedKey: String {
        if let key = Bundle.main.object(forInfoDictionaryKey: "KMAServiceKey") as? String,
           !key.isEmpty {
            return key
        }
        return serviceKey
    }

    private static func makeURL(key: String) -> URL? {
        let (date, time) = baseDateTime()
        // Build the string directly so an already-encoded service key isn't
        // double-encoded by URLComponents.
        let base = "https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtFcst"
        let query = "serviceKey=\(key)&dataType=JSON&numOfRows=60&pageNo=1"
            + "&base_date=\(date)&base_time=\(time)&nx=\(nx)&ny=\(ny)"
        return URL(string: "\(base)?\(query)")
    }

    /// Ultra-short forecast base times are issued at HH30 and available ~45 min
    /// later; before HH45 use the previous hour.
    static func baseDateTime(now: Date = Date()) -> (date: String, time: String) {
        let calendar = Calendar(identifier: .gregorian)
        let minute = calendar.component(.minute, from: now)
        let reference = minute < 45 ? (calendar.date(byAdding: .hour, value: -1, to: now) ?? now) : now

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyyMMdd"
        let hourFormatter = DateFormatter()
        hourFormatter.locale = Locale(identifier: "en_US_POSIX")
        hourFormatter.dateFormat = "HH"

        return (dateFormatter.string(from: reference), hourFormatter.string(from: reference) + "30")
    }

    static func parse(_ data: Data) -> WeatherCondition? {
        guard let response = try? JSONDecoder().decode(KMAResponse.self, from: data),
              let items = response.response.body?.items?.item, !items.isEmpty else {
            return nil
        }
        let sorted = items.sorted { ($0.fcstDate + $0.fcstTime) < ($1.fcstDate + $1.fcstTime) }
        guard let firstKey = sorted.first.map({ $0.fcstDate + $0.fcstTime }) else { return nil }
        let group = sorted.filter { $0.fcstDate + $0.fcstTime == firstKey }
        let pty = group.first { $0.category == "PTY" }?.fcstValue
        let sky = group.first { $0.category == "SKY" }?.fcstValue
        return condition(pty: pty, sky: sky)
    }

    /// Maps KMA codes to a condition. PTY: 1/5 rain, 2/6 sleet, 3/7 snow, 0 none.
    /// SKY: 1 clear, 3 cloudy, 4 overcast.
    static func condition(pty: String?, sky: String?) -> WeatherCondition {
        switch pty {
        case "1", "5": return .rain
        case "2", "6": return .sleet
        case "3", "7": return .snow
        default: break
        }
        switch sky {
        case "1": return .clear
        case "3": return .cloudy
        case "4": return .overcast
        default: return .clear
        }
    }

    private struct KMAResponse: Decodable {
        struct Response: Decodable { let body: Body? }
        struct Body: Decodable { let items: Items? }
        struct Items: Decodable { let item: [Item]? }
        struct Item: Decodable {
            let category: String
            let fcstDate: String
            let fcstTime: String
            let fcstValue: String
        }
        let response: Response
    }
}
