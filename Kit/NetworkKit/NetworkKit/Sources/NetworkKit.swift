import Alamofire
import CommonKit
import Foundation

public typealias Completion<T> = (Result<T, Error>) -> Void where T: Decodable
public typealias AsyncResult<T> = Result<T, Error> where T: Decodable

public protocol NetworkKitInterface {
    func request<T: Decodable>(from url: URL, completion: @escaping (Result<T, Error>) -> Void) async
}

public class EmptyResponse: Codable {
    public init() {}
}

public final class NetworkKit<EndpointItem: Endpoint> {
    public init() {}
}

extension NetworkKit: NetworkKitInterface {
    public func request<T: Decodable>(from url: URL, completion: @escaping (Result<T, Error>) -> Void) async {
        AF.request(url).validate(statusCode: 200..<405).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
}
