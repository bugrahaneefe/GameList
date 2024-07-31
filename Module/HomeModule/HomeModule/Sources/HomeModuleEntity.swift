//
//  HomeModuleEntity.swift
//  HomeModule
//
//  Created by Buğrahan Efe on 31.07.2024.
//

public struct HomeModuleGameListRequest: Encodable {
    let count: Int
    let next: String
    let previous: String
    let results: [Game]
}

public struct Game: Codable {
    struct ESRBRating: Codable {
        let id: Int
        let slug: String
        let name: String
    }
    
    struct PlatformInfo: Codable {
        struct Platform: Codable {
            let id: Int
            let slug: String
            let name: String
        }
        let platform: Platform
        let releasedAt: String
        let requirements: Requirements
    }
    
    struct Requirements: Codable {
        let minimum: String
        let recommended: String
    }
    
    struct Rating: Codable {
        // Define the properties for the Rating struct if needed
    }
    
    struct AddedByStatus: Codable {
        // Define the properties for the AddedByStatus struct if needed
    }
    
    let id: Int
    let slug: String
    let name: String
    let released: String
    let tba: Bool
    let backgroundImage: String
    let rating: Double
    let ratingTop: Int
    let ratings: [String: Rating]
    let ratingsCount: Int
    let reviewsTextCount: String
    let added: Int
    let addedByStatus: [String: AddedByStatus]
    let metacritic: Int
    let playtime: Int
    let suggestionsCount: Int
    let updated: String
    let esrbRating: ESRBRating
    let platforms: [PlatformInfo]
}

public typealias GameListDetailsResult = Result<GameListDetailsResponse, Error>

public struct GameListDetailsResponse: Decodable {
    public let games: [Game]?
}
