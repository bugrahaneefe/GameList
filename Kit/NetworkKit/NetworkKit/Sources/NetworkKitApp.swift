import Common

public protocol NetworkKitInterface {
    func gameListDetails(request: HomeModuleGameListRequest, completion: @escaping () -> Void)
}

public final class NetworkKit {
    public static let shared: MLFavoriteHandlerInterface = MLFavoriteHandler()
}
