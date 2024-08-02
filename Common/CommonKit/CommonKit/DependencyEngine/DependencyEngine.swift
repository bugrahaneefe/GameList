import Foundation

public final class DependencyEngine {
    #if DEBUG
    public lazy var isRunningInUnitTests: Bool = {
        NSClassFromString("XCTest") != nil
    }()
    #endif

    #if !RELEASE
    public lazy var isRunningInUITests: Bool = {
        ProcessInfo.processInfo.environment["TestSetup"] == "1"
    }()
    #endif

    private let queue = DispatchQueue(label: "com.trendyol.DependencyEngine", attributes: .concurrent)

    private var dependencies: [ObjectIdentifier: () -> Any] = [:]

    public static let shared = DependencyEngine()

    init() { }

    public func register(value: @autoclosure @escaping () -> Any, for interface: Any.Type) {
        let identifier = ObjectIdentifier(interface)
        queue.async(flags: .barrier) { [weak self] in
            self?.dependencies[identifier] = value
        }
    }

    public func read<Value>(for interface: Any.Type) -> Value {
        let identifier = ObjectIdentifier(interface)
        return queue.sync { [weak self] in
            guard let value = self?.dependencies[identifier]?() as? Value else {
                fatalError("implementation for \(interface) is not found")
            }
            return value
        }
    }
}
