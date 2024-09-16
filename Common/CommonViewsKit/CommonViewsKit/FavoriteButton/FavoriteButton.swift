//
//  FavoriteButton.swift
//  CommonViewsKit
//
//  Created by Buğrahan Efe on 28.08.2024.
//

import UIKit
import CommonKit

public final class FavoriteButton: UIButton {
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    private func configure() {
        setImage(UIImage.favoriteTappedIcon, for: .selected)
        setImage(UIImage.favoriteIcon, for: .normal)
        backgroundColor = UIColor.FavoriteButtonColor.Background
        layer.cornerRadius = 15
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
    }
}
