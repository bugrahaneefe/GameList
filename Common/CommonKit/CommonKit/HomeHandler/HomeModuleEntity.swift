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

public struct HomeModuleGameListRequest: Decodable {
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

public struct Game: Codable, ListIdentifiable {
    public var listIdentifier: String {
        return String(id)
    }

    public let id: Int
    public let slug: String
    public let name: String
    public let released: String
    public let tba: Bool
    public let backgroundImage: String?
    public let rating: Double
    public let ratingTop: Int
    public let ratings: [Rating]
    public let ratingsCount: Int
    public let reviewsTextCount: Int
    public let added: Int
    public let addedByStatus: AddedByStatus
    public let metacritic: Int?
    public let playtime: Int
    public let suggestionsCount: Int
    public let updated: String
    public let esrbRating: ESRBRating
    public let platforms: [PlatformInfo]
    
    public struct ESRBRating: Codable {
        public let id: Int
        public let slug: String
        public let name: String
    }

    public struct PlatformInfo: Codable {
        public struct Platform: Codable {
            public let id: Int
            public let slug: String
            public let name: String
        }
        public let platform: Platform
        public let releasedAt: String?
        public let requirementsEn: Requirements?
        public let requirementsRu: Requirements?
    }

    public struct Requirements: Codable {
        public let minimum: String?
        public let recommended: String?
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
}

public typealias GameListDetailsResult = Result<GameListDetailsResponse, Error>

public struct GameListDetailsResponse: Decodable {
    public let count: Int
    public let next: String?
    public let previous: String?
    public let results: [Game]?
    
    public init(count: Int, next: String?, previous: String?, results: [Game]) {
        self.count = count
        self.next = next
        self.previous = previous
        self.results = results
    }
}
