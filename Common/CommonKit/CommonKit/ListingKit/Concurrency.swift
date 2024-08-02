//
//  File.swift
//  
//
//  Created by Mustafa Yusuf on 23.02.2023.
//

import Dispatch

protocol DispatchQueueProtocol {
    func performAsync(_ action: @escaping () -> Void)
}

extension DispatchQueue: DispatchQueueProtocol {
    func performAsync(_ action: @escaping () -> Void) {
        self.async {
            action()
        }
    }
}

protocol DiffQueueThrottleInterface {
    func run(_ operation: @escaping () -> Void)
}

final class DiffQueueThrottler: DiffQueueThrottleInterface {
    let queue: DispatchQueue
    let interval: Double

    private let dispatcherQueue = DispatchQueue(label: "throttler.dispatch.queue", qos: .userInteractive)
    private var items: [DispatchWorkItem] = []
    private var isRunningAction = false

    init(queue: DispatchQueue, interval: Double) {
        self.queue = queue
        self.interval = interval
    }

    func run(_ operation: @escaping () -> Void) {
        dispatcherQueue.async {
            if self.isRunningAction {
                let item = DispatchWorkItem(block: operation)
                item.notify(queue: self.dispatcherQueue, execute: .init(block: self.checkNextItem))
                self.items.append(item)
            } else {
                self.isRunningAction = true
                let item = DispatchWorkItem(block: operation)

                item.notify(queue: self.dispatcherQueue, execute: .init(block: self.checkNextItem))
                self.queue.async(execute: item)
            }
        }
    }

    private func checkNextItem() {
        guard let item = items.first else {
            isRunningAction = false
            return
        }

        items = Array(items.dropFirst())
        queue.asyncAfter(deadline: .now() + interval, execute: item)
    }
}
