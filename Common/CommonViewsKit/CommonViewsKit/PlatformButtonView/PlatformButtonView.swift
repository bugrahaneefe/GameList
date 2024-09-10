//
//  PlatformButtonView.swift
//  CommonViewsKit
//
//  Created by Buğrahan Efe on 10.09.2024.
//

import SwiftUI

private enum Constant {
    static let gamingPlatforms: [(name: String, index: Int)] = [
        ("PC", 1),
        ("PlayStation", 2),
        ("Xbox", 3),
        ("iOS", 4),
        ("Apple Macintosh", 5),
        ("Linux", 6),
        ("Nintendo", 7),
        ("Android", 8),
        ("Atari", 9),
        ("Commodore / Amiga", 10),
        ("SEGA", 11),
        ("3DO", 12),
        ("Neo Geo", 13),
        ("Web", 14)
    ]
}

public struct PlatformButtonView: View {
    @State private var selectedPlatforms: [Int] = []
    public var buttonAction: ([Int]) -> Void
    
    public init(buttonAction: @escaping ([Int]) -> Void) {
        self.buttonAction = buttonAction
    }
    
    public var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                ForEach(Constant.gamingPlatforms, id: \.index) { platform in
                    let isSelected = selectedPlatforms.contains(platform.index)
                    PlatformButton(name: platform.name) {
                        if isSelected {
                            selectedPlatforms.removeAll { $0 == platform.index }
                        } else {
                            selectedPlatforms.append(platform.index)
                        }
                        buttonAction(selectedPlatforms)
                    }
                }
            }
            .frame(height: 60)
            .padding(.horizontal, 10)
        }
        .background(.black)
    }
}
