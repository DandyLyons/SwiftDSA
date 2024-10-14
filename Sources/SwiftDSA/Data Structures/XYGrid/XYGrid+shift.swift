// MARK: Shifting
extension XYGrid {
    public enum ShiftType: Sendable { case row, column }
    public enum ShiftDirection: Sendable { case up, down, left, right }
    
    @discardableResult
    public mutating func shift(
        _ shiftType: ShiftType,
        at index: Int,
        _ direction: ShiftDirection,
        by shiftAmount: Int = 1
    ) -> [Store.Element] {
        var shiftsLeft = shiftAmount
        
        while shiftsLeft > 0 {
            switch (shiftType, direction) {
                case (.row, .left):
                    shiftRowLeft(rowIndex: index)
                case (.row, .right):
                    shiftRowRight(rowIndex: index)
                case (.row, .up):
                    shiftRowUp(rowIndex: index)
                case (.row, .down):
                    shiftRowDown(rowIndex: index)
                case (.column, .left):
                    shiftColumnLeft(columnIndex: index)
                case (.column, .right):
                    shiftColumnRight(columnIndex: index)
                case (.column, .up):
                    shiftColumnUp(columnIndex: index)
                case (.column, .down):
                    shiftColumnDown(columnIndex: index)
            }
            shiftsLeft -= 1
        }
        
        switch shiftType {
            case .row:
                return rowAndXY(at: index)
            case .column:
                return columnAndXY(at: index)
        }
    }
    
    /// Shifts the row at the given index to the left by one position.
    ///
    /// - Parameter rowIndex:
    ///    The index of the row to shift
    ///
    /// The leftmost element will be moved to the rightmost position.
    public mutating func shiftRowLeft(rowIndex: Int) {
        let rowAndXY = self.rowAndXY(at: rowIndex)
        
        for cell in rowAndXY {
            if cell.key.x == 0 {
                continue // this is the first cell. Skip and move on.
            } else {
                let dest = Coordinate(x: cell.key.x - 1, y: cell.key.y)
                store[dest] = cell.value
            }
        }
        
        // move the leftmost element to the rightmost position
        let first = rowAndXY.first!
        let lastXY = Coordinate(x: columnsCount, y: rowIndex)
        store[lastXY] = first.value
    }
    
    /// Shifts the row at the given index to the right by one position.
    ///
    /// - Parameter rowIndex:
    ///   The index of the row to shift
    ///
    /// The rightmost element will be moved to the leftmost position.
    public mutating func shiftRowRight(rowIndex: Int) {
        let rowAndXY = self.rowAndXY(at: rowIndex)
        
        for cell in rowAndXY {
            if cell.key.x == columnsCount - 1 {
                continue // this is the last cell. Skip and move on.
            } else {
                let dest = Coordinate(x: cell.key.x + 1, y: cell.key.y)
                store[dest] = cell.value
            }
        }
        
        // move the rightmost element to the leftmost position
        let last = rowAndXY.last!
        let firstXY = Coordinate(x: 0, y: rowIndex)
        store[firstXY] = last.value
    }
    
    /// Shifts the row at the given index up by one position.
    ///
    /// - Parameter rowIndex:
    ///  The index of the row to shift
    ///
    /// The row will swap with the row above it.
    public mutating func shiftRowUp(rowIndex: Int) {
        self.swapRow(rowIndex, and: rowIndex - 1)
    }
    
    /// Shifts the row at the given index down by one position.
    ///
    /// - Parameter rowIndex:
    ///  The index of the row to shift
    ///
    /// The row will swap with the row below it.
    public mutating func shiftRowDown(rowIndex: Int) {
        self.swapRow(rowIndex, and: rowIndex + 1)
    }
    
    /// Shifts the column at the given index to the left by one position.
    ///
    /// - Parameter columnIndex:
    ///   The index of the column to shift
    ///
    /// The column will swap with the column to the left of it.
    public mutating func shiftColumnLeft(columnIndex: Int) {
        self.swapColumn(columnIndex, and: columnIndex - 1)
    }
    
    /// Shifts the column at the given index to the right by one position.
    ///
    /// - Parameter columnIndex:
    ///  The index of the column to shift
    ///
    /// The column will swap with the column to the right of it.
    public mutating func shiftColumnRight(columnIndex: Int) {
        self.swapColumn(columnIndex, and: columnIndex + 1)
    }
    
    /// Shifts the column at the given index up by one position.
    ///
    /// - Parameter columnIndex:
    ///   The index of the column to shift
    ///
    /// The topmost element will be moved to the bottommost position.
    public mutating func shiftColumnUp(columnIndex: Int) {
        // Implemented just like shift row left except we are shifting a column up
        
        let columnAndXY = self.columnAndXY(at: columnIndex)
        
        for cell in columnAndXY {
            if cell.key.y == 0 {
                continue // this is the first cell. Skip and move on.
            } else {
                let dest = Coordinate(x: cell.key.x, y: cell.key.y - 1)
                store[dest] = cell.value
            }
        }
        
        // move the topmost element to the bottommost position
        let first = columnAndXY.first!
        let lastXY = Coordinate(x: columnIndex, y: rowsCount)
        store[lastXY] = first.value
    }
    
    /// Shifts the column at the given index down by one position.
    ///
    /// - Parameter columnIndex:
    ///  The index of the column to shift
    ///
    /// The bottommost element will be moved to the topmost position.
    public mutating func shiftColumnDown(columnIndex: Int) {
        // Implemented just like shift row right except we are shifting a column down
        
        let columnAndXY = self.columnAndXY(at: columnIndex)
        
        for cell in columnAndXY {
            if cell.key.y == rowsCount - 1 {
                continue // this is the last cell. Skip and move on.
            } else {
                let dest = Coordinate(x: cell.key.x, y: cell.key.y + 1)
                store[dest] = cell.value
            }
        }
        
        // move the bottommost element to the topmost position
        let last = columnAndXY.last!
        let firstXY = Coordinate(x: columnIndex, y: 0)
        store[firstXY] = last.value
    }
}
