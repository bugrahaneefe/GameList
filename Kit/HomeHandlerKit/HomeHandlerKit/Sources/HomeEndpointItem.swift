//
//  HomeEndpointItem.swift
//  HomeHandlerKit
//
//  Created by Buğrahan Efe on 6.08.2024.
//

import CommonKit
import Foundation

public enum HomeEndpointItem: Endpoint {
    case gameListDetails(at: Int?, contains: String, with: String?)

    public var url: URL? {
        switch self {
        case .gameListDetails(let page, let name, let platform):
            return buildGameListURL(at: page, contains: name, with: platform)
        }
    }

    private func buildGameListURL(at page: Int?, contains name: String, with platform: String?) -> URL? {
        var components = URLComponents(string: "https://api.rawg.io/api/games")
        
        var queryItems = [
            URLQueryItem(name: "key", value: "3fde07e2662c4bde9425cd8d2b901d1b"),
            URLQueryItem(name: "page_size", value: "\(8)"),
            URLQueryItem(name: "search", value: name)
        ]
        
        if let page {
            queryItems.append(URLQueryItem(name: "page", value: "\(page)"))
        }
        
        if let platform {
            queryItems.append(URLQueryItem(name: "parent_platforms", value: platform))
        }
        
        components?.queryItems = queryItems
        return components?.url
    }
}
