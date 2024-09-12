//
//  HomeModuleEntity.swift
//  HomeModule
//
//  Created by Buğrahan Efe on 31.07.2024.
//

//  HomeModuleEntity.swift
//  HomeModule

import Foundation

public struct Game: Codable {
    public struct ESRBRating: Codable {
        public let id: Int
        public let slug: String
        public let name: String
        
        public init(id: Int, slug: String, name: String) {
            self.id = id
            self.slug = slug
            self.name = name
        }
    }
    
    public struct PlatformInfo: Codable {
        public struct Platform: Codable {
            public let id: Int
            public let slug: String
            public let name: String
            
            public init(id: Int, slug: String, name: String) {
                self.id = id
                self.slug = slug
                self.name = name
            }
        }
        public let platform: Platform
        public let released_at: String?
        public let requirements: Requirements?
        
        public init(platform: Platform, released_at: String?, requirements: Requirements?) {
            self.platform = platform
            self.released_at = released_at
            self.requirements = requirements
        }
    }
    
    public struct Requirements: Codable {
        public let minimum: String?
        public let recommended: String?
        
        public init(minimum: String?, recommended: String?) {
            self.minimum = minimum
            self.recommended = recommended
        }
    }
    
    public struct Rating: Codable {
        public let id: Int
        public let title: String
        public let count: Int
        public let percent: Double
        
        public init(id: Int, title: String, count: Int, percent: Double) {
            self.id = id
            self.title = title
            self.count = count
            self.percent = percent
        }
    }
    
    public struct AddedByStatus: Codable {
        public let yet: Int?
        public let owned: Int?
        public let beaten: Int?
        public let toplay: Int?
        public let dropped: Int?
        public let playing: Int?
        
        public init(yet: Int?, owned: Int?, beaten: Int?, toplay: Int?, dropped: Int?, playing: Int?) {
            self.yet = yet
            self.owned = owned
            self.beaten = beaten
            self.toplay = toplay
            self.dropped = dropped
            self.playing = playing
        }
    }
    
    public let id: Int?
    public let slug: String
    public let name: String?
    public let released: String?
    public let tba: Bool
    public let background_image: String?
    public let rating: Double
    public let rating_top: Int?
    public let ratings: [Rating]?
    public let ratings_count: Int?
    public let reviews_text_count: Int?
    public let added: Int?
    public let added_by_status: AddedByStatus?
    public let metacritic: Int?
    public let playtime: Int?
    public let suggestions_count: Int?
    public let updated: String?
    public let esrb_rating: ESRBRating?
    public let platforms: [PlatformInfo]?
    
    public init(id: Int?, slug: String, name: String, released: String?, tba: Bool, background_image: String?, rating: Double, rating_top: Int?, ratings: [Rating]?, ratings_count: Int?, reviews_text_count: Int?, added: Int?, added_by_status: AddedByStatus?, metacritic: Int?, playtime: Int?, suggestions_count: Int?, updated: String?, esrb_rating: ESRBRating?, platforms: [PlatformInfo]?) {
        self.id = id
        self.slug = slug
        self.name = name
        self.released = released
        self.tba = tba
        self.background_image = background_image
        self.rating = rating
        self.rating_top = rating_top
        self.ratings = ratings
        self.ratings_count = ratings_count
        self.reviews_text_count = reviews_text_count
        self.added = added
        self.added_by_status = added_by_status
        self.metacritic = metacritic
        self.playtime = playtime
        self.suggestions_count = suggestions_count
        self.updated = updated
        self.esrb_rating = esrb_rating
        self.platforms = platforms
    }
}

public typealias GameListDetailsResult = Result<GameListDetailsResponse, Error>

public struct GameListDetailsResponse: Decodable {
    public let count: Int
    public let next: String?
    public let previous: String?
    public let results: [Game]
    
    public init(count: Int, next: String?, previous: String?, results: [Game]) {
        self.count = count
        self.next = next
        self.previous = previous
        self.results = results
    }
}
