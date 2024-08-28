import Alamofire
import CommonKit
import Foundation

public typealias Completion<T> = (Result<T, Error>) -> Void where T: Decodable
public typealias AsyncResult<T> = Result<T, Error> where T: Decodable

public protocol NetworkKitInterface {
    func request<T: Decodable>(from url: URL, completion: @escaping (Result<T, Error>) -> Void)
}

public class EmptyResponse: Codable {
    public init() {}
}

public final class NetworkKit<EndpointItem: Endpoint> {
    public init() {}
}

extension NetworkKit: NetworkKitInterface {
    public func request<T: Decodable>(from url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        AF.request(url).validate().responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
//                debug
//                if let data = response.data {
//                    print("Failed to decode response, raw data: \(String(data: data, encoding: .utf8) ?? "nil")")
//                }
                completion(.failure(error))
            }
        }
    }
}
