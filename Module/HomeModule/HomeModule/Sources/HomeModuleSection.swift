//
//  HomeModuleSection.swift
//  HomeModule
//
//  Created by Buğrahan Efe on 4.08.2024.
//

import Foundation
import CommonKit
import CommonViewsKit
import CoreUtils
import UIKit

private enum Constant {
    static let gameSectionIdentifier = "GameCell"
    static let cellCornerRadius = 10.0
    enum GameCell {
        static let appereanceIcon = "GameAppearance"
    }
}

protocol HomeModuleSectionDelegate: AnyObject {
    func gameSelected(_ game: Game)
}

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
        cell.layer.cornerRadius = Constant.cellCornerRadius
        cell.presenter = presenter
        return cell
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        delegate?.gameSelected(games[indexPath.row])
    }
}
