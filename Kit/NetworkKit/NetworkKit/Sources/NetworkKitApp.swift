import CommonKit

public protocol NetworkKitInterface {
    func gameListDetails(request: HomeModuleGameListRequest, completion: @escaping () -> Void)
}

public final class NetworkKit: NetworkKitInterface {
    public static let shared: NetworkKitInterface = NetworkKit()
}

extension NetworkKit {
    public func gameListDetails(request: CommonKit.HomeModuleGameListRequest, completion: @escaping () -> Void) {
        
    }
}
