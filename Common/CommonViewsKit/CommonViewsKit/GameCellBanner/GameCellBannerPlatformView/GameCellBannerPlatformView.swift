//
//  GameCellBannerPlatformView.swift
//  CommonViewsKit
//
//  Created by Buğrahan Efe on 10.09.2024.
//

import SwiftUI

public struct GameCellBannerPlatformView: View {
    public var buttonNames: [String]
    
    public init(buttonNames: [String]) {
        self.buttonNames = buttonNames
    }
    
    public var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 3) {
                ForEach(buttonNames.indices, id: \.self) { index in
                    let platformName = buttonNames[index]
                    if index < 3 {
                        PlatformButton(isActive: false,
                                       name: platformName,
                                       fontSize: 8,
                                       horizontalPadding: 6,
                                       height: 10,
                                       cellRadius: 24,
                                       defaultColor: Color.GameCellBannerPlatformColor.Tint,
                                       action: {
                        })
                    }
                }
                if buttonNames.count > 3 {
                    PlatformButton(isActive: false,
                                   name: "+\(buttonNames.count - 3)",
                                   fontSize: 8,
                                   horizontalPadding: 6,
                                   height: 10,
                                   cellRadius: 16,
                                   defaultColor: Color.GameCellBannerPlatformColor.Tint,
                                   action: {
                    })
                }
            }
        }
        .background(Color.GameCellBannerPlatformColor.Background)
    }
}
