//
//  FavoriteButton.swift
//  CommonViewsKit
//
//  Created by Buğrahan Efe on 28.08.2024.
//

import UIKit
import CommonKit

private enum Constant {
    enum Configuration {
        static let FavoriteIconSize = CGSize(width: 12, height: 10.5)
        static let CornerRadius = 15.0
    }
}

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
        var config = UIButton.Configuration.plain()
        config.baseBackgroundColor = .clear
        configuration = config
        setImage(CommonViewsImages.favoriteButton.uiImage?.resizedImage(Size: Constant.Configuration.FavoriteIconSize), for: .normal)
        setImage(CommonViewsImages.favoriteButtonTapped.uiImage?.resizedImage(Size: Constant.Configuration.FavoriteIconSize), for: .selected)
        backgroundColor = UIColor.FavoriteButtonColor.Background
        layer.cornerRadius = Constant.Configuration.CornerRadius
    }
    
    public override func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        super.sendAction(action, to: target, for: event)
        isSelected = !isSelected
        accessibilityTraits = isSelected ? .selected : .button
    }
}
