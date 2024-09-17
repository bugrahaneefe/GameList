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
        var config = UIButton.Configuration.plain()
        config.baseBackgroundColor = .clear
        configuration = config
        setImage(CommonViewsImages.favoriteButton.uiImage?.resizedImage(Size: CGSize(width: 12, height: 10.5)), for: .normal)
        setImage(CommonViewsImages.favoriteButtonTapped.uiImage?.resizedImage(Size: CGSize(width: 12, height: 10.5)), for: .selected)
        backgroundColor = UIColor.FavoriteButtonColor.Background
        layer.cornerRadius = 15
    }
    
    public override func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        super.sendAction(action, to: target, for: event)
        isSelected = !isSelected
        accessibilityTraits = isSelected ? .selected : .button
    }
}
