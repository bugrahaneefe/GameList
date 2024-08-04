//
//  HomeModuleEntity.swift
//  HomeModule
//
//  Created by Buğrahan Efe on 31.07.2024.
//

//  HomeModuleEntity.swift
//  HomeModule

import Foundation
import ListingKit

public struct HomeModuleGameListRequest: Encodable {
    public let count: Int
    public let next: String
    public let previous: String
    public let results: [Game]
    
    public init(count: Int, next: String, previous: String, results: [Game]) {
        self.count = count
        self.next = next
        self.previous = previous
        self.results = results
    }
}

public struct Game: Codable, ListIdentifiable {
    public var listIdentifier: String
    
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
        public let releasedAt: String
        public let requirements: Requirements
        
        public init(platform: Platform, releasedAt: String, requirements: Requirements) {
            self.platform = platform
            self.releasedAt = releasedAt
            self.requirements = requirements
        }
    }
    
    public struct Requirements: Codable {
        public let minimum: String
        public let recommended: String
        
        public init(minimum: String, recommended: String) {
            self.minimum = minimum
            self.recommended = recommended
        }
    }
    
    public struct Rating: Codable {
        // Define the properties for the Rating struct if needed
        // Add public initializer if properties are defined
    }
    
    public struct AddedByStatus: Codable {
        // Define the properties for the AddedByStatus struct if needed
        // Add public initializer if properties are defined
    }
    
    public let id: Int
    public let slug: String
    public let name: String
    public let released: String
    public let tba: Bool
    public let backgroundImage: String?
    public let rating: Double
    public let ratingTop: Int
    public let ratings: [String: Rating]
    public let ratingsCount: Int
    public let reviewsTextCount: String
    public let added: Int
    public let addedByStatus: [String: AddedByStatus]
    public let metacritic: Int
    public let playtime: Int
    public let suggestionsCount: Int
    public let updated: String
    public let esrbRating: ESRBRating
    public let platforms: [PlatformInfo]
    
    init(listIdentifier: String, id: Int, slug: String, name: String, released: String, tba: Bool, backgroundImage: String, rating: Double, ratingTop: Int, ratings: [String : Rating], ratingsCount: Int, reviewsTextCount: String, added: Int, addedByStatus: [String : AddedByStatus], metacritic: Int, playtime: Int, suggestionsCount: Int, updated: String, esrbRating: ESRBRating, platforms: [PlatformInfo]) {
        self.listIdentifier = listIdentifier
        self.id = id
        self.slug = slug
        self.name = name
        self.released = released
        self.tba = tba
        self.backgroundImage = backgroundImage
        self.rating = rating
        self.ratingTop = ratingTop
        self.ratings = ratings
        self.ratingsCount = ratingsCount
        self.reviewsTextCount = reviewsTextCount
        self.added = added
        self.addedByStatus = addedByStatus
        self.metacritic = metacritic
        self.playtime = playtime
        self.suggestionsCount = suggestionsCount
        self.updated = updated
        self.esrbRating = esrbRating
        self.platforms = platforms
    }
}

public typealias GameListDetailsResult = Result<GameListDetailsResponse, Error>

public struct GameListDetailsResponse: Decodable {
    public let games: [Game]?
    
    public init(games: [Game]?) {
        self.games = games
    }
}
