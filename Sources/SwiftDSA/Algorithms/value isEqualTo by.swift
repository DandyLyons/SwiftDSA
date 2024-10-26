
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
