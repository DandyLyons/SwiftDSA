import IssueReporting

extension XYGrid {
    public subscript(x: Int, y: Int) -> Element? {
        get { store[Coordinate(x: x, y: y)] }
        set  {
            guard x >= 0, x < rowsCount, y >= 0, y < columnsCount else {
                //                reportIssue("Invalid coordinate. x: \(x), y: \(y), \nrowsCount: \(rowsCount), columnsCount: \(columnsCount)")
                return // invalid coordinate, do nothing
            }
            store[Coordinate(x: x, y: y)] = newValue
            _assertIntegrity()
        }
    }
    
    public subscript(xy coordinate: Coordinate) -> Element? {
        get { store[coordinate] }
        set {
            guard coordinate.x >= 0, coordinate.x < rowsCount, coordinate.y >= 0,
                  coordinate.y < columnsCount else {
                reportIssue("Invalid coordinate. x: \(coordinate.x), y: \(coordinate.y), \nrowsCount: \(rowsCount), columnsCount: \(columnsCount)")
                return // invalid coordinate, do nothing
            }
            store[coordinate] = newValue
            _assertIntegrity()
        }
    }
    
    
    public subscript(row rowIndex: Int) -> [Element] {
        get {
            self.row(at: rowIndex)
        }
        set {
            self.setRow(at: rowIndex, to: newValue)
        }
    }
    
    public subscript(column columnIndex: Int) -> [Element] {
        get {
            self.column(at: columnIndex)
        }
        set {
            self.setColumn(at: columnIndex, to: newValue)
        }
    }
}
