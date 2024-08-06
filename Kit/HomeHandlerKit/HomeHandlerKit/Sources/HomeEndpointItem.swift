//
//  HomeEndpointItem.swift
//  HomeHandlerKit
//
//  Created by Buğrahan Efe on 6.08.2024.
//

import CoreUtils
import CommonKit

public enum HomeEndpointItem: Endpoint {
    case gameListDetails(request: HomeModuleGameListRequest)

    public var method: HTTPMethod {
        switch self {
        case .gameListDetails: return .get
        }
    }

    public var params: [String : Any]? {
        switch self {
        case .gameListDetails(let request):
            return request.parameters()
        }
    }

    public var encoding: ParameterEncoding {
        switch self {
        default:
            return URLEncoding.default
        }
    }

    public var path: String {
        switch self {
        case .gameListDetails:
            return ""
        }
    }

    public var baseUrl: String {
        switch self {
        case .gameListDetails:
            return "https://api.rawg.io/api/games?key=2728bd542342447cbf3dccb350fb91da"
        }
    }
}
