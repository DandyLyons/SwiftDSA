
extension XYGrid: Sendable where Element: Sendable {}
extension XYGrid: Equatable where Element: Equatable {}
extension XYGrid: Hashable where Element: Hashable {}
public struct XYGrid<Element> {
    public typealias Store = [Coordinate: Element]
    private(set) public var store: Store

    public init(rowsCount: Int, columnsCount: Int, defaultValue: Element) {
        self.store = Store()
        self.rowsCount = rowsCount
        self.columnsCount = columnsCount
        
        for x in 0..<rowsCount {
            for y in 0..<columnsCount {
                store[Coordinate(x: x, y: y)] = defaultValue
            }
        }
    }

    /// The number of rows in the grid. 
    /// 
    /// This is the number of elements in each column.
    /// This number is always one more than the maximum y value in the grid.
    public let rowsCount: Int

    /// The number of columns in the grid
    /// 
    /// This is the number of elements in each row.
    /// This number is always one more than the maximum x value in the grid.
    public let columnsCount: Int
    
    public var count: Int {
        rowsCount * columnsCount
    }
    
    public subscript(x: Int, y: Int) -> Element? {
        get { store[Coordinate(x: x, y: y)] }
        set  { 
            guard x >= 0, x < rowsCount, y >= 0, y < columnsCount else {
                return // invalid coordinate, do nothing
            }
            store[Coordinate(x: x, y: y)] = newValue 
        }
    }
    
    /// returns the elemends in a given row sorted from left to right
    public func row(at rowIndex: Int) -> [Element] {
        store.filter { $0.key.y == rowIndex }
            .sorted(by: { $0.key.x < $1.key.x })
            .map(\.value)
    }

    public func rowAndXY(at rowIndex: Int) -> [Store.Element] {
        store.filter { $0.key.y == rowIndex }
            .sorted(by: { $0.key.x < $1.key.x })
    }
    
    public var rows: [[Element]] {
        var rows = [[Element]]()
        
        for rowIndex in 0..<rowsCount {
            var currentRow = [Element]()
            for columnIndex in 0..<columnsCount {
                guard let value = store[Coordinate(x: columnIndex, y: rowIndex)] else {
                    assertionFailure("It should not be possible to use an invalid coordinate here.")
                    continue
                }
                currentRow.append(value)
            }
            rows.append(currentRow)
        }
        return rows
    }
    
    public var columns: [[Element]] {
        var columns = [[Element]]()
        
        for columnsIndex in 0..<columnsCount {
            var currentColumn = [Element]()
            for rowIndex in 0..<rowsCount {
                guard let value = store[Coordinate(x: columnsIndex, y: rowIndex)] else {
                    assertionFailure("It should not be possible to use an invalid coordinate here.")
                    continue
                }
                currentColumn.append(value)
            }
            columns.append(currentColumn)
        }
        return columns
    }
    
    
    
    public func column(at columnIndex: Int) -> [Element] {
        store.filter { $0.key.x == columnIndex }
            .sorted(by: { $0.key.y < $1.key.y })
            .map(\.value)
    }

    public func columnAndXY(at columnIndex: Int) -> [Store.Element] {
        store.filter { $0.key.x == columnIndex }
            .sorted(by: { $0.key.y < $1.key.y })
    }
}

extension XYGrid {
    public struct Coordinate: Hashable, Sendable {
        public var x: Int
        public var y: Int
        
        public init(x: Int, y: Int) {
            self.x = x
            self.y = y
        }
    }
}

// MARK: Swapping
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
