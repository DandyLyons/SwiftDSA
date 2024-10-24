
extension XYGrid {
    
    /// A type representing a series of coordinates, and their corresponding new values
    public struct Transformation {
        public let coord: Coordinate
        public let newValue: Element
        public init(x: Int, y: Int, _ newValue: Element) {
            self.coord = Coordinate(x: x, y: y)
            self.newValue = newValue
        }
    }
    
    
    //    public mutating func transform(_ transformations: Transformation) {
    //        for (coord, newValue) in transformations {
    //            setCell(at: coord, to: newValue)
    //        }
    //    }
    //
    public func transformed(by transformations: [Transformation]) -> Self {
        var newXYGrid = self
        for transformation in transformations {
            newXYGrid.setCell(at: transformation.coord, to: transformation.newValue)
        }
        return newXYGrid
    }
}

extension XYGrid.Transformation: Equatable where Element: Equatable {}
extension XYGrid.Transformation: Hashable where Element: Hashable {}
