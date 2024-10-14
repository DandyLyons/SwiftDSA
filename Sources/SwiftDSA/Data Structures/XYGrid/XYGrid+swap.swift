extension XYGrid {
    public enum SwapResult: Sendable {
        /// successfully swapped
        case success
        /// the left hand side was an invalid coordinate
        case lhsInvalid
        /// the right hand side was an invalid coordinate
        case rhsInvalid
        /// both coordinates were invalid
        case bothInvalid
    }
    
    @discardableResult
    public mutating func swap(_ lhs: Coordinate, and rhs: Coordinate) -> SwapResult {
        guard store[lhs] != nil else {
            if store[rhs] != nil {
                return .lhsInvalid
            } else {
                return .bothInvalid
            }
        }
        
        guard store[rhs] != nil else {
            if store[lhs] != nil {
                return .rhsInvalid
            } else {
                return .bothInvalid
            }
        }
        
        (store[lhs], store[rhs]) = (store[rhs], store[lhs])
        return .success
    }
    
    public mutating func swapRow(_ lhs: Int, and rhs: Int) {
        for x in 0..<columnsCount {
            let leftXY = Coordinate(x: x, y: lhs)
            let rightXY = Coordinate(x: x, y: rhs)
            (store[leftXY], store[rightXY]) = (store[rightXY], store[leftXY])
        }
    }
    
    public mutating func swapColumn(_ lhs: Int, and rhs: Int) {
        for y in 0..<rowsCount {
            let leftXY = Coordinate(x: lhs, y: y)
            let rightXY = Coordinate(x: rhs, y: y)
            (store[leftXY], store[rightXY]) = (store[rightXY], store[leftXY])
        }
    }
}
