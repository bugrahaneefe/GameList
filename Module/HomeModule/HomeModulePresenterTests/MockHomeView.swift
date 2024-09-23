//
// MockHomeView.swift
// HomeModulePresenterTests
//
// Created by Buğrahan Efe on 23.09.2024.
//

import UIKit

@testable import HomeModule

final class MockHomeView: HomeViewInterface {
    var invokedNavControllerGetter = false
    var invokedNavControllerGetterCount = 0
    var stubbedNavController: UIViewController!
    var navController: UIViewController? {
        invokedNavControllerGetter = true
        invokedNavControllerGetterCount += 1
        return stubbedNavController
    }
    var invokedPrepareUI = false
    var invokedPrepareUICount = 0
    func prepareUI() {
        invokedPrepareUI = true
        invokedPrepareUICount += 1
    }
    var invokedPrepareCollectionView = false
    var invokedPrepareCollectionViewCount = 0
    func prepareCollectionView() {
        invokedPrepareCollectionView = true
        invokedPrepareCollectionViewCount += 1
    }
    var invokedReloadCollectionView = false
    var invokedReloadCollectionViewCount = 0
    func reloadCollectionView() {
        invokedReloadCollectionView = true
        invokedReloadCollectionViewCount += 1
    }
    var invokedShowLoading = false
    var invokedShowLoadingCount = 0
    func showLoading() {
        invokedShowLoading = true
        invokedShowLoadingCount += 1
    }
    var invokedHideLoading = false
    var invokedHideLoadingCount = 0
    func hideLoading() {
        invokedHideLoading = true
        invokedHideLoadingCount += 1
    }
    var invokedShowResponseNilLabel = false
    var invokedShowResponseNilLabelCount = 0
    func showResponseNilLabel() {
        invokedShowResponseNilLabel = true
        invokedShowResponseNilLabelCount += 1
    }
    var invokedHideResponseNilLabel = false
    var invokedHideResponseNilLabelCount = 0
    func hideResponseNilLabel() {
        invokedHideResponseNilLabel = true
        invokedHideResponseNilLabelCount += 1
    }
}
