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
        setImage(UIImage(systemName: "heart.fill"), for: .selected)
        setImage(UIImage(systemName: "heart"), for: .normal)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.frame.origin.y = 3
    }
}
