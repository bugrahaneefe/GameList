//
//  HomeEndpointItem.swift
//  HomeHandlerKit
//
//  Created by Buğrahan Efe on 6.08.2024.
//

import CommonKit
import Foundation

public enum HomeEndpointItem: Endpoint {
    case gameListDetails(
        at: Int?,
        contains: String,
        with: String?
    )

    public var url: URL? {
        switch self {
        case .gameListDetails(
            let page,
            let name,
            let platform
        ):
            return buildGameListURL(at: page, contains: name, with: platform)
        }
    }

    private func buildGameListURL(
        at page: Int?,
        contains name: String,
        with platform: String?
    ) -> URL? {
        var components = URLComponents(string: APIConstants.BaseUrl)
        var queryItems = [
            URLQueryItem(name: APIConstants.Queries.Key, value: APIConstants.Key),
            URLQueryItem(name: APIConstants.Queries.PageSize, value: "\(8)"),
            URLQueryItem(name: APIConstants.Queries.Search, value: name)
        ]
        
        if let page {
            queryItems.append(URLQueryItem(name: APIConstants.Queries.Page, value: "\(page)"))
        }
        
        if let platform {
            queryItems.append(URLQueryItem(name: APIConstants.Queries.ParentPlatforms, value: platform))
        }
        
        components?.queryItems = queryItems
        return components?.url
    }
}
