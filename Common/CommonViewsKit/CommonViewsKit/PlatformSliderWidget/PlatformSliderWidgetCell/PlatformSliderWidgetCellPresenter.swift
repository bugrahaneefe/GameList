//
//  PlatformSliderWidgetCellPresenter.swift
//  CommonViewsKit
//
//  Created by Buğrahan Efe on 9.09.2024.
//

import Foundation
import CoreUtils

public protocol PlatformSliderWidgetCellPresenterInterface: PresenterInterface {
    func platformButtonTapped()
}

public final class PlatformSliderWidgetCellPresenter {
    private var view: PlatformSliderWidgetCellInterface?
    
    public init(view: PlatformSliderWidgetCellInterface? = nil) {
        self.view = view
    }
}

// MARK: - PlatformSliderWidgetCellPresenterInterface
extension PlatformSliderWidgetCellPresenter: PlatformSliderWidgetCellPresenterInterface {
    public func viewDidLoad() {
        view?.prepareUI()
    }
    
    public func platformButtonTapped() {
        view?.setButton(with: "selen")
        print("PlatformButtonTapped!")
    }
}
