//
//  HomeEndpointItem.swift
//  HomeHandlerKit
//
//  Created by Buğrahan Efe on 6.08.2024.
//

import CommonKit
import Foundation

public enum HomeEndpointItem: Endpoint {
    case gameListDetails(at: Int)

    public var url: URL? {
        switch self {
        case .gameListDetails(let page):
            return buildGameListURL(at: page)
        }
    }

    private func buildGameListURL(at page: Int?) -> URL? {
        var components = URLComponents(string: "https://api.rawg.io/api/games")
        components?.queryItems = [
            URLQueryItem(name: "key", value: "2728bd542342447cbf3dccb350fb91da"),
            URLQueryItem(name: "page", value: page.flatMap { "\($0)" }),
            URLQueryItem(name: "page_size", value: "\(8)")
        ]
        
        return components?.url
    }
}
