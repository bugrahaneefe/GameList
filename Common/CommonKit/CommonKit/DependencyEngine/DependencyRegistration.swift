//
//  DependencyRegistration.swift
//  DependencyEngine
//
//  Created by M.Yusuf on 26.01.2022.
//  Copyright © 2022 Trendyol. All rights reserved.
//

public protocol DependencyRegistration {
    static func register(to engine: DependencyEngine)
}
