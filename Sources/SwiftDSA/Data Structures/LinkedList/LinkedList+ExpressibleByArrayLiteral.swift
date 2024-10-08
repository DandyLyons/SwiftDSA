extension LinkedList: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Value...) {
        self.init(elements)
    }
    
    public typealias ArrayLiteralElement = Value
    
    
}
