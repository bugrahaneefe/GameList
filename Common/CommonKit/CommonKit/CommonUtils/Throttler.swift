//
//  Throttler.swift
//  CommonKit
//
//  Created by Buğrahan Efe on 4.09.2024.
//

import Foundation

public protocol ThrottlerInterface {
    func throttle(_ block: @escaping () -> Void)
}

public final class Throttler: ThrottlerInterface {
    private var workItem: DispatchWorkItem = DispatchWorkItem(block: {})
    private var previousRun: Date = Date.distantPast
    private let queue: DispatchQueue
    private let minimumDelay: TimeInterval

    public init(minimumDelay: TimeInterval, queue: DispatchQueue = DispatchQueue.main) {
        self.minimumDelay = minimumDelay
        self.queue = queue
    }

    public func throttle(_ block: @escaping () -> Void) {
        workItem.cancel()
        workItem = DispatchWorkItem { [weak self] in
            self?.previousRun = Date()
            block()
        }

        let delay = previousRun.timeIntervalSinceNow > minimumDelay ? .zero : minimumDelay
        queue.asyncAfter(deadline: .now() + Double(delay), execute: workItem)
    }
}
