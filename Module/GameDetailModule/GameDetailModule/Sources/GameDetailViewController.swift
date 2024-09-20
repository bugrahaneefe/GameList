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

protocol GameDetailViewInterface: AlertPresentable {
    func prepareUI()
    func setGameName(of name: String)
    func setGameImage(path: String?)
    func setGameRating(rating: Int)
    func showLoading()
    func hideLoading()
    func setGameDescription(with text: String)
    func setGameInformation(with infos: [(name: String, value: String)])
    func setupGameVisitButtons(byWeb websiteAction: @escaping () -> Void,
                               byReddit redditAction: @escaping () -> Void,
                               _ websiteAvailable: Bool,
                               _ redditAvailable: Bool)
    func setFavoriteButtonImage(isSelected: Bool)
    func updateDescriptionHeight(to height: CGFloat?)
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
    @IBOutlet weak var gameInformationView: UIView!
    @IBOutlet weak var gameVisitButtonsView: UIView!
    private var favoriteButtonImage: UIImage!
    private var gameDescriptionHeightConstraint: NSLayoutConstraint?
    private var isDescriptionExpanded = false
    
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
            image: CommonViewsImages.bannerCellAppearanceButton.uiImage?.resizedImage(Size: CGSize(width: 24, height: 24)),
            style: .plain,
            target: self,
            action: #selector(rightBarButtonItemTapped)
        )
        
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    private func setGameNameLabel(of name: String) {
        self.gameName.text = name
    }
    
    private func setupGameDescriptionView(
        title: String,
        description: String
    ) {
        gameDescriptionView.setupWithSwiftUIView(
            with: GameDetailDescriptionView(
                title: title,
                description: description),
            parentViewController: self
        )
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(gameDescriptionViewTapped))
        gameDescriptionView.addGestureRecognizer(tapGesture)
        updateDescriptionHeight(to: 91.0)
    }
    
    private func setupGameInformationView(
        title: String = "Informations",
        with infos: [(name: String, value: String)]
    ) {
        gameInformationView.setupWithSwiftUIView(
            with: GameDetailInformationView(title: title, infos: infos),
            parentViewController: self)
    }
    
    private func setupGameVisitButtonsView(
        byWeb websiteAction: @escaping () -> Void,
        byReddit redditAction: @escaping () -> Void,
        _ websiteAvailable: Bool,
        _ redditAvailable: Bool
    ) {
        gameVisitButtonsView.setupWithSwiftUIView(
            with: GameDetailVisitButtonsView(
                websiteAction: websiteAction,
                redditAction: redditAction,
                websiteAvailable: websiteAvailable,
                redditAvailable: redditAvailable
            ),
            parentViewController: self)
    }
    
    @objc
    private func rightBarButtonItemTapped() {
        presenter.favoriteButtonTapped()
    }
    
    @objc
    private func gameDescriptionViewTapped() {
        presenter.expandDescription()
        print("selen")
    }
}

extension GameDetailViewController: GameDetailViewInterface {
    var navController: UIViewController? {
        self
    }
    
    func setGameDescription(with text: String) {
        setupGameDescriptionView(title: "Descriptions", description: text)
    }
    
    func setGameInformation(with infos: [(name: String, value: String)]) {
        setupGameInformationView(with: infos)
    }
    
    func setupGameVisitButtons(byWeb websiteAction: @escaping () -> Void,
                               byReddit redditAction: @escaping () -> Void,
                               _ websiteAvailable: Bool,
                               _ redditAvailable: Bool) {
        setupGameVisitButtonsView(
            byWeb: websiteAction,
            byReddit: redditAction,
            websiteAvailable,
            redditAvailable
        )
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
    
    func setFavoriteButtonImage(isSelected: Bool) {
        if isSelected {
            favoriteButtonImage = CommonViewsImages.favoriteButtonTapped.uiImage?.resizedImage(Size: CGSize(width: 20, height: 17.5))
            navigationItem.rightBarButtonItem?.tintColor = UIColor.FavoriteButtonColor.Green
        } else {
            favoriteButtonImage = CommonViewsImages.favoriteButton.uiImage?.resizedImage(Size: CGSize(width: 20, height: 17.5))
            navigationItem.rightBarButtonItem?.tintColor = UIColor.FavoriteButtonColor.White
        }
        navigationItem.rightBarButtonItem?.image = favoriteButtonImage
    }
    
    func updateDescriptionHeight(to height: CGFloat?) {
        gameDescriptionHeightConstraint?.isActive = false
        gameDescriptionHeightConstraint = nil
        
        if let height = height {
            gameDescriptionHeightConstraint = gameDescriptionView.heightAnchor.constraint(equalToConstant: height)
            gameDescriptionHeightConstraint?.isActive = true
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
