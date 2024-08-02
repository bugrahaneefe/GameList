/// A key for accessing dependencies
///
/// Types conform to this protocol to extend ``DependencyValues`` with custom dependencies. It is
/// similar to SwiftUI's `EnvironmentKey` protocol, which is used to add values to
/// `EnvironmentValues`.
///
/// `DependencyKey` has one main requirement, ``Value``, which must defines the type of the dependency.
///
/// To add a `UserClient` dependency that can fetch and save user values can be done like so:
///
/// ```swift
/// // The user client dependency.
/// protocol UserClient {
///     func fetchUser(_ id: User.ID) async throws -> User
/// }
///
/// // Create a key type that conforms `DependencyKey` protocol for accessing dependency
/// enum UserClientKey: DependencyKey {
///     typealias Value = any UserClient
/// }
///
/// // Register the dependency within DependencyValues.
/// extension DependencyValues {
///   var userClient: any UserClient {
///     get { self[UserClientKey.self] }
///     set { self[UserClientKey.self] = newValue }
///   }
/// }
/// ```
public protocol DependencyKey {
    associatedtype Value
}

/// A key for accessing live dependency value when running in simulator or device
///
/// ```swift
/// // Live UserClient implementation
/// class LiveUserClient: UserClient {
///     func fetchUser(_ id: User.ID) async throws -> User {
///        // fetch user from network
///     }
/// }
///
/// // Extend UserClientKey to conform LiveDependencyKey
/// extension UserClientKey: LiveDependencyKey {
///     static var liveValue: any UserClient = LiveUserClient()
/// }
/// ```
public protocol LiveDependencyKey: DependencyKey {
    static var liveValue: Value { get }
}

/// A key for accessing debug dependency value when running in previews or unit tests
///
/// ```swift
/// // Mock UserClient implementation
/// class MockUserClient: UserClient {
///     var stubbedFetchUser: User?
///     func fetchUser(_ id: User.ID) async throws -> User {
///        return stubbedUser!
///     }
/// }
///
/// // Extend UserClientKey to conform DebugDependencyKey
/// extension UserClientKey: DebugDependencyKey {
///     static var debugValue: any UserClient = MockUserClient()
/// }
/// ```
public protocol DebugDependencyKey: DependencyKey {
    static var debugValue: Value { get }
}
