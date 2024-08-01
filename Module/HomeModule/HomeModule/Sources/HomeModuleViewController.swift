//
//  HomeModuleViewController.swift
//  HomeModule
//
//  Created by Buğrahan Efe on 31.07.2024.
//

import UIKit

protocol HomeViewInterface {
    func prepareUI()
}

final class HomeModuleViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
//    @IBOutlet private weak var emptyShowableView: UIView!
    
    var presenter: HomeModulePresenterInterface!
}
