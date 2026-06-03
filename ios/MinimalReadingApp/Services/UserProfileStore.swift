import Foundation
import Observation

/// Stores the user's onboarding profile (nickname + favorite genres), persisted
/// to `UserDefaults`. The home screen will read `homeTabs` later.
@Observable
final class UserProfileStore {
    private(set) var nickname: String
    private(set) var selectedGenres: [Genre]

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.nickname = defaults.string(forKey: Keys.nickname) ?? ""
        if let data = defaults.data(forKey: Keys.genres),
           let genres = try? JSONDecoder().decode([Genre].self, from: data) {
            self.selectedGenres = genres
        } else {
            self.selectedGenres = []
        }
    }

    /// Saves the result of onboarding.
    func complete(nickname: String, genres: [Genre]) {
        self.nickname = nickname
        self.selectedGenres = genres
        defaults.set(nickname, forKey: Keys.nickname)
        if let data = try? JSONEncoder().encode(genres) {
            defaults.set(data, forKey: Keys.genres)
        }
    }

    /// Home top tabs: "베스트셀러" first, then the selected genres (leftmost =
    /// selected) in canonical order. When nothing is selected, all genres show
    /// in their canonical (genre-selection page) order.
    var homeTabs: [String] {
        let genres = selectedGenres.isEmpty ? Genre.allCases : selectedGenres
        return ["베스트셀러"] + genres.map(\.title)
    }

    private enum Keys {
        static let nickname = "profile.nickname"
        static let genres = "profile.genres"
    }
}
