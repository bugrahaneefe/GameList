//
//  HTTPMethod.swift
//  CommonKit
//
//  Created by Buğrahan Efe on 6.08.2024.
//

import Foundation
import Alamofire

public typealias HTTPMethod = Alamofire.HTTPMethod
public typealias HTTPHeaders = Alamofire.HTTPHeaders
public typealias HTTPHeader = Alamofire.HTTPHeader

public extension HTTPMethod {
    var defaultEncoding: ParameterEncoding {
        switch self {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
}
