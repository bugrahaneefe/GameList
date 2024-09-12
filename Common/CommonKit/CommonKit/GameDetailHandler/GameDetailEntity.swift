//
//  GameDetailEntity.swift
//  CommonKit
//
//  Created by Buğrahan Efe on 11.09.2024.
//

import Foundation

public typealias GameDetailResult = Result<GameDetailResponse, Error>

public struct GameDetailResponse: Codable {
    let id: Int
    let slug: String
    let name: String
    let name_original: String?
    let description: String?
    let metacritic: Int?
    let metacritic_platforms: [MetacriticPlatform]?
    let released: String?
    let tba: Bool?
    let updated: String?
    let background_image: String?
    let background_image_additional: String?
    let website: String?
    let rating: Double?
    let rating_top: Int?
    let ratings: [Rating]?
    let reactions: [String: Int]?
    let added: Int?
    let added_by_status: AddedByStatus?
    let playtime: Int?
    let screenshots_count: Int?
    let movies_count: Int?
    let creators_count: Int?
    let achievements_count: Int?
    let parent_achievements_count: Int?
    let reddit_url: String?
    let reddit_name: String?
    let reddit_description: String?
    let reddit_logo: String?
    let reddit_count: Int?
    let twitch_count: Int?
    let youtube_count: Int?
    let reviews_text_count: Int?
    let ratings_count: Int?
    let suggestions_count: Int?
    let alternative_names: [String]?
    let metacritic_url: String?
    let parents_count: Int?
    let additions_count: Int?
    let game_series_count: Int?
    let esrb_rating: ESRBRating?
    let platforms: [Platform]?
    
    struct MetacriticPlatform: Codable {
        let metascore: Int?
        let url: String?
    }
    
    struct ESRBRating: Codable {
        let id: Int?
        let slug: String?
        let name: String?
    }
    
    struct Rating: Codable {
        public let id: Int
        public let title: String
        public let count: Int
        public let percent: Double
    }
    
    struct AddedByStatus: Codable {
        let yet: Int?
        let owned: Int?
        let beaten: Int?
        let toplay: Int?
        let dropped: Int?
        let playing: Int?
    }
    
    struct Platform: Codable {
        let platform: PlatformDetails?
        let released_at: String?
        let requirements: Requirements?
    }
    
    struct PlatformDetails: Codable {
        let id: Int?
        let name: String?
        let slug: String?
    }
    
    struct Requirements: Codable {
        let minimum: String?
    }
}

