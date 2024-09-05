//
//  Defaults.swift
//  CommonKit
//
//  Created by Buğrahan Efe on 28.08.2024.
//

import Foundation

/// Allows to match for optionals with generics that are defined as non-optional.
public protocol AnyOptional {
    /// Returns `true` if `nil`, otherwise `false`.
    var isObjectNil: Bool { get }
}

extension Optional: AnyOptional {
    public var isObjectNil: Bool { self == nil }
}

extension UserDefault where T: ExpressibleByNilLiteral {
    /// Creates a new User Defaults property wrapper for the given key.
    /// - Parameters:
    ///   - key: The key to use with the user defaults store.
    public init(key: String, _ userDefaults: UserDefaults = .standard) {
        self.init(wrappedValue: nil, key, userDefaults: userDefaults)
    }
}

@propertyWrapper
public struct UserDefault<T: Codable> {
    public let key: String
    public let defaultValue: T
    public var userDefaults: UserDefaults
    private var value: T?

    public init(_ key: String,
                userDefaults: UserDefaults = .standard) where T: ExpressibleByNilLiteral {
        self.key = key
        self.defaultValue = nil
        self.userDefaults = userDefaults
    }

    public init(wrappedValue: T,
                _ key: String,
                userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = wrappedValue
        self.userDefaults = userDefaults
    }

    public var wrappedValue: T {
        get {
            return value ?? get(with: key, type: T.self) ?? defaultValue
        }
        set {
            if let optional = newValue as? AnyOptional, optional.isObjectNil {
                remove(forKey: key)
                value = nil
            } else {
                save(value: newValue, key: key)
                value = newValue
            }
        }
    }

    private func get<S: Decodable>(with key: String, type: S.Type) -> S? {

        guard let data = userDefaults.value(forKey: key) as? Data else {
            guard let object = userDefaults.object(forKey: key) as? S else {
                return nil
            }

            return object
        }

        let object = try? JSONDecoder().decode(type, from: data)
        return object
    }

    private func save<S: Encodable>(value object: S, key: String) {
        userDefaults.set(object.encoded(), forKey: key)
        userDefaults.synchronize()
    }

    private func remove(forKey key: String) {
        userDefaults.removeObject(forKey: key)
        userDefaults.synchronize()
    }
}


public protocol DefaultsProtocol {
    static func hasKey(key: String) -> Bool
    static func save(data value: Any, key: String)
    static func remove(forKey key: String)
    static func object(key: String) -> Any?
    static func string(key: String) -> String?
    static func date(key: String) -> Date?
    static func bool(key: String) -> Bool
    static func int(key: String) -> Int?
    static func url(key: String) -> URL?
    static func array(key: String) -> [Any]?
    static func set(key: String) -> Set<Int>?
    static func data(key: String) -> Data?
    static func dictionary(key: String) -> [String: Any]?
    static func save<T: Encodable>(value object: T, key: String)
    static func get<T: Decodable>(with key: String, type: T.Type) -> T?
    static func save<T: Encodable>(array: [T], key: String)
    static func getArray<T: Decodable>(with key: String, type: T.Type) -> [T]?
}

public class Defaults: NSObject, DefaultsProtocol { }

public extension DefaultsProtocol {
    static func hasKey(key: String) -> Bool {
        UserDefaults.standard.object(forKey: key) != nil
    }

    static func save(data value: Any, key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }

    static func remove(forKey key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }

    static func object(key: String) -> Any? {
        UserDefaults.standard.object(forKey: key)
    }

    static func string(key: String) -> String? {
        UserDefaults.standard.object(forKey: key) as? String
    }

    static func date(key: String) -> Date? {
        UserDefaults.standard.object(forKey: key) as? Date
    }

    static func data(key: String) -> Data? {
        UserDefaults.standard.value(forKey: key) as? Data
    }

    static func bool(key: String) -> Bool {
        UserDefaults.standard.bool(forKey: key)
    }

    static func int(key: String) -> Int? {
        UserDefaults.standard.object(forKey: key) as? Int
    }

    static func url(key: String) -> URL? {
        UserDefaults.standard.object(forKey: key) as? URL
    }
    
    static func set(key: String) -> Set<Int>? {
        UserDefaults.standard.object(forKey: key) as? Set<Int>
    }

    static func array(key: String) -> [Any]? {
        UserDefaults.standard.object(forKey: key) as? [Any]
    }

    static func array<T>(key: String) -> [T]? {
        UserDefaults.standard.object(forKey: key) as? [T]
    }

    static func dictionary(key: String) -> [String: Any]? {
        UserDefaults.standard.object(forKey: key) as? [String: Any]
    }

    static func save<T: Encodable>(value object: T, key: String) {
        UserDefaults.standard.set(object.encoded(), forKey: key)
        UserDefaults.standard.synchronize()
    }

    static func get<T: Decodable>(with key: String, type: T.Type) -> T? {
        guard let data = UserDefaults.standard.value(forKey: key) as? Data else { return nil }
        let object = try? JSONDecoder().decode(type, from: data)
        return object
    }

    static func save<T: Encodable>(array: [T], key: String) {
        let data = try? JSONEncoder().encode(array)
        UserDefaults.standard.set(data, forKey: key)
        
    }

    static func getArray<T: Decodable>(with key: String, type: T.Type) -> [T]? {
        guard let data = UserDefaults.standard.value(forKey: key) as? Data else { return nil }
        let array = try? JSONDecoder().decode(Array<T>.self, from: data)
        return array
    }
}

public extension Encodable {
    func data() -> Data? {
        return try? PropertyListEncoder().encode(self)
    }

    func encoded() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}

public extension UserDefaults {
    subscript(key: String) -> Any? {
        get {
            return object(forKey: key)
        }
        set {
            set(newValue, forKey: key)
        }
    }
}
