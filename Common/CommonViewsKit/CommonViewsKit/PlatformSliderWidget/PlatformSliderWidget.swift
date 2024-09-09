//
//  PlatformSliderWidget.swift
//  CommonViewsKit
//
//  Created by Buğrahan Efe on 9.09.2024.
//

import UIKit
import CommonKit
import CoreUtils

public protocol PlatformSliderWidgetInterface {
    func prepareUI()
    func prepareCollectionView()
    func reloadCollectionView()
}

private enum Constant {
    static let gamingPlatforms =  ["PC", "PlayStation", "Xbox", "Atari", "iOS", "Android", "PS Vita", "PSP", "macOS", "Linux", "Nintendo", "Wii", "GameCube", "SNES", "NES", "Jaguar", "Commodore / Amiga", "SEGA", "Genesis", "Dreamcast", "Game Gear", "3DO", "Web", "Neo"]
}

public final class PlatformSliderWidget: NibView {
    @IBOutlet public weak var collectionView: UICollectionView!
    
    public var presenter : PlatformSliderWidgetPresenterInterface! {
        didSet {
            presenter.load()
        }
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceHorizontal = true
        collectionView.backgroundColor = .red
    }
}

extension PlatformSliderWidget: PlatformSliderWidgetInterface {
    public func prepareUI() {
        setupCollectionView()
    }
    
    public func prepareCollectionView() {
        collectionView.register(cellType: PlatformSliderWidgetCell.self, bundle: CommonViewsKitResources.bundle)
    }
    
    public func reloadCollectionView() {
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension PlatformSliderWidget: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constant.gamingPlatforms.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return presenter.cellForGame(at: indexPath, in: collectionView)
    }
}

// MARK: - UICollectionViewDelegate
extension PlatformSliderWidget: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectGame(at: indexPath)
    }
}
