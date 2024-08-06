//
//  Endpoint.swift
//  CommonKit
//
//  Created by Buğrahan Efe on 6.08.2024.
//

import Foundation

public protocol Endpoint: CustomStringConvertible {
    var baseUrl: String { get }
    var path: String { get }
    var params: [String: Any]? { get }
    var goParams: [String: Any]? { get }
    var allParams: [String: Any]? { get }
    var headers: [String: String] { get }
    var url: String { get }
    var method: HTTPMethod { get }
    var encoding: ParameterEncoding { get }
}

public extension Endpoint {
    
    private func addQueryParameters(to url: String, parameters: [String: String]) -> String {
        guard var urlComponents = URLComponents(string: url) else { return url }
        var queryItems = urlComponents.queryItems ?? []
        for (key, value) in parameters {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        urlComponents.queryItems = queryItems
        return urlComponents.url?.absoluteString ?? url
    }
    
    var params: [String: Any]? {
        nil
    }
    
    var goParams: [String: Any]? {
        guard method == .get else { return nil }

        var params: [String: Any]? = .init()
        return params
    }
    
    var allParams: [String: Any]? {
        if let goParams = goParams {
            guard let requestParams = params else { return goParams }
            return requestParams.merging(goParams) { current, _ in current }
        } else if (method == .post || method == .put) {
            var requestParams = params ?? [:]
            return requestParams
        }
        return params
    }
    
    var url: String {
        var finalUrl = baseUrl + path
        return finalUrl
    }
    
    var headers: [String: String] { [:] }
    
    var description: String {
        var descriptionString = String()
        descriptionString.append(contentsOf: "\nURL: [\(method.rawValue)] \(url)")
        descriptionString.append(contentsOf: "\nHEADERS: \(HTTPHeaders(headers))")
        descriptionString.append(contentsOf: "\nPARAMETERS: \(String(describing: params ?? [:]))")
        return descriptionString
    }
    var encoding: ParameterEncoding {
        return method.defaultEncoding
    }
}
