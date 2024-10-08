
/// A linked list implemented in Swift. 
/// 
/// Largely influenced by the implementation from 
/// https://www.kodeco.com/books/data-structures-algorithms-in-swift/v3.0/chapters/6-linked-list
/// 
public struct LinkedList<Value> {
    /// the first node of the linked list
    internal(set) public var head: Node<Value>?
    /// the last node of the linked list
    internal(set) public var tail: Node<Value>?

    /// Creates an empty linked list
    public init() {}
    
    /// Creates a linked list with elements in the same order that they were given
    ///
    /// >Time Complexity:O(n)
    public init(_ elements: any Collection<Value>) {
        if let first = elements.first {
            self.head = Node(value: first)
        } else {
            head = nil
            tail = nil
            return
        }
        var prevNode = head
        var currentNode = head
        for element in elements.dropFirst() {
            currentNode = Node(value: element)
            prevNode?.next = currentNode
            prevNode = currentNode
        }
        tail = currentNode
    }
    
    public var isEmpty: Bool {
        head == nil
    }
    
    /// prepend a value to the front of the list
    /// 
    /// >Time Complexity: O(1)
    public mutating func push(_ value: Value) {
        copyNodesIfNecessary()
        head = Node(value: value, next: head)
        if tail == nil {
            tail = head
        } 
    }

    /// append a value to the end of the list
    /// 
    /// >Time Complexity: O(1)
    public mutating func append(_ value: Value) {
        copyNodesIfNecessary()
        guard !isEmpty else {
            self.push(value)
            return
        }

        tail!.next = Node(value: value, next: nil)
        tail = tail!.next
    }
    
    /// returns the node at the given integer index (0-indexed)
    ///
    /// >Time Complexity: O(i) where i is the given index
    public func node(at index: Int) -> Node<Value>? {
        var currentIndex = 0
        var currentNode = self.head

        while currentIndex < index && currentNode != nil {
            currentIndex += 1
            currentNode = currentNode!.next
        }
        return currentNode
    }
    
    /// inserts a value after the given node
    ///
    /// >Time Complexity: O(1)
    ///
    /// >Precondition:
    /// >The given node must be a valid node from this linked list
    @discardableResult
    public mutating func insert(_ value: Value,
                                after node: Node<Value>) -> Node<Value> {
        guard tail !== node else {
            // input node is already the last value.
            // append a value after it
            append(value)
            return tail!
        }
        node.next = Node(value: value, next: node.next)
        guard let node = copyNodes(returningCopyOf: node) else {
            return node
        }
        return node.next!
        
    }
    
    /// Removes a value from the front of the linked list
    ///
    /// >Time Complexity: O(1)
    @discardableResult
    public mutating func pop() -> Value? {
        copyNodesIfNecessary()
        defer {
            head = head?.next
            if isEmpty { tail = nil }
        }
        return head?.value
    }
    
    /// Removes the last value
    ///
    /// >Time Complexity: O(n)
    @discardableResult
    public mutating func removeLast() -> Value? {
        copyNodesIfNecessary()
        guard let head else { return nil }
        guard head.next != nil else {
            return pop()
        }
        var prev = head
        var current = head
        
        while let next = current.next {
            prev = current
            current = next
        }
        prev.next = nil
        tail = prev
        return current.value
    }
    
    public mutating func removeAll() {
        head = nil
        tail = nil
    }
    
    /// Removes the last value after the given node, returning the removed value
    ///
    /// >Time Complexity: O(1)
    @discardableResult
    public mutating func remove(after node: Node<Value>) -> Value? {
        guard let node = copyNodes(returningCopyOf: node) else { return nil }
        defer {
            if node.next === tail {
                tail = node
            }
            node.next = node.next?.next
        }
        return node.next?.value
    }
    
    /// Creates new reference copies of each of the nodes (only if the linked list is referenced
    /// by more than one object).
    ///
    /// This method will do nothing if the references are already uniquely referenced.
    /// To be used for "Copy On Write" implementation.
    ///
    /// >Time Complexity:
    /// >O(n) if the copy is performed.
    /// >O(1) if the copy is skipped.
    mutating func copyNodesIfNecessary() {
        guard !isKnownUniquelyReferenced(&head) else {
            return
        }
        guard var oldNode = head else {
            return
        }
        head = Node(value: oldNode.value)
        var newNode = head
        
        while let nextOldNode = oldNode.next {
            newNode!.next = Node(value: nextOldNode.value)
            newNode = newNode!.next
            
            oldNode = nextOldNode
        }
        
        tail = newNode
    }
    
    /// Creates new reference copies of each of the nodes (only if the linked list is referenced
    /// by more than one object).
    ///
    /// Use this method if you need a reference to the new copy of the node. Otherwise use
    /// ``copyNodesIfNecessary()``.
    ///
    /// This method will do nothing if the references are already uniquely referenced.
    /// To be used for "Copy On Write" implementation.
    ///
    /// >Time Complexity:
    /// >O(n) if the copy is performed.
    /// >O(1) if the copy is skipped.
    mutating func copyNodes(returningCopyOf node: Node<Value>?) -> Node<Value>? {
        guard !isKnownUniquelyReferenced(&head) else {
            return nil
        }
        guard var oldNode = head else { return nil }
        
        head = Node(value: oldNode.value)
        var newNode = head
        var nodeCopy: Node<Value>?
        
        while let nextOldNode = oldNode.next {
            if oldNode === node {
                nodeCopy = newNode
            }
            newNode!.next = Node(value: nextOldNode.value)
            newNode = newNode!.next
            oldNode = nextOldNode
        }
        
        return nodeCopy
    }
    
    /// Returns a copy of the current linked list, reversed.
    ///
    /// >Room For Improvement:
    /// >This algorithm requires reallocating each node which increases memory usage
    /// >as well as longer computation time. A better solution can be found here: https://www.kodeco.com/books/data-structures-algorithms-in-swift/v3.0/chapters/7-linked-list-challenges#toc-chapter-010-anchor-001
    public func reversedLinkedList() -> Self {
        let reversedArray = self.reversed() // O(1)
        return Self(reversedArray) // O(n)
    }
    
    /// Returns the middle node of the linked list.
    ///
    /// If there are two middle nodes, then the later node will be returned.
    ///
    /// >Examples:
    /// >1 -> 2 -> 3 -> 4 -> nil
    /// >// middle is 3
    /// >
    /// >1 -> 2 -> 3 -> nil
    /// >// middle is 2
    public func middleNode() -> Node<Value>? {
        guard let head else { return nil }
        guard let tail else { return head }
        
        var traverser: Node<Value>? = head
        var fastTraverser: Node<Value>? = head // will traverse twice as fast
        while fastTraverser != nil && fastTraverser !== tail {
            fastTraverser = fastTraverser?.next?.next
            traverser = traverser?.next
        }
        return traverser
    }
    
    mutating public func append(_ listToAppend: Self) {
        self.tail?.next = listToAppend.head
        self.tail = listToAppend.tail
        copyNodesIfNecessary()
    }
}

extension LinkedList: CustomStringConvertible {
    public var description: String {
        guard let head else { return "EMPTY" }
        return String(describing: head)
    }
}

extension LinkedList {
    public class Node<V> {
        var value: V
        var next: Node<V>?
        init(value: V, next: Node<V>? = nil) {
            self.value = value
            self.next = next
        }
    }
}

extension LinkedList.Node: CustomStringConvertible {
    public var description: String {
        guard let next else { return "\(value)" }
        return "\(value) -> " + String(describing: next) + " "
    }
}
