import SwiftDSA
import Testing

@Suite struct XYGridTests {
    typealias Coordinate = XYGrid<Int>.Coordinate
    
    static let startingPoint: XYGrid<Int> = {
        var grid = XYGrid<Int>(rowsCount: 3, columnsCount: 3, defaultValue: 0)
        grid[0, 0] = 1
        grid[1, 0] = 2
        grid[2, 0] = 3
        grid[0, 1] = 4
        grid[1, 1] = 5
        grid[2, 1] = 6
        grid[0, 2] = 7
        grid[1, 2] = 8
        grid[2, 2] = 9
        return grid
    }()

    @Test func _init() {
        let grid = Self.startingPoint
        #expect(grid.store.count == 9)
        #expect(grid.rowsCount == 3)
        #expect(grid.columnsCount == 3)
    }

    @Test func rowAtFunc() {
        let grid = Self.startingPoint
        #expect(grid.row(at: 0) == [1, 2, 3])
        #expect(grid.row(at: 1) == [4, 5, 6])
        #expect(grid.row(at: 2) == [7, 8, 9])
    }

    @Test func rowAndXYAtFunc() {
        let grid = Self.startingPoint
        var rowAndXY: [[(key: Coordinate, value: Int)]] = []
        for y in 0..<grid.rowsCount {
            rowAndXY.append(grid.rowAndXY(at: y))
        }
        
        let expected = [
            [
                (key: Coordinate(x: 0, y: 0), value: 1),
                (key: Coordinate(x: 1, y: 0), value: 2),
                (key: Coordinate(x: 2, y: 0), value: 3)
            ],
            [
                (key: Coordinate(x: 0, y: 1), value: 4),
                (key: Coordinate(x: 1, y: 1), value: 5),
                (key: Coordinate(x: 2, y: 1), value: 6)
            ],
            [
                (key: Coordinate(x: 0, y: 2), value: 7),
                (key: Coordinate(x: 1, y: 2), value: 8),
                (key: Coordinate(x: 2, y: 2), value: 9)
            ],
        ]
        
        for (expectedRow, actualRow) in zip(expected, rowAndXY) {
            for (expected, actual) in zip(expectedRow, actualRow) {
                #expect(expected == actual)
            }
        }
    }

    @Test func rowsVar() {
        let grid = Self.startingPoint
        #expect(grid.rows == [
            [1, 2, 3],
            [4, 5, 6],
            [7, 8, 9]
        ])
    }

    @Test func columnAtFunc() {
        let grid = Self.startingPoint
        #expect(grid.column(at: 0) == [1, 4, 7])
        #expect(grid.column(at: 1) == [2, 5, 8])
        #expect(grid.column(at: 2) == [3, 6, 9])
    }

   @Test func columnAndXYAtFunc() {
        let grid = Self.startingPoint
        var columnAndXY: [[(key: Coordinate, value: Int)]] = []
        for x in 0..<grid.columnsCount {
            columnAndXY.append(grid.columnAndXY(at: x))
        }
        
        let expected = [
            [
                (key: Coordinate(x: 0, y: 0), value: 1),
                (key: Coordinate(x: 0, y: 1), value: 4),
                (key: Coordinate(x: 0, y: 2), value: 7)
            ],
            [
                (key: Coordinate(x: 1, y: 0), value: 2),
                (key: Coordinate(x: 1, y: 1), value: 5),
                (key: Coordinate(x: 1, y: 2), value: 8)
            ],
            [
                (key: Coordinate(x: 2, y: 0), value: 3),
                (key: Coordinate(x: 2, y: 1), value: 6),
                (key: Coordinate(x: 2, y: 2), value: 9)
            ],
        ]
        
        for (expectedColumn, actualColumn) in zip(expected, columnAndXY) {
            for (expected, actual) in zip(expectedColumn, actualColumn) {
                #expect(expected == actual)
            }
        }
   }

    @Test func columnsVar() {
        let grid = Self.startingPoint
        #expect(grid.columns == [
            [1, 4, 7],
            [2, 5, 8],
            [3, 6, 9]
        ])
    }

    @Test func subscriptGet() {
        let grid = Self.startingPoint
        #expect(grid[0,0] == 1)
        #expect(grid[1,0] == 2)
        #expect(grid[2,0] == 3)
        #expect(grid[0,1] == 4)
        #expect(grid[1,1] == 5)
        #expect(grid[2,1] == 6)
        #expect(grid[0,2] == 7)
        #expect(grid[1,2] == 8)
        #expect(grid[2,2] == 9)
    }

    @Test func subscriptSet() {
        var grid = Self.startingPoint
        grid[0,0] = 10
        grid[1,0] = 11
        grid[2,0] = 12
        grid[0,1] = 13
        grid[1,1] = 14
        grid[2,1] = 15
        grid[0,2] = 16
        grid[1,2] = 17
        grid[2,2] = 18
        
        #expect(grid[0,0] == 10)
        #expect(grid[1,0] == 11)
        #expect(grid[2,0] == 12)
        #expect(grid[0,1] == 13)
        #expect(grid[1,1] == 14)
        #expect(grid[2,1] == 15)
        #expect(grid[0,2] == 16)
        #expect(grid[1,2] == 17)
        #expect(grid[2,2] == 18)
    }

    @Test func subscriptGetWithInvalidCoordinate() {
        let grid = Self.startingPoint
        #expect(grid[0, 3] == nil)
        #expect(grid[3, 0] == nil)
        #expect(grid[3, 3] == nil)
    }

    @Test func subscriptSetWithInvalidCoordinate() {
        var grid = Self.startingPoint
        grid[0, 3] = 10
        grid[3, 0] = 11
        grid[3, 3] = 12

        #expect(grid[0,3] == nil)
        #expect(grid[3,0] == nil)
        #expect(grid[3,3] == nil)
    }

    @Test(arguments: [
        (Coordinate(x: 0, y: 0), Coordinate(x: 1, y: 0), XYGrid<Int>.SwapResult.success),
    ]) func swap(_ lhs: Coordinate, and rhs: Coordinate, _ expected: XYGrid<Int>.SwapResult) {
        var grid = Self.startingPoint
        let lhsBefore = grid[lhs.x, lhs.y]
        let rhsBefore = grid[rhs.x, rhs.y]
        let result = grid.swap(lhs, and: rhs)
        let lhsAfter = grid[lhs.x, lhs.y]
        let rhsAfter = grid[rhs.x, rhs.y]

        #expect(result == expected)
        if result == .success {
            #expect(lhsBefore == rhsAfter)
            #expect(rhsBefore == lhsAfter)
        } else {
            #expect(lhsBefore == lhsAfter)
            #expect(rhsBefore == rhsAfter)
        }
    }

    @Test func swapRow() {
        var grid = Self.startingPoint
        grid.swapRow(0, and: 2)
        #expect(grid[0, 0] == 7)
        #expect(grid[1, 0] == 8)
        #expect(grid[2, 0] == 9)
        #expect(grid[0, 1] == 4)
        #expect(grid[1, 1] == 5)
        #expect(grid[2, 1] == 6)
        #expect(grid[0, 2] == 1)
        #expect(grid[1, 2] == 2)
        #expect(grid[2, 2] == 3)
    }
}
