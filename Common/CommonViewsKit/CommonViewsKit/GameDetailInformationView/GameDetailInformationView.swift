//
//  GameDetailInformationView.swift
//  CommonViewsKit
//
//  Created by Buğrahan Efe on 12.09.2024.
//

import SwiftUI

public struct GameDetailInformationView: View {
    public var infos: [(name: String, value: String)]
    private let title: String

    public init(title: String, infos: [(name: String, value: String)]) {
        self.title = title
        self.infos = infos
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
                ForEach(infos, id: \.value) { info in
                    InformationView(title: info.name, info: info.value)
                    Divider()
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
