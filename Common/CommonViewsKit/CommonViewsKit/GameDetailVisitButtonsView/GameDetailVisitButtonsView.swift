//
//  GameDetailVisitButtonsView.swift
//  CommonViewsKit
//
//  Created by Buğrahan Efe on 12.09.2024.
//

import SwiftUI

public struct GameDetailVisitButtonsView: View {
    private let websiteAction: () -> Void
    private let redditAction: () -> Void
    private let websiteAvailable: Bool
    private let redditAvailable: Bool
    
    public init(
        websiteAction: @escaping () -> Void,
        redditAction: @escaping () -> Void,
        websiteAvailable: Bool,
        redditAvailable: Bool) {
            self.websiteAction = websiteAction
            self.redditAction = redditAction
            self.websiteAvailable = websiteAvailable
            self.redditAvailable = redditAvailable
        }
    
    public var body: some View {
        VStack {
            if redditAvailable {
                HStack {
                    VisitButton(name: "Visit Reddit", action: redditAction)
                }
            }
            if websiteAvailable {
                HStack{
                    VisitButton(name: "Visit Website", action: websiteAction)
                }
            }
            Spacer()
        }
        .background(.black)
    }
}
