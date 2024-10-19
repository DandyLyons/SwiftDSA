extension XYGrid: Sequence  {
    public var count: Int {
        rowsCount * columnsCount
    }
    
    public func makeIterator() -> XYGrid.Iterator {
        Iterator(self.cells)
    }
}

extension XYGrid {
    public struct Iterator: IteratorProtocol {
        private var currentIndex = 0
        private let elements: [XYGrid.Element]
        
        init(_ elements: [XYGrid.Element]) {
            self.elements = elements
        }
        
        mutating public func next() -> Element? {
            guard currentIndex < elements.count else {
                return nil
            }
            
            let element = elements[currentIndex]
            currentIndex += 1
            return element
        }
    }
}
