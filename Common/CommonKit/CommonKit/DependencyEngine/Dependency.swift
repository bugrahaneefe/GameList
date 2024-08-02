@propertyWrapper
public class Dependency<Value> {
    private var value: Value?
    private let engine: DependencyEngine

    public init(engine: DependencyEngine = .shared) {
        self.engine = engine
    }

    public init(wrappedValue: Value) {
        self.value = wrappedValue
        self.engine = .shared
    }

    public var wrappedValue: Value {
        get {
            #if DEBUG
            if engine.isRunningInUnitTests {
                if let value = value {
                    return value
                } else {
                    fatalError("you should mock the dependency")
                }
            } else {
                if let value = value {
                    return value
                } else {
                    let value: Value = engine.read(for: Value.self)
                    self.value = value
                    return value
                }
            }
            #else
            if let value = value {
                return value
            } else {
                let value: Value = engine.read(for: Value.self)
                self.value = value
                return value
            }
            #endif
        }
        set {
            value = newValue
        }
    }
}
