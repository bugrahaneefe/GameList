//
//  GameCellDetailsView.swift
//  CommonViewsKit
//
//  Created by Buğrahan Efe on 10.09.2024.
//

import Foundation

import SwiftUI

public struct GameCellBannerDetailsView: View {
    public var infos: [(name: String, value: String)]
    
    init(infos: [(name: String, value: String)]) {
        self.infos = infos
    }
    
    public var body: some View {
        VStack {
            ForEach(infos, id: \.value) { info in
                InformationView(title: info.name, info: info.value)
                Divider()
            }
        }
        .background(Color.InformationViewColor.Background)
    }
}
