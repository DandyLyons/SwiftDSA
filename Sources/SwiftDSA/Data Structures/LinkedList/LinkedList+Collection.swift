extension LinkedList: Collection {
    public var startIndex: Index {
        Index(node: head)
    }
    
    public var endIndex: Index {
        Index(node: tail?.next) // In Swift, endIndex is supposed to be the value after last.
    }
    
    public func index(after i: Index) -> Index {
        Index(node: i.node?.next)
    }
    
    /// Returns the value at the given index
    ///
    /// >Precondition:
    /// >`position` must be a valid index or else this will cause a runtime error.
    public subscript(_ position: Index) -> Value {
        position.node!.value
    }
    
    /// Returns the value at the given index
    ///
    /// Safely returns an optional `Value` which must be unwrapped.
    /// For best performance use ``subscript(_ position: Index)``, but unlike
    /// an `Array` the performance difference should be negligible. 
    public subscript(`safe` position: Index) -> Value? {
        position.node?.value
    }
    
    public struct Index: Comparable {
        public var node: Node<Value>?
        
        public static func ==(lhs: Index, rhs: Index) -> Bool {
            switch (lhs.node, rhs.node) {
                case let (left?, right?):
                    return left.next === right.next
                case (nil, nil):
                    return true
                default:
                    return false
            }
        }
        
        /// Returns whether the left hand side is less than the right hand side
        ///
        /// >Precondition:
        /// >`lhs` and `rhs` must be nodes in the same `LinkedList`, otherwise behavior
        /// >is undefined.
        public static func <(lhs: Index, rhs: Index) -> Bool {
            guard lhs != rhs else { return false }
            let nodes = sequence(first: lhs.node) { $0?.next }
            return nodes.contains(where: { $0 === rhs.node })
        }
    }
    
    /// returns the value at the given integer index (0-indexed)
    ///
    /// >Time Complexity: O(i) where i is the given index
    public subscript(int: Int) -> Value? {
        self.node(at: int)?.value
    }
}
