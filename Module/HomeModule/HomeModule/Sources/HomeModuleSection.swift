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

class GameSection {
    private var games: [Game]
    private weak var delegate: HomeModuleSectionDelegate?
    
    init(games: [Game], delegate: HomeModuleSectionDelegate?) {
        self.games = games
        self.delegate = delegate
    }
    
    func appendGames(_ newGames: [Game]) {
        games.append(contentsOf: newGames)
    }
    
    func configureCell(for collectionView: UICollectionView, at indexPath: IndexPath, with appearanceType: AppereanceType) -> UICollectionViewCell {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return UICollectionViewCell() }
        layout.sectionInset = UIEdgeInsets(
            top: Constant.CollectionView.topInset,
            left: Constant.CollectionView.leftInset,
            bottom: Constant.CollectionView.bottomInset,
            right: Constant.CollectionView.rightInset
        )
        layout.estimatedItemSize = .zero
        collectionView.backgroundColor = .black
        switch appearanceType {
        case .logo:
            layout.itemSize = CGSize(
                width: Constant.CollectionView.logoCellWidth,
                height: Constant.CollectionView.logoCellHeight)
            return sections.logoSection(games: games, collectionView, indexPath: indexPath)
        case .banner:
            layout.itemSize = CGSize(
                width: Constant.CollectionView.bannerCellWidth,
                height: Constant.CollectionView.bannerCellHeight)
            return sections.bannerSection(games: games, collectionView, indexPath: indexPath)
        }
    }
}

private enum sections {
    static func bannerSection(games: [Game], _ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: GameCellBanner.self, for: indexPath)
        let presenter = GameCellBannerPresenter(view: cell, argument: GameCellArgument(game: games[indexPath.row]))
        cell.layer.cornerRadius = Constant.GameCell.cellCornerRadius
        cell.presenter = presenter
        return cell
    }
    
    static func logoSection(games: [Game], _ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: GameCell.self, for: indexPath)
        let presenter = GameCellPresenter(view: cell, argument: GameCellArgument(game: games[indexPath.row]))
        cell.layer.cornerRadius = Constant.GameCell.cellCornerRadius
        cell.presenter = presenter
        return cell
    }
}
