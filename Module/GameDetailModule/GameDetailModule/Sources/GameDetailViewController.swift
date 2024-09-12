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
    func setGameName(of name: String)
    func setGameImage(path: String?)
    func setGameRating(rating: Int)
    func showLoading()
    func hideLoading()
    func setGameDescription(with text: String)
}

private enum Constant {
    enum NavigationBar {
        static let title: String = "Game Detail"
        static let titleFont: CGFloat = 16.0
    }
}

final class GameDetailViewController: BaseViewController {
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var gameRatingView: UIView!
    @IBOutlet weak var gameRatingLabel: UILabel!
    @IBOutlet weak var gameDescriptionView: UIView!
    
    var presenter: GameDetailPresenterInterface!
    private var loadingIndicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    //MARK: Private Functions
    private func setupLoadingIndicator() {
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator?.center = view.center
        loadingIndicator?.hidesWhenStopped = true
        loadingIndicator?.color = UIColor.LoadingIndicatorColor.Tint
        if let loadingIndicator = loadingIndicator {
            view.addSubview(loadingIndicator)
        }
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
    
    private func setGameNameLabel(of name: String) {
        self.gameName.text = name
    }
    
    private func setupGameDescriptionView(title: String, description: String) {
        let vc = UIHostingController(rootView: GameDetailDescriptionView(title: title, description: description))
        let swiftuiView = vc.view!
        swiftuiView.translatesAutoresizingMaskIntoConstraints = false
        addChild(vc)
        gameDescriptionView.addSubview(swiftuiView)
        NSLayoutConstraint.activate([
            swiftuiView.leadingAnchor.constraint(equalTo: gameDescriptionView.leadingAnchor),
            swiftuiView.trailingAnchor.constraint(equalTo: gameDescriptionView.trailingAnchor),
            swiftuiView.topAnchor.constraint(equalTo: gameDescriptionView.topAnchor),
            swiftuiView.bottomAnchor.constraint(equalTo: gameDescriptionView.bottomAnchor),
            swiftuiView.widthAnchor.constraint(equalTo: gameDescriptionView.widthAnchor)
        ])
        vc.didMove(toParent: self)
    }
        
    @objc
    private func rightBarButtonItemTapped() {
        print("selen")
    }
}

extension GameDetailViewController: GameDetailViewInterface {
    func setGameDescription(with text: String) {
        setupGameDescriptionView(title: "Descriptions", description: text)
    }
    
    func setGameImage(path: String?) {
        self.gameImage.setImageWith(url: path)
    }
    
    func setGameRating(rating: Int) {
        self.gameRatingLabel.text = "\(rating)"
        if rating > 80 {
            self.gameRatingView.backgroundColor = UIColor.RatingViewColor.RatingViewGreen
            self.gameRatingLabel.textColor = UIColor.RatingViewColor.RatingLabelGreen
        } else if rating > 60 {
            self.gameRatingView.backgroundColor = UIColor.RatingViewColor.RatingViewOrange
            self.gameRatingLabel.textColor = UIColor.RatingViewColor.RatingLabelOrange
        } else {
            self.gameRatingView.backgroundColor = UIColor.RatingViewColor.RatingViewRed
            self.gameRatingLabel.textColor = UIColor.RatingViewColor.RatingLabelRed
        }
        gameRatingView.layer.cornerRadius = 3
    }
    
    func setGameName(of name: String) {
        setGameNameLabel(of: name)
    }
    
    func prepareUI() {
        setupNavigationBar()
    }
    
    func showLoading() {
        if loadingIndicator == nil {
            setupLoadingIndicator()
        }
        loadingIndicator?.startAnimating()
    }
    
    func hideLoading() {
        loadingIndicator?.stopAnimating()
    }
}
