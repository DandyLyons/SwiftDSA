import SwiftDSA
import Testing

@Suite
struct QuadLinkedGridTests {
    
    @Test(arguments: [
        (3, 3, 0, 9),
        (5, 7, 42, 35)
    ])
    func _init(rows: Int, columns: Int, defaultValue: Int, expectedCount: Int) {
        let grid = QuadLinkedGrid(rows: rows, columns: columns, defaultValue: defaultValue)
        #expect(grid.rowsCount == rows)
        #expect(grid.columnsCount == columns)
        let allElements = grid.allElements
        #expect(allElements.allSatisfy { $0 == defaultValue})
        #expect(allElements.count == expectedCount)
        
        let expectedRow = Array(repeating: defaultValue, count: columns)
        let expectedRows = Array(repeating: expectedRow, count: rows)
        #expect(grid.rows == expectedRows)
        
        let expectedColumn = Array(repeating: defaultValue, count: rows)
        let expectedColumns = Array(repeating: expectedColumn, count: columns)
        #expect(grid.columns == expectedColumns)
    }
    
    @Test
    func subscriptGetSet() {
        var grid = QuadLinkedGrid(rows: 5, columns: 5, defaultValue: 0)
        let x = Int.random(in: 0..<5)
        let y = Int.random(in: 0..<5)
        let randomInt = Int.random(in: 0...1_000)
        grid[x: x, y: y] = randomInt
        #expect(grid[x: x, y: y] == randomInt)
    }
    
    @Test
    func count() {
        let rows = Int.random(in: 0..<20)
        let columns = Int.random(in: 0..<20)
        let grid = QuadLinkedGrid(
            rows: rows,
            columns: columns,
            defaultValue: 0
        )
        #expect(grid.count == rows * columns)
    }
    
    @Test func rowAtIndex() {
        let grid = QuadLinkedGrid(rows: 5, columns: 5, defaultValue: 0)
        let firstRow = grid.row(at: 0)
        #expect(firstRow == [0, 0, 0, 0, 0])
    }
    
    @Test func columnAtIndex() {
        let grid = QuadLinkedGrid(rows: 5, columns: 5, defaultValue: 0)
        let firstColumn = grid.column(at: 0)
        #expect(firstColumn == [0, 0, 0, 0, 0])
    }
}
