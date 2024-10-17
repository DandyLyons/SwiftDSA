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
        var shiftsRemaining = shiftAmount
        var currentIndex = index
        
        // helper function to guarantee that the index is always within bounds after mutation
        func decreaseAndNormalizeCurrentIndex() {
            currentIndex -= 1
            if currentIndex < 0 {
                switch shiftType {
                    case .column: currentIndex = columnsCount - 1 // last column
                    case .row: currentIndex = rowsCount - 1 // last row
                }
            }
        }
        
        func increaseAndNormalizeCurrentIndex() {
            currentIndex += 1
            let max = switch shiftType {
                case .column: columnsCount - 1 // last column
                case .row: rowsCount - 1 // last row
            }
            if currentIndex > max { currentIndex = 0 }
        }
        
        while shiftsRemaining > 0 {
            switch (shiftType, direction) {
            // INLINE SHIFTS
                case (.row, .left):
                    shiftRowLeft(rowIndex: currentIndex)
                case (.row, .right):
                    shiftRowRight(rowIndex: currentIndex)
                case (.column, .up):
                    shiftColumnUp(columnIndex: currentIndex)
                case (.column, .down):
                    shiftColumnDown(columnIndex: currentIndex)
                    
            // OUT OF LINE SHIFTS
                case (.row, .up):
                    shiftRowUp(rowIndex: currentIndex)
                    decreaseAndNormalizeCurrentIndex()
                case (.row, .down):
                    shiftRowDown(rowIndex: currentIndex)
                    increaseAndNormalizeCurrentIndex()
                case (.column, .left):
                    shiftColumnLeft(columnIndex: currentIndex)
                    decreaseAndNormalizeCurrentIndex()
                case (.column, .right):
                    shiftColumnRight(columnIndex: currentIndex)
                    increaseAndNormalizeCurrentIndex()
            }
            shiftsRemaining -= 1
        }
        
        _assertIntegrity()
        
        switch shiftType {
            case .row:
                return rowAndXY(at: index)
            case .column:
                return columnAndXY(at: index)
        }
    }
    
    // MARK: Inline Shifts
    
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
        let lastXY = Coordinate(x: columnsCount - 1, y: rowIndex)
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
        let lastXY = Coordinate(x: columnIndex, y: rowsCount - 1)
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
    
    // MARK: Out of line shifts
    
    /// Shifts the row at the given index up by one position.
    ///
    /// - Parameter rowIndex:
    ///  The index of the row to shift
    ///
    /// The row will swap with the row above it, or it will become the last row if it was the first row.
    public mutating func shiftRowUp(rowIndex: Int) {
        // if the rowIndex is the first row then swap with the last row
        // otherwise swap with the row above
        
        if rowIndex == 0 {
            // this is the first row
            // shift all the other rows up by one row
            // and move the first row to the bottom
            
            let allRows = self.rows // copy all the rows BEFORE mutation
            
            // iterate from last row to second row
            for i in (1...lastRowIndex).reversed() {
                let source = allRows[i]
                self.setRow(at: i - 1, to: source) // shift all other rows up
            }
            
            self.setRow(at: lastRowIndex, to: allRows[0]) // move first row to bottom
        } else {
            // this is NOT the first row
            let dest = rowIndex - 1
            self.swapRow(rowIndex, and: dest)
        }
    }
    
    /// Shifts the row at the given index down by one position.
    ///
    /// - Parameter rowIndex:
    ///  The index of the row to shift
    ///
    /// The row will swap with the row below it, or it will become the first row if it was the last row.
    public mutating func shiftRowDown(rowIndex: Int) {
        // if the rowIndex is the last row then swap with the first row
        // otherwise swap with the row below
        
        if rowIndex == lastRowIndex {
            // this is the last row
            // shift all the other rows down by one row
            // and move the last row to the top
            
            let allRows = self.rows // copy all the rows BEFORE mutation
            
            // iterate from first row to second-to-last row
            for i in 0..<lastRowIndex {
                let source = allRows[i]
                self.setRow(at: i + 1, to: source) // shift all other rows down
            }
            
            self.setRow(at: 0, to: allRows[lastRowIndex]) // move last row to top
        } else {
            // this is NOT the last row
            let dest = rowIndex + 1
            self.swapRow(rowIndex, and: dest)
        }
    }
    
    /// Shifts the column at the given index to the left by one position.
    ///
    /// - Parameter columnIndex:
    ///   The index of the column to shift
    ///
    /// The column will swap with the column to the left of it, or it will become the last column if it was the first column.
    public mutating func shiftColumnLeft(columnIndex: Int) {
        // if the columnIndex is the first column then swap with the last column
        // otherwise swap with the column to the left

        if columnIndex == 0 {
            // this is the first column
            // shift all the other columns left by one column
            // and move the first column to the rightmost column
            
            let allColumns = self.columns // copy all the columns BEFORE mutation
            
            // iterate from last column to second column
            for i in (1...lastColumnIndex).reversed() {
                let source = allColumns[i]
                self.setColumn(at: i - 1, to: source) // shift all other columns left
            }
            
            self.setColumn(at: lastColumnIndex, to: allColumns[0]) // move first column to rightmost
        } else {
            // this is NOT the first column
            let dest = columnIndex - 1
            self.swapColumn(columnIndex, and: dest)
        }
    }
    
    /// Shifts the column at the given index to the right by one position.
    ///
    /// - Parameter columnIndex:
    ///  The index of the column to shift
    ///
    /// The column will swap with the column to the right of it, or it will become the first column if it was the last column.
    public mutating func shiftColumnRight(columnIndex: Int) {
        // if the columnIndex is the last column then swap with the first column
        // otherwise swap with the column to the right
        
        if columnIndex == lastColumnIndex {
            // this is the last column
            // shift all the other columns right by one column
            // and move the last column to the leftmost column
            
            let allColumns = self.columns // copy all the columns BEFORE mutation
            
            // iterate from first column to second-to-last column
            for i in 0..<lastColumnIndex {
                let source = allColumns[i]
                self.setColumn(at: i + 1, to: source) // shift all other columns right
            }
            
            self.setColumn(at: 0, to: allColumns[lastColumnIndex]) // move last column to leftmost
        } else {
            // this is NOT the last column
            let dest = columnIndex + 1
            self.swapColumn(columnIndex, and: dest)
        }
    }
}
