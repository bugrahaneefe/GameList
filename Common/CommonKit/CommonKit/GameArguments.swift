//
//  GameArguments.swift
//  CommonKit
//
//  Created by Buğrahan Efe on 4.08.2024.
//

import Foundation

public final class GameCellArgument {
    public let game: Game
    @Published public var isFavored: Bool = false
    
    public init(game: Game) {
        self.game = game
    }
}
