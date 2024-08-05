import CommonKit
import Alamofire

public protocol NetworkKitInterface {}

public final class NetworkKit {
    public static let shared: NetworkKitInterface = NetworkKit()
    private let interactor: NetworkKitInterface
    
    init(interactor: NetworkKitInterface = NetworkKit()) {
        self.interactor = interactor
    }
}

extension NetworkKit: NetworkKitInterface {
    
    public func gameListDetails(request: HomeModuleGameListRequest, completion: @escaping (GameListDetailsResult) -> Void) {
        
        let parameters: [String: Any] = [
            "count": request.count,
            "next": request.next,
            "previous": request.previous,
            "results": request.results.map { game in
                return [
                    "id": game.id,
                    "slug": game.slug,
                    "name": game.name,
                    "released": game.released,
                    "tba": game.tba,
                    "background_image": game.backgroundImage,
                    "rating": game.rating,
                    "rating_top": game.ratingTop,
                    "ratings": game.ratings, // Assuming ratings is [String: Any]
                    "ratings_count": game.ratingsCount,
                    "reviews_text_count": game.reviewsTextCount,
                    "added": game.added,
                    "added_by_status": game.addedByStatus, // Assuming addedByStatus is [String: Any]
                    "metacritic": game.metacritic,
                    "playtime": game.playtime,
                    "suggestions_count": game.suggestionsCount,
                    "updated": game.updated,
                    "esrb_rating": [
                        "id": game.esrbRating.id,
                        "slug": game.esrbRating.slug,
                        "name": game.esrbRating.name
                    ],
                    "platforms": game.platforms.map { platformInfo in
                        return [
                            "platform": [
                                "id": platformInfo.platform.id,
                                "slug": platformInfo.platform.slug,
                                "name": platformInfo.platform.name
                            ],
                            "released_at": platformInfo.releasedAt,
                            "requirements": [
                                "minimum": platformInfo.requirements.minimum,
                                "recommended": platformInfo.requirements.recommended
                            ]
                        ]
                    }
                ]
            }
        ]
        
        AF.request(HomeHandler.Constant.gameListURL,
                   method: .get,
                   parameters: parameters,
                   encoding: URLEncoding.default)
        .validate()
        .responseDecodable(of: GameListDetailsResponse.self) { response in
            switch response.result {
            case .success(let gameListResponse):
                completion(.success(gameListResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
