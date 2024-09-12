//
//  GameDetailEndpointItem.swift
//  GameDetailHandlerKit
//
//  Created by Buğrahan Efe on 11.09.2024.
//

import CommonKit
import Foundation

public enum GameDetailEndpointItem: Endpoint {
    case gameDetails(with: Int)

    public var url: URL? {
        switch self {
        case .gameDetails(let id):
            return buildGameDetailURL(with: id)
        }
    }

    private func buildGameDetailURL(with id: Int) -> URL? {
        var components = URLComponents(string: "https://api.rawg.io/api/games/\(id)")
        components?.queryItems = [
            URLQueryItem(name: "key", value: "3fde07e2662c4bde9425cd8d2b901d1b"),
        ]
        
        return components?.url
    }
}
