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
        var components = URLComponents(string: APIConstants.BaseUrl + "\(id)")
        components?.queryItems = [
            URLQueryItem(name: APIConstants.Queries.Key, value: APIConstants.Key),
        ]
        
        return components?.url
    }
}
