//
//  HomeEndpointItem.swift
//  HomeHandlerKit
//
//  Created by Buğrahan Efe on 6.08.2024.
//

import Foundation
import CoreUtils
import CommonKit

enum HomeEndpointItem: Endpoint {
    case gameListDetails

    var url: URL {
        switch self {
        case .gameListDetails:
            return URL(string: "https://api.rawg.io/api/games?key=2728bd542342447cbf3dccb350fb91da")!
        }
    }

    var method: HTTPMethod {
        switch self {
        case .gameListDetails:
            return .get
        }
    }

    var headers: [String: String]? {
        return nil
    }

    var parameters: [String: Any]? {
        return nil
    }

    var encoding: ParameterEncoding {
        return URLEncoding.default
    }
}
