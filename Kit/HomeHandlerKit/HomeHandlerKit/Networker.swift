//
//  Networker.swift
//  HomeHandlerKit
//
//  Created by Buğrahan Efe on 6.08.2024.
//

import Foundation
import CommonKit
import NetworkKit

class Networker<T: Endpoint> {
    private let networkKit: NetworkKitInterface

    init(networkKit: NetworkKitInterface = NetworkKit<T>()) {
        self.networkKit = networkKit
    }

    func request<U: Decodable>(endpoint: T, completion: @escaping (Result<U, Error>) -> Void) {
        networkKit.request(from: endpoint.url, completion: completion)
    }
}
