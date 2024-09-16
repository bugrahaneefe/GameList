//
//  WishlistModuleInteractor.swift
//  WishlistModule
//
//  Created by Buğrahan Efe on 16.09.2024.
//

import CommonKit
import Foundation
import GameDetailHandlerKit
import NetworkKit
import HomeHandlerKit

protocol WishlistInteractorInterface: AnyObject {
    func fetchWishlist(with: URL?, at page: Int, contains name: String, with platforms: String)
}

protocol WishlistInteractorOutput: AnyObject {
    func handleWishlistResult(_ result: GameListDetailsResult)
}

final class WishlistInteractor {
    weak var output: WishlistInteractorOutput?
}

//MARK: - WishlistInteractorInterface
extension WishlistInteractor: WishlistInteractorInterface {
    func fetchWishlist(with: URL?, at page: Int, contains name: String, with platforms: String) {
        HomeHandler.shared.gameListDetails(at: page, contains: name, with: platforms) { [weak output] result in
            output?.handleWishlistResult(result)
        }
    }
}
