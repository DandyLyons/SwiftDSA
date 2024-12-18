import IssueReporting
import XCTest

extension XYGrid: Sendable where Element: Sendable {}
extension XYGrid: Equatable where Element: Equatable {}
extension XYGrid: Hashable where Element: Hashable {}
extension XYGrid: Codable where Element: Codable {}

public struct XYGrid<Element> {
    public typealias Store = [Coordinate: Element]
    var store: Store
    let defaultValue: Element
    
    public init(rowsCount: Int, columnsCount: Int, defaultValue: Element) {
        self.store = Store()
        self.rowsCount = rowsCount
        self.columnsCount = columnsCount
        self.defaultValue = defaultValue
        
        for x in 0..<rowsCount {
            for y in 0..<columnsCount {
                store[Coordinate(x: x, y: y)] = defaultValue
            }
        }
    }
    
    public init(rowsCount: Int, columnsCount: Int, values: [Element], defaultValue: Element) {
        precondition(rowsCount * columnsCount == values.count, "This is an invalid XYGrid.")
        self.init(rowsCount: rowsCount, columnsCount: columnsCount, defaultValue: defaultValue)
        var currentValueIndex = 0
        
        for row in 0..<rowsCount {
            for column in 0..<columnsCount {
                self[column, row] = values[currentValueIndex]
                currentValueIndex += 1
            }
        }
    }
    
    func _assertIntegrity() {
        let isCorrect =
        store.count == self.count &&
        self.rows.count == self.rowsCount &&
        self.columns.count == self.columnsCount
        
        let message = """
Integrity check failed for XYGrid.
XYGrid Count: \(count), Store Count: \(store.count)
self.rowsCount: \(rowsCount), self.rows.count: \(self.rows.count)
self.columnsCount: \(columnsCount), self.columns.count: \(self.columns.count)
"""
        //        XCTFail(message)
        //        assert(isCorrect, message)
        if !isCorrect { reportIssue(message) }
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
    
    public var lastRowIndex: Int { rowsCount - 1 }
    public var lastColumnIndex: Int { columnsCount - 1 }
    
    public func getCell(at coord: Coordinate) -> Element? {
        self[xy: coord]
    }
    
    public mutating func setCell(at coord: Coordinate, to newValue: Element) {
        self[xy: coord] = newValue
        _assertIntegrity()
    }
    
    /// returns the elements in a given row sorted from left to right
    public func row(at rowIndex: Int) -> [Element] {
        store.filter { $0.key.y == rowIndex }
            .sorted(by: { $0.key.x < $1.key.x })
            .map(\.value)
    }
    
    /// sets the elements in the row to the new value.
    ///
    /// >Precondition: The count of elements in the given `newValues` array must equal the `columnsCount`.
    public mutating func setRow(at index: Int, to newValues: [Element]) {
        precondition(newValues.count == columnsCount)
        let dest = rowAndXY(at: index)
        for (i, value) in newValues.enumerated() {
            let destCellCoord = dest[i].key
            self[xy: destCellCoord] = value
        }
        _assertIntegrity()
    }
    
    /// returns the elements and coordinates in a given row sorted from left to right
    public func rowAndXY(at rowIndex: Int) -> [Store.Element] {
        store.filter { $0.key.y == rowIndex }
            .sorted(by: { $0.key.x < $1.key.x })
    }
    
    public var cells: [Element] {
        var result = [Element]()
        for rowIndex in 0..<rowsCount {
            for columnIndex in 0..<columnsCount {
                let coord = Coordinate(x: columnIndex, y: rowIndex)
                let value = store[coord]!
                result.append(value)
            }
        }
        return result
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
    
    public var rowsAndXY: [[Store.Element]] {
        var result = [[Store.Element]]()
        for row in 0..<rowsCount {
            result.append(self.rowAndXY(at: row))
        }
        return result
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
    
    public var columnsAndXY: [[Store.Element]] {
        var result = [[Store.Element]]()
        for column in 0..<columnsCount {
            result.append(self.columnAndXY(at: column))
        }
        return result
    }
    
    public func column(at columnIndex: Int) -> [Element] {
        store.filter { $0.key.x == columnIndex }
            .sorted(by: { $0.key.y < $1.key.y })
            .map(\.value)
    }
    
    /// sets the elements in the column to the new value.
    ///
    /// >Precondition: The count of elements in the given `newValues` array must equal the `rowsCount`.
    public mutating func setColumn(at index: Int, to newValues: [Element]) {
        precondition(newValues.count == rowsCount)
        let dest = columnAndXY(at: index)
        for (i, value) in newValues.enumerated() {
            let destCellCoord = dest[i].key
            self[xy: destCellCoord] = value
        }
        _assertIntegrity()
    }
    
    public func columnAndXY(at columnIndex: Int) -> [Store.Element] {
        store.filter { $0.key.x == columnIndex }
            .sorted(by: { $0.key.y < $1.key.y })
    }
}
