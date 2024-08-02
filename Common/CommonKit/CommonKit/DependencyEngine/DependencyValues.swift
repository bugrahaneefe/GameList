import Foundation

/// A collection of dependencies that is globally available.
///
/// To access a particular dependency from the collection you use the ``Injected`` property
/// wrapper:
///
/// ```swift
/// @Injected(\.date) var date
/// // ...
/// let now = date.now
/// ```
///
/// To change a dependency you can use the
/// ``withDependencies(_:operation:)`` method:
///
/// ```swift
/// @Injected(\.date) var date
/// let now = date.now
///
/// withDependencies {
///   $0.date.now = Date(timeIntervalSinceReferenceDate: 1234567890)
/// } operation: {
///   @Injected(\.date.now) var now: Date
///   now.timeIntervalSinceReferenceDate  // 1234567890
/// }
/// ```
public final class DependencyValues {
    private var storage: [ObjectIdentifier: Any] = [:]
    static let shared = DependencyValues()
    private let lock = NSRecursiveLock()

    public subscript<Key: DependencyKey>(
        key: Key.Type
    ) -> Key.Value {
        get {
            self.lock.lock()
            defer { self.lock.unlock() }

            guard
                let base = self.storage[ObjectIdentifier(key)],
                let dependency = base as? Key.Value
            else {
                var val: Key.Value?
                #if DEBUG
                if isRunningInPreviews || isRunningInUnitTests {
                    if let debugVal = _debugValue(key) as? Key.Value {
                        val = debugVal
                    }
                } else {
                    if let liveVal = _liveValue(key) as? Key.Value {
                        val = liveVal
                    }
                }
                #else
                if let liveVal = _liveValue(key) as? Key.Value {
                    val = liveVal
                }
                #endif

                guard let value = val else {
                    fatalError("Dependency is not found for \(key)")
                }

                self.storage[ObjectIdentifier(key)] = value
                return value
            }

            return dependency
        }
        set {
            self.lock.lock()
            defer { self.lock.unlock() }
            self.storage[ObjectIdentifier(key)] = newValue
        }
    }
}

private func _liveValue(_ key: Any.Type) -> Any? {
  (key as? any LiveDependencyKey.Type)?.liveValue
}

private func _debugValue(_ key: Any.Type) -> Any? {
  (key as? any DebugDependencyKey.Type)?.debugValue
}

#if DEBUG
public let isRunningInUnitTests: Bool = NSClassFromString("XCTest") != nil

public let isRunningInPreviews: Bool = {
    let environment = ProcessInfo.processInfo.environment
    return environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
}()

@discardableResult
public func withDependencies<R>(
    _ updateValuesForOperation: (DependencyValues) -> Void = { _ in },
    operation: () -> R
) -> R {
    updateValuesForOperation(DependencyValues.shared)
    return operation()
}
#endif
