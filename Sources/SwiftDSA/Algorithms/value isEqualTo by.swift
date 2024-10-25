/// Check if two values have the same equal value for the same property
public func value<T, V: Equatable>(_ lhs: T, isEqualTo rhs: T, by keyPath: KeyPath<T, V>) -> Bool {
    return lhs[keyPath: keyPath] == rhs[keyPath: keyPath]
}

/// Check if two values have the same equal value for multiple properties of the same type
///
/// This function allows you to check for equality on multiple key paths. However, it has the limitation that each key path
/// must point to a value of the same type.
public func value<T, V: Equatable>(_ lhs: T, isEqualTo rhs: T, by keyPaths: [KeyPath<T, V>]) -> Bool {
    return keyPaths.allSatisfy { keyPath in
        return lhs[keyPath: keyPath] == rhs[keyPath: keyPath]
    }
}

/// Check equality of two values by selectively choosing which properties to compare.
///
/// # Example Usage
/// ```swift
/// struct Person {
///    let firstName: String
///    let lastName: String
///    let age: Int
///    let id: UUID
/// }
/// let person1 = Person(firstName: "Blob", lastName: "McBlob", age: 34, id: UUID())
/// let person2 = Person(firstName: "Blob", lastName: "McBlob", age: 34, id: UUID())
/// person1 == person2 // false
/// person1.id == person2.id // false
/// value(person1, isEqualTo: person2, by: \.firstName, \.lastName, \.age) // true
/// ```
public func value<T, each V: Equatable>(_ lhs: T, isEqualTo rhs: T, by keyPath: repeat KeyPath<T, each V>) -> Bool {
    for kp in repeat each keyPath {
        if lhs[keyPath: kp] != rhs[keyPath: kp] { return false }
    }
    return true
}
