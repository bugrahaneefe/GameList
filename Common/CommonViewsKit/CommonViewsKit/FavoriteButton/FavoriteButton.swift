//
//  FavoriteButton.swift
//  CommonViewsKit
//
//  Created by Buğrahan Efe on 28.08.2024.
//

import UIKit

protocol FavoriteButtonInterface {
    func setFavoriteButton()
}

open class FavoriteButton: NibView {
    @IBOutlet weak var favoriteButton: UIButton!
    
    var presenter: FavoriteButtonPresenterInterface! {
        didSet {
            presenter?.load()
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: IBActions
    @IBAction public func favoriteButtonPressed(_ sender: Any) {
        print("sssssssss")
        presenter?.favoriteButtonPressed()
    }
}

extension FavoriteButton: FavoriteButtonInterface {
    func setFavoriteButton() {
        self.favoriteButton.backgroundColor = .red
    }
}


open class NibView: BorderArrangeableView {
    public var view: UIView!

    override public init(frame: CGRect) {
        super.init(frame: frame)

        // Setup view from .xib file
        xibSetup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        // Setup view from .xib file
        xibSetup()
    }
}

private extension NibView {
    func xibSetup() {
        let moduleName = type(of: self).description().components(separatedBy: ".").first!
        let bundle: Bundle
        bundle = loadBundle(for: moduleName, class: type(of: self))
        
        backgroundColor = UIColor.clear
        
        view = loadNib(bundle: bundle)
        // use bounds not frame or it'll be offset
        view.frame = bounds
        // Adding custom subview on top of our view
        addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func loadNib(bundle: Bundle) -> UIView {
        let nibName = type(of: self).description().components(separatedBy: ".").last!

        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    private func loadBundle(for moduleName: String, `class`: AnyClass) -> Bundle {
        let candidates = [
            // Bundle should be present here when the package is linked into an App.
            Bundle.main.resourceURL,

            // Bundle should be present here when the package is linked into a framework.
            Bundle(for: `class`).resourceURL,

            // For command-line tools.
            Bundle.main.bundleURL,
        ]

        let bundleName = "\(moduleName)_\(moduleName)"

        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                return bundle
            }
        }
        fatalError("unable to find bundle named \(bundleName)")
    }
}

open class BorderArrangeableView: UIView {
    open var borderWidth: CGFloat {
        get { layer.borderWidth }
        set { layer.borderWidth = newValue }
    }

    open var borderColor: UIColor? {
        get {
            guard let borderColor = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: borderColor)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }

    open var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }

    open var shadowOffset: CGSize {
        get { layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }

    open var shadowColor: UIColor? {
        get {
            guard let shadowColor = layer.shadowColor else {
                return nil
            }
            return UIColor(cgColor: shadowColor)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }

    open var shadowOpacity: Float {
        get { layer.shadowOpacity }
        set { layer.shadowOpacity = newValue }
    }

    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }

    open func configureDefaultBorder() {
        borderWidth = 1
        borderColor = UIColor(hex: "e5e5e5")
    }
}
