/// A property wrapper for accessing dependencies.
///
/// All dependencies are stored in ``DependencyValues`` and one uses this property wrapper to gain
/// access to a particular dependency. Typically it used to provide dependencies to features such as
/// an observable object:
///
/// ```swift
/// final class FeaturePresenter: ObservableObject {
///   @Injected(\.apiClient) var apiClient
///   @Injected(\.favoriteManager) var favoriteManager
///   @Injected(\.uuid) var uuid
///
///   // ...
/// }
/// ```
///
/// But it can be used in other situations too, such as a helper function:
///
/// ```swift
/// func sharedEffect() async throws -> Action {
///   @Injected(\.apiClient) var apiClient
///   @Injected(\.favoriteManager) var favoriteManager
///
///   // ...
/// }
/// ```
@propertyWrapper
public struct Injected<Value>: @unchecked Sendable {
    private var value: Value?
    private let keyPath: KeyPath<DependencyValues, Value>

    /// Creates a dependency property to read the specified key path.
    ///
    /// Don't call this initializer directly. Instead, declare a property with the `Injected`
    /// property wrapper, and provide the key path of the dependency value that the property should
    /// reflect:
    ///
    /// ```swift
    /// final class FeaturePresenter: ObservableObject {
    ///   @Injected(\.apiClient) var apiClient
    ///
    ///   // ...
    /// }
    /// ```
    ///
    /// - Parameter keyPath: A key path to a specific resulting value.
    public init(_ keyPath: KeyPath<DependencyValues, Value>) {
        self.keyPath = keyPath
    }

    /// The current value of the dependency property.
    public var wrappedValue: Value {
        mutating get {
            if let value = value {
                return value
            } else {
                let value = DependencyValues.shared[keyPath: self.keyPath]
                self.value = value
                return value
            }
        }
        set {
            self.value = newValue
        }
    }
}
