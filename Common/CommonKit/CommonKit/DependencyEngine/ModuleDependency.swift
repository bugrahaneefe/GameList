@propertyWrapper
public class ModuleDependency<Value> {
    private lazy var value: Value = engine.read(for: Value.self)
    private let engine: DependencyEngine

    public init(engine: DependencyEngine = .shared) {
        self.engine = engine
    }

    public var wrappedValue: Value {
        value
    }
}
