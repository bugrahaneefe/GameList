import Foundation
import CommonKit

open class Networker<T: Endpoint> {
    private let networkKit: NetworkKitInterface

    public init(networkKit: NetworkKitInterface = NetworkKit<T>()) {
        self.networkKit = networkKit
    }

    public func request<U: Decodable>(endpoint: T, completion: @escaping (Result<U, Error>) -> Void) {
        networkKit.request(from: endpoint.url, completion: completion)
    }
}
