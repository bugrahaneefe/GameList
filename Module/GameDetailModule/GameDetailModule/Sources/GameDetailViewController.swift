//
//  GameDetailViewController.swift
//  GameDetailModule
//
//  Created by Buğrahan Efe on 11.09.2024.
//

import CommonKit
import CommonViewsKit
import CoreUtils
import UIKit
import SwiftUI

protocol GameDetailViewInterface {
    func prepareUI()
}

private enum Constant {
    enum NavigationBar {
        static let title: String = "Game Detail"
        static let titleFont: CGFloat = 16.0
    }
}

final class GameDetailViewController: BaseViewController {
    
    var presenter: GameDetailPresenterInterface!
    
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
        
        let rightBarButtonItem = UIBarButtonItem(
            image: UIImage.favoriteIcon,
            style: .plain,
            target: self,
            action: #selector(rightBarButtonItemTapped)
        )
        
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    
    @objc
    private func rightBarButtonItemTapped() {
        print("selen")
    }
}

extension GameDetailViewController: GameDetailViewInterface {
    func prepareUI() {
        setupNavigationBar()
    }
}
