//
//  HomeHandlerInterface.swift
//  HomeHandlerKit
//
//  Created by Buğrahan Efe on 5.08.2024.
//

import CommonKit
import SDWebImage

public protocol HomeHandlerInterface {
    func gameListDetails(request: HomeModuleGameListRequest, completion: @escaping (GameListDetailsResult) -> Void)
}
