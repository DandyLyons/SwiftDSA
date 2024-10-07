extension LinkedList: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Value...) {
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
    }
    
    public typealias ArrayLiteralElement = Value
    
    
}
