//
//  GameCellDetailsView.swift
//  CommonViewsKit
//
//  Created by Buğrahan Efe on 10.09.2024.
//

import Foundation

import SwiftUI

public struct GameCellBannerDetailsView: View {
    public var infos: [String:String]
    
    init(infos: [String : String]) {
        self.infos = infos
    }
    
    public var body: some View {
        HStack {
            ForEach(infos.keys.sorted(), id: \.self) { title in
                InformationView(title: title, info: title)
            }
        }
        .frame(height: 18)
        .background(Color.InformationViewColor.Background)
    }
}
