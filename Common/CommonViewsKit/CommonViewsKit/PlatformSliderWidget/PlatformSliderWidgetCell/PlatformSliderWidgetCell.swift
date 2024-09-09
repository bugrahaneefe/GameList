//
//  PlatformSliderWidgetCell.swift
//  CommonViewsKit
//
//  Created by Buğrahan Efe on 9.09.2024.
//

import UIKit

public protocol PlatformSliderWidgetCellInterface {
    func prepareUI()
    func setButton(with name: String?)
}

public final class PlatformSliderWidgetCell: UICollectionViewCell {
    @IBOutlet weak var platformButton: UIButton!
    
    public var presenter: PlatformSliderWidgetCellPresenterInterface! {
        didSet {
            presenter.viewDidLoad()
        }
    }
    
    override public func prepareForReuse() {
        super.prepareForReuse()
//        todo
    }
    
    // MARK: IBActions
    @IBAction func platformButtonTapped(_ sender: Any) {
        presenter?.platformButtonTapped()
    }
}

// MARK: - PlatformSliderWidgetCellInterface
extension PlatformSliderWidgetCell: PlatformSliderWidgetCellInterface {
    public func prepareUI() { 
        platformButton.backgroundColor = UIColor.PlatformButtonColor.Background
    }
    
    public func setButton(with name: String?) {
        platformButton.titleLabel?.text = name
    }
}
