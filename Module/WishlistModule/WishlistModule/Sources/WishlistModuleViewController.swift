//
//  WishlistModuleViewController.swift
//  WishlistModule
//
//  Created by Buğrahan Efe on 16.09.2024.
//

import CommonKit
import CommonViewsKit
import CoreUtils
import UIKit
import SwiftUI

protocol WishlistViewInterface {
    func prepareUI()
    func prepareCollectionView()
    func reloadCollectionView()
    func showLoading()
    func hideLoading()
    func showResponseNilLabel()
    func showResponseNilLabel(with: String)
    func hideResponseNilLabel()
}

private enum Constant {
    enum NavigationBar {
        static let title: String = "Wishlist"
        static let titleFont: CGFloat = 16.0
    }
}

final class WishlistModuleViewController: BaseViewController {

    var presenter: WishlistModulePresenterInterface!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    private func setupNavigationBar() {
        self.title = Constant.NavigationBar.title
        self.navigationController?.navigationBar.tintColor = .white

        navigationController?.navigationBar.setTitleTextAttributes(attributes: [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(
                ofSize: Constant.NavigationBar.titleFont,
                weight: .semibold)
        ])
    }
}

extension WishlistModuleViewController: WishlistViewInterface {
    func prepareUI() {
        setupNavigationBar()
    }
    
    func prepareCollectionView() {
        
    }
    
    func reloadCollectionView() {
        
    }
    
    func showLoading() {
        
    }
    
    func hideLoading() {
        
    }
    
    func showResponseNilLabel() {
        
    }
    
    func showResponseNilLabel(with: String) {
        
    }
    
    func hideResponseNilLabel() {
        
    }
}
