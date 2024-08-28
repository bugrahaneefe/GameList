//
//  HomeModuleSection.swift
//  HomeModule
//
//  Created by Buğrahan Efe on 4.08.2024.
//

import CommonKit
import CommonViewsKit
import CoreUtils
import UIKit

private enum Constant {
    enum GameCell {
        static let cellCornerRadius = 10.0
    }
    
    enum CollectionView {
        static let leftInset: CGFloat = 15
        static let rightInset: CGFloat = 15
        static let bottomInset: CGFloat = 15
        static let topInset: CGFloat = 0
        static let logoCellWidth: CGFloat = 165
        static let logoCellHeight: CGFloat = 184
        static let bannerCellWidth: CGFloat = 345
        static let bannerCellHeight: CGFloat = 257
    }
}

protocol HomeModuleSectionDelegate: AnyObject {}

protocol HomeModuleHeaderCollectionReusablePresenterDelegate: AnyObject {
    func changeAppearanceTapped()
}

class GameSection {
    private var games: [Game]
    private weak var delegate: HomeModuleSectionDelegate?
    
    init(games: [Game], delegate: HomeModuleSectionDelegate?) {
        self.games = games
        self.delegate = delegate
    }
    
    func numberOfItems() -> Int {
        return games.count
    }
    
    func configureCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: GameCell.self, for: indexPath)
        let game = games[indexPath.row]
        let argument = GameCellArgument(game: game)
        let presenter = GameCellPresenter(view: cell, argument: argument)
        cell.layer.cornerRadius = Constant.GameCell.cellCornerRadius
        cell.presenter = presenter
        return cell
    }
}
