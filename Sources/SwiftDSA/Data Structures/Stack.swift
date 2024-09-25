
/// A stack data structure.
///
/// Stack guarantees that elements are kept in order.
public struct Stack<Element> {
    
    public init(_ array: [Element]) {
        self.array = array
    }
    
    /// returns an empty stack
    public init() {
        self.array = []
    }
    
    private var array: [Element]
    
    /// Appends the value to the end of the stack.
    mutating public func push(_ element: Element) {
        self.array.append(element)
    }
    
    /// Removes the last value (if it exists) from the stack and returns it.
    @discardableResult
    mutating public func pop() -> Element? {
        self.array.popLast()
    }
    
    /// Returns the last value (if it exists) without mutating.
    public func peek() -> Element? {
        self.array.last
    }
    
}

extension Stack: Sendable where Element: Sendable {}
extension Stack: Equatable where Element: Equatable {}
extension Stack: Hashable where Element: Hashable {}

extension Stack: Sequence {
    public typealias Iterator = Array<Element>.Iterator
    public func makeIterator() -> Array<Element>.Iterator {
        self.array.makeIterator()
    }
}

extension Stack: Collection {
    public typealias Index = Array<Element>.Index
    
    public var startIndex: Array<Element>.Index {
        self.array.startIndex
    }
    
    public var endIndex: Array<Element>.Index {
        self.array.endIndex
    }
    
    public func index(after i: Array<Element>.Index) -> Array<Element>.Index {
        self.array.index(after: i)
    }
    
    public subscript(position: Array<Element>.Index) -> Element {
        get {
            self.array[position]
        }
    }
    
}
