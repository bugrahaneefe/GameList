//
//  String+Extension.swift
//  CommonKit
//
//  Created by Buğrahan Efe on 12.09.2024.
//

import SwiftUI

extension String {
    public func htmlToString() -> String {
        return  try! NSAttributedString(data: self.data(using: .utf8)!,
                                        options: [.documentType: NSAttributedString.DocumentType.html],
                                        documentAttributes: nil).string
    }
}
