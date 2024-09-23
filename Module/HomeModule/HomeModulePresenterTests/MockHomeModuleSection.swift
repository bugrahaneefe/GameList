//
//  MockHomeModuleSection.swift
//  HomeModulePresenterTests
//
//  Created by Buğrahan Efe on 23.09.2024.
//

import UIKit

@testable import HomeModule

final class MockHomeModuleSection: HomeModuleSectionDelegate {
    var invokedConfigureCell = false
    var invokedConfigureCellCount = 0
    var invokedConfigureCellParameters: (collectionView: UICollectionView, indexPath: IndexPath, appearanceType: AppereanceType)?
    var invokedConfigureCellParametersList = [(collectionView: UICollectionView, indexPath: IndexPath, appearanceType: AppereanceType)]()
    var stubbedCell: UICollectionViewCell!
    
    func configureCell(for collectionView: UICollectionView, at indexPath: IndexPath, with appearanceType: AppereanceType) -> UICollectionViewCell {
        invokedConfigureCell = true
        invokedConfigureCellCount += 1
        let parameters = (collectionView, indexPath, appearanceType)
        invokedConfigureCellParameters = parameters
        invokedConfigureCellParametersList.append(parameters)
        return stubbedCell
    }
}
