//
//  Observer.swift
//  CommonKit
//
//  Created by Buğrahan Efe on 15.09.2024.
//

import Foundation
import Combine

public typealias Action<T> = (T) -> Void

public protocol Observer {
    func observe<T, P: Publisher>(
        _ publisher: P,
        onUpdate: @escaping Action<T>
    ) where P.Output == T, P.Failure == Never
}

open class Observation {
    var cancellables = Set<AnyCancellable>()
    
    public init() {}
    
    open func setupObservation() {}
    
    deinit {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
}

extension Observation: Observer {
    public func observe<P>(_ publisher: P, onUpdate: @escaping Action<P.Output>) where P: Publisher, P.Failure == Never {
        publisher.receive(on: DispatchQueue.main)
            .sink { onUpdate($0) }
            .store(in: &self.cancellables)
    }
}
