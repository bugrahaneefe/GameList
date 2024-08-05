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

private enum Constant {
    static let bannerSectionIdentifier = "GameBannerSection"
    static let cellHorizontalMargins = 30.0
    static let headerReusableViewHeight = 48.0
    static let lineSpacing = 10.0
    enum BannerCell {
        static let height = 187.0
        static let appereanceIcon = "GameBannerAppereance"
    }
}

protocol HomeModuleSectionDelegate: AnyObject {
    func gameSelected(_ game: Game)
}

protocol HomeModuleHeaderCollectionReusablePresenterDelegate: AnyObject {
    func changeAppearanceTapped()
}

enum HomeModuleSection {
    static func bannerSection(items: [Game],
                              screenWidth: Double = Device.ScreenSize.screenWidth,
                              delegate: HomeModuleSectionDelegate?,
                              headerDelegate: HomeModuleHeaderCollectionReusablePresenterDelegate?,
                              gameDelegate: HomeModuleGameDelegate?) -> GenericSection<Game> {
        return GenericSection(
            listIdentifier: Constant.bannerSectionIdentifier,
            items: items)
        .onCellSize { _, size in
                .init(width: screenWidth - Constant.cellHorizontalMargins, height: Constant.BannerCell.height)
        }
        .onCellConfigure(for: GameCell.self, bundle: Bundle(for: GameCell.self)) { game, cell, indexPath in
            cell.presenter = GameCellPresenter(view: cell,
                                               argument: .init(game: game),
                                               homeModuleGameDelegate: gameDelegate)
        }
        .onHeaderSize { _, size in
                .init(width: screenWidth, height: Constant.headerReusableViewHeight)
        }
        .onDidSelect { [weak delegate] game, _ in
            delegate?.gameSelected(game)
        }
        .minimumLineSpacing(Constant.lineSpacing)
    }
}
