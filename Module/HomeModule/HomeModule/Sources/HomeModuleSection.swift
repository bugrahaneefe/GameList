//
//  HomeModuleSection.swift
//  HomeModule
//
//  Created by Buğrahan Efe on 4.08.2024.
//

import Foundation
import ListingKit
import CommonKit
import CommonViewsKit
import CoreUtils
import UIKit

private enum Constant {
    static let gameSectionIdentifier = "GameCell"
    static let cellHorizontalMargins = 30.0
    static let headerReusableViewHeight = 48.0
    static let lineSpacing = 10.0
    enum GameCell {
        static let height = 187.0
        static let appereanceIcon = "GameAppearance"
    }
}

protocol HomeModuleSectionDelegate: AnyObject {
    func gameSelected(_ game: Game)
}

protocol HomeModuleHeaderCollectionReusablePresenterDelegate: AnyObject {
    func changeAppearanceTapped()
}

class GameSection: ListSection {
    var context: ListContext?
    var items: [ListIdentifiable] {
        games
    }
    let listIdentifier: String = Constant.gameSectionIdentifier

    private var games: [Game] = []

    init(games: [Game]) {
        self.games = games
    }

    func cell(for itemIdentifier: String, at indexPath: IndexPath) -> UICollectionViewCell? {
        guard
            let item = games.first(where: { $0.listIdentifier == itemIdentifier }),
            let cell: GameCell = dequeueCell(at: indexPath)
        else { return nil }

        cell.presenter = GameCellPresenter(
            view: cell,
            argument: .init(game: item))

        return cell
    }

    func size(at indexPath: IndexPath) -> CGSize {
        guard let identifier = context?.itemIdentifier(at: indexPath),
              let gameItem = games.first(where: { $0.listIdentifier == identifier })
        else { return .zero }

        return CGSize(
            width: listSize.width - Constant.cellHorizontalMargins,
            height: Constant.GameCell.height
        )
    }
}
