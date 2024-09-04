//
//  HomeEndpointItem.swift
//  HomeHandlerKit
//
//  Created by Buğrahan Efe on 6.08.2024.
//

import CommonKit
import Foundation

public enum HomeEndpointItem: Endpoint {
    case gameListDetails(at: Int, contains: String)

    public var url: URL? {
        switch self {
        case .gameListDetails(let page, let name):
            return buildGameListURL(at: page, contains: name)
        }
    }

    private func buildGameListURL(at page: Int?, contains name: String ) -> URL? {
        var components = URLComponents(string: "https://api.rawg.io/api/games")
        components?.queryItems = [
            URLQueryItem(name: "key", value: "2728bd542342447cbf3dccb350fb91da"),
            URLQueryItem(name: "page", value: page.flatMap { "\($0)" }),
            URLQueryItem(name: "page_size", value: "\(8)"),
            URLQueryItem(name: "search", value: name)
        ]
        
        return components?.url
    }
}
