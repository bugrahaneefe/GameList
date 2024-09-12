//
//  GameDetailEntity.swift
//  CommonKit
//
//  Created by Buğrahan Efe on 11.09.2024.
//

import Foundation

public typealias GameDetailResult = Result<GameDetailResponse, Error>

public struct GameDetailResponse: Codable {
    public let id: Int
    public let slug: String
    public let name: String
    public let name_original: String?
    public let description: String?
    public let metacritic: Int?
    public let metacritic_platforms: [MetacriticPlatform]?
    public let released: String?
    public let tba: Bool?
    public let updated: String?
    public let background_image: String?
    public let background_image_additional: String?
    public let website: String?
    public let rating: Double?
    public let rating_top: Int?
    public let ratings: [Rating]?
    public let reactions: [String: Int]?
    public let added: Int?
    public let added_by_status: AddedByStatus?
    public let playtime: Int?
    public let screenshots_count: Int?
    public let movies_count: Int?
    public let creators_count: Int?
    public let achievements_count: Int?
    public let parent_achievements_count: Int?
    public let reddit_url: String?
    public let reddit_name: String?
    public let reddit_description: String?
    public let reddit_logo: String?
    public let reddit_count: Int?
    public let twitch_count: Int?
    public let youtube_count: Int?
    public let reviews_text_count: Int?
    public let ratings_count: Int?
    public let suggestions_count: Int?
    public let alternative_names: [String]?
    public let metacritic_url: String?
    public let parents_count: Int?
    public let additions_count: Int?
    public let game_series_count: Int?
    public let esrb_rating: ESRBRating?
    public let platforms: [Platform]?
    
    public struct MetacriticPlatform: Codable {
        public let metascore: Int?
        public let url: String?
    }
    
    public struct ESRBRating: Codable {
        public let id: Int?
        public let slug: String?
        public let name: String?
    }
    
    public struct Rating: Codable {
        public let id: Int
        public let title: String
        public let count: Int
        public let percent: Double
    }
    
    public struct AddedByStatus: Codable {
        public let yet: Int?
        public let owned: Int?
        public let beaten: Int?
        public let toplay: Int?
        public let dropped: Int?
        public let playing: Int?
    }
    
    public struct Platform: Codable {
        public let platform: PlatformDetails?
        public let released_at: String?
        public let requirements: Requirements?
    }
    
    public struct PlatformDetails: Codable {
        public let id: Int?
        public let name: String?
        public let slug: String?
    }
    
    public struct Requirements: Codable {
        public let minimum: String?
    }
}

