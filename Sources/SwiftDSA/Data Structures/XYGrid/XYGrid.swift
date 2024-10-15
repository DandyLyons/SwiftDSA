
extension XYGrid: Sendable where Element: Sendable {}
extension XYGrid: Equatable where Element: Equatable {}
extension XYGrid: Hashable where Element: Hashable {}
public struct XYGrid<Element> {
    public typealias Store = [Coordinate: Element]
    var store: Store

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
    
    public init(rowsCount: Int, columnsCount: Int, values: some Sequence<Element>, defaultValue: Element) {
        self.init(rowsCount: rowsCount, columnsCount: columnsCount, defaultValue: defaultValue)
        for value in values {
            for row in 0..<rowsCount {
                for column in 0..<columnsCount {
                    self[column, row] = value
                }
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




