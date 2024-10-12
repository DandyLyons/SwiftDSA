extension QuadLinkedGrid: Equatable where Element: Equatable {
    
    public static func == (lhs: QuadLinkedGrid<Element>, rhs: QuadLinkedGrid<Element>) -> Bool {
        lhs.allElements == rhs.allElements &&
        lhs.rowsCount == rhs.rowsCount &&
        lhs.columnsCount == rhs.columnsCount
    }
    
    
}

extension QuadLinkedGrid.Node: Equatable where Value: Equatable {
    public static func == (
        lhs: QuadLinkedGrid<Element>.Node<Value>,
        rhs: QuadLinkedGrid<Element>.Node<Value>
    ) -> Bool {
        lhs.value == rhs.value &&
        
        lhs.up === rhs.up
    }
    
    
}
