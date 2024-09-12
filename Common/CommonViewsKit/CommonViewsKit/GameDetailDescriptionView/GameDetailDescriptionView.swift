//
//  GameDetailDescriptionView.swift
//  CommonViewsKit
//
//  Created by Buğrahan Efe on 12.09.2024.
//

import SwiftUI

public struct GameDetailDescriptionView: View {
    private let title: String
    private let description: String
    
    public init(title: String,
                description: String) {
        self.title = title
        self.description = description
    }
    
    public var body: some View {
        VStack {
            VStack(alignment: .center, spacing: 9) {
                HStack {
                    Text(self.title)
                        .foregroundColor(Color.DescriptionViewColor.TitleTint)
                        .font(Font.custom("Lato", size: 12))
                    Spacer()
                }
                VStack {
                    Text(self.description.htmlToString())
                        .foregroundColor(Color.DescriptionViewColor.DescriptionTint)
                        .font(Font.custom("Lato", size: 10))
                    Spacer()
                }
            }
            .padding(.horizontal, 12)
            .padding(.top, 10)
            .background(Color.DescriptionViewColor.Background)
            .cornerRadius(8)
        }
        .background(.black)
    }
}
