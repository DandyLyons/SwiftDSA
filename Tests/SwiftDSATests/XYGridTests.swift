import CustomDump
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
    
    /// This type is just created because we can't conform tuples to Equatable
    struct KeyAndValue: Equatable {
        let key: Coordinate
        let value: Int
    }
    
    static let rowsAndXY = [
        [
            KeyAndValue(key: .init(x: 0, y: 0), value: 1),
            KeyAndValue(key: .init(x: 1, y: 0), value: 2),
            KeyAndValue(key: .init(x: 2, y: 0), value: 3)
        ],
        [
            KeyAndValue(key: .init(x: 0, y: 1), value: 4),
            KeyAndValue(key: .init(x: 1, y: 1), value: 5),
            KeyAndValue(key: .init(x: 2, y: 1), value: 6)
        ],
        [
            KeyAndValue(key: .init(x: 0, y: 2), value: 7),
            KeyAndValue(key: .init(x: 1, y: 2), value: 8),
            KeyAndValue(key: .init(x: 2, y: 2), value: 9)
        ],
    ]

    static let columnsAndXY = [
        [
            KeyAndValue(key: .init(x: 0, y: 0), value: 1),
            KeyAndValue(key: .init(x: 0, y: 1), value: 4),
            KeyAndValue(key: .init(x: 0, y: 2), value: 7)
        ],
        [
            KeyAndValue(key: .init(x: 1, y: 0), value: 2),
            KeyAndValue(key: .init(x: 1, y: 1), value: 5),
            KeyAndValue(key: .init(x: 1, y: 2), value: 8)
        ],
        [
            KeyAndValue(key: .init(x: 2, y: 0), value: 3),
            KeyAndValue(key: .init(x: 2, y: 1), value: 6),
            KeyAndValue(key: .init(x: 2, y: 2), value: 9)
        ],
    ]
    
    @Test func _init() {
        let grid = Self.startingPoint
        #expect(grid.count == 9)
        #expect(grid.rowsCount == 3)
        #expect(grid.columnsCount == 3)
    }
    
    @Test func initWithValues() {
        let expected = Self.startingPoint
        let actual = XYGrid<Int>(rowsCount: 3, columnsCount: 3, values: [1, 2, 3, 4, 5, 6, 7, 8, 9], defaultValue: 0)
        #expect(actual == expected)
        #expect(actual.rowsCount == 3)
        #expect(actual.columnsCount == 3)
        #expect(actual.count == 9)
    }
    
    @Test func rowAtFunc() {
        let grid = Self.startingPoint
        #expect(grid.row(at: 0) == [1, 2, 3])
        #expect(grid.row(at: 1) == [4, 5, 6])
        #expect(grid.row(at: 2) == [7, 8, 9])
    }
    
    @Test(arguments: [
        (0, [11, 22, 33], [[11, 22, 33], [4, 5, 6], [7, 8, 9]]),
        (1, [44, 55, 66], [[1, 2, 3], [44, 55, 66], [7, 8, 9]]),
        (2, [77, 88, 99], [[1, 2, 3], [4, 5, 6], [77, 88, 99]])
    ])
    func setRowAtFunc(rowIndex: Int, newRow: [Int], expectedRows: [[Int]]) {
        var grid = Self.startingPoint
        grid.setRow(at: rowIndex, to: newRow)
        #expect(expectedRows == grid.rows)
    }
    
    @Test func rowsAndXYVar() {
        let grid = Self.startingPoint
        let expected = Self.rowsAndXY
        
        // convert tuple to KeyAndValue so that we can conform to equatable for the test
        let gridKeyAndValue = grid.rowsAndXY.map {
            $0.map { elem in
                KeyAndValue(key: elem.key, value: elem.value)
            }
        }
        expectNoDifference(gridKeyAndValue, expected)
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

    @Test(arguments: [
        (0, [11, 44, 77], [[11, 2, 3], [44, 5, 6], [77, 8, 9]]),
        (1, [22, 55, 88], [[1, 22, 3], [4, 55, 6], [7, 88, 9]]),
        (2, [33, 66, 99], [[1, 2, 33], [4, 5, 66], [7, 8, 99]])
    ])
    func setColumnAtFunc(columnIndex: Int, newColumn: [Int], expectedRows: [[Int]]) {
        var grid = Self.startingPoint
        grid.setColumn(at: columnIndex, to: newColumn)
        #expect(expectedRows == grid.rows)
    }
    
    @Test func columnsAndXYVar() {
        let grid = Self.startingPoint
        let expected = Self.columnsAndXY

        // convert tuple to KeyAndValue so that we can conform to equatable for the test
        let gridKeyAndValue = grid.columnsAndXY.map {
            $0.map { elem in
                KeyAndValue(key: elem.key, value: elem.value)
            }
        }
        expectNoDifference(gridKeyAndValue, expected)
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
    
    @Test func subscriptRow() {
        var grid = Self.startingPoint
        grid[row: 1] = [0, 0, 0]
        #expect(grid[row: 1] == [0, 0, 0])
        let expectedRows = [
            [1, 2, 3],
            [0, 0, 0],
            [7, 8, 9]
        ]
        #expect(grid.rows == expectedRows)
    }
    
    @Test func subscriptColumn() {
        var grid = Self.startingPoint
        grid[column: 1] = [0, 0, 0]
        #expect(grid[column: 1] == [0, 0, 0])
        let expectedRows = [
            [1, 0, 3],
            [4, 0, 6],
            [7, 0, 9]
        ]
        #expect(grid.rows == expectedRows)
    }
    
    @Test("swap coordinates", arguments: [
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
    
    @Test func swapInvalid() {
        var grid = Self.startingPoint
        let swap1 = grid.swap(
            .init(x: -1, y: -1),
            and: .init(x: 0, y: 0)
        )
        #expect(swap1 == .lhsInvalid)
        let swap2 = grid.swap(
            .init(x: 0, y: 0),
            and: .init(x: -1, y: -1)
        )
        #expect(swap2 == .rhsInvalid)
        let swap3 = grid.swap(
            .init(x: -1, y: -1),
            and: .init(x: -1, y: -1)
        )
        #expect(swap3 == .bothInvalid)
        
        #expect(grid == Self.startingPoint)
    }
    
    @Test("swapRow(_:and:)", arguments: [
        (0, 2, [[7, 8, 9], [4, 5, 6], [1, 2, 3]]),
        (0, 1, [[4, 5, 6], [1, 2, 3], [7, 8, 9]]),
        (1, 2, [[1, 2, 3], [7, 8, 9], [4, 5, 6]])
    ]) func swapRow(lhs: Int, rhs: Int, expectedRows: [[Int]]) {
        var grid = Self.startingPoint
        grid.swapRow(lhs, and: rhs)
        #expect(expectedRows == grid.rows)
    }
    
    @Test("swapColumn(_:and:)", arguments: [
        (0, 1, [[2, 1, 3], [5, 4, 6], [8, 7, 9]]),
        (0, 2, [[3, 2, 1], [6, 5, 4], [9, 8, 7]]),
        (1, 2, [[1, 3, 2], [4, 6, 5], [7, 9, 8]])
    ]) func swapColumn(lhs: Int, rhs: Int, expectedRows: [[Int]]) {
        var grid = Self.startingPoint
        grid.swapColumn(lhs, and: rhs)
        #expect(expectedRows == grid.rows)
    }
    
    
    @Test(arguments: [
        (XYGrid<Int>.ShiftType.row, 0, XYGrid<Int>.ShiftDirection.left, 1, [2, 3, 1]),

        (XYGrid<Int>.ShiftType.row, 0, XYGrid<Int>.ShiftDirection.right, 1, [3, 1, 2]),
        (XYGrid<Int>.ShiftType.column, 0, XYGrid<Int>.ShiftDirection.up, 1, [4, 7, 1]),
        (XYGrid<Int>.ShiftType.column, 0, XYGrid<Int>.ShiftDirection.down, 1, [7, 1, 4]),
        (XYGrid<Int>.ShiftType.row, 0, XYGrid<Int>.ShiftDirection.left, 2, [3, 1, 2]),
        (XYGrid<Int>.ShiftType.row, 0, XYGrid<Int>.ShiftDirection.right, 2, [2, 3, 1]),
        (XYGrid<Int>.ShiftType.column, 0, XYGrid<Int>.ShiftDirection.up, 2, [7, 1, 4]),
        (XYGrid<Int>.ShiftType.column, 0, XYGrid<Int>.ShiftDirection.down, 2, [4, 7, 1]),
    ]) func shiftInline(
        shiftType: XYGrid<Int>.ShiftType,
        index: Int,
        direction: XYGrid<Int>.ShiftDirection,
        by amount: Int,
        expected: [Int]
    ) {
        var grid = Self.startingPoint
        let _ = grid.shift(shiftType, at: index, direction, by: amount)
            .map(\.value)
        #warning("TODO: Check result value")
        
        let message = """

Difference Found...
ShiftType: \(shiftType)
Index: \(index)
Direction: \(direction)
Amount: \(amount)

"""
        
        switch shiftType {
            case .row:
                expectNoDifference(grid.row(at: index), expected, message)
            case .column:
                expectNoDifference(grid.column(at: index), expected, message)
        }
    }
    
    
    // TODO: test the returned result value from `shift(_:at:direction:by:)`
    @Test(arguments: [
        (XYGrid<Int>.ShiftType.row, 0, XYGrid<Int>.ShiftDirection.down, 1, [[4, 5, 6], [1, 2, 3], [7, 8, 9]]),
        (.row, 0, .down, 2, [[4, 5, 6], [7, 8, 9], [1, 2, 3]]),
        (.row, 0, .up, 1, [[4, 5, 6], [7, 8, 9], [1, 2, 3]]),
        (.row, 0, .up, 2, [[4, 5, 6], [1, 2, 3], [7, 8, 9]]),
        (.column, 0, .right, 1, [[2, 1, 3], [5, 4, 6], [8, 7, 9]]),
        (.column, 0, .right, 2, [[2, 3, 1], [5, 6, 4], [8, 9, 7]]),
        (.column, 0, .left, 1, [[2, 3, 1], [5, 6, 4], [8, 9, 7]]),
        (.row, 2, .down, 2, [[1, 2, 3], [7, 8, 9], [4, 5, 6]]),
        (.column, 2, .right, 2, [[1, 3, 2], [4, 6, 5], [7, 9, 8]]),
        (.column, 0, .left, 2, [[2, 1, 3], [5, 4, 6], [8, 7, 9]]),
    ]) func shiftOutOfLine(
        shiftType: XYGrid<Int>.ShiftType,
        index: Int,
        direction: XYGrid<Int>.ShiftDirection,
        by amount: Int,
        expectedRows: [[Int]]
    ) {
        var actualGrid = Self.startingPoint
        let _ = actualGrid.shift(shiftType, at: index, direction, by: amount)
        // TODO: 👆🏼 test the returned result value
        
        let message = """

Difference Found...
ShiftType: \(shiftType)
Index: \(index)
Direction: \(direction)
Amount: \(amount)

"""
        #expect(expectedRows == actualGrid.rows, Comment(rawValue: message))
    }
    
    enum Direction { case above, below, leftOf, rightOf }
    @Test(arguments: [
        (Direction.above, Coordinate(x: 0, y: 0), Coordinate(x: 0, y: 2)),
        (.below, Coordinate(x: 0, y: 1), Coordinate(x: 0, y: 2)),
        (.leftOf, Coordinate(x: 0, y: 0), Coordinate(x: 2, y: 0)),
        (.rightOf, Coordinate(x: 0, y: 0), Coordinate(x: 1, y: 0)),
        (.above, Coordinate(x: 0, y: 1), Coordinate(x: 0, y: 0)),
        (.leftOf, Coordinate(x: 0, y: 1), Coordinate(x: 2, y: 1)),
        (.rightOf, Coordinate(x: 0, y: 1), Coordinate(x: 1, y: 1)),
        (.above, Coordinate(x: 0, y: 2), Coordinate(x: 0, y: 1)),
        (.below, Coordinate(x: 0, y: 2), Coordinate(x: 0, y: 0)),
        (.leftOf, Coordinate(x: 0, y: 2), Coordinate(x: 2, y: 2)),
        (.rightOf, Coordinate(x: 0, y: 2), Coordinate(x: 1, y: 2)),
        (.leftOf, Coordinate(x: 1, y: 0), Coordinate(x: 0, y: 0)),
        (.rightOf, Coordinate(x: 2, y: 0), Coordinate(x: 0, y: 0))
    ]) func relativeCell(direction: Direction, origin: XYGrid<Int>.Coordinate, expectedDest: XYGrid<Int>.Coordinate) {
        let grid = Self.startingPoint
        switch direction {
            case .above: #expect(grid.cell(above: origin) == expectedDest)
            case .below: #expect(grid.cell(below: origin) == expectedDest, "cell(below:): \(grid.cell(below: origin))")
            case .leftOf: #expect(grid.cell(leftOf: origin) == expectedDest)
            case .rightOf: #expect(grid.cell(rightOf: origin) == expectedDest)
        }
    }
    
    @Test(arguments: [
        (XYGrid<Int>.Coordinate(x: 0, y: 0), Direction.above, [[7, 2, 3], [4, 5, 6], [1, 8, 9]]),
        (.init(x: 0, y: 0), .rightOf, [[2, 1, 3], [4, 5, 6], [7, 8, 9]]),
        (.init(x: 0, y: 0), .below, [[4, 2, 3], [1, 5, 6], [7, 8, 9]]),
        (.init(x: 0, y: 0), .leftOf, [[3, 2, 1], [4, 5, 6], [7, 8, 9]]),
        (.init(x: 0, y: 1), .above, [[4, 2, 3], [1, 5, 6], [7, 8, 9]]),
        (.init(x: 0, y: 1), .rightOf, [[1, 2, 3], [5, 4, 6], [7, 8, 9]]),
        (.init(x: 0, y: 1), .below, [[1, 2, 3], [7, 5, 6], [4, 8, 9]]),
        (.init(x: 0, y: 1), .leftOf, [[1, 2, 3], [6, 5, 4], [7, 8, 9]]),
        (.init(x: 0, y: 2), .above, [[1, 2, 3], [7, 5, 6], [4, 8, 9]]),
        (.init(x: 0, y: 2), .rightOf, [[1, 2, 3], [4, 5, 6], [8, 7, 9]]),
        (.init(x: 0, y: 2), .below, [[7, 2, 3], [4, 5, 6], [1, 8, 9]]),
        (.init(x: 0, y: 2), .leftOf, [[1, 2, 3], [4, 5, 6], [9, 8, 7]]),
        (.init(x: 1, y: 0), .above, [[1, 8, 3], [4, 5, 6], [7, 2, 9]]),
        (.init(x: 1, y: 0), .rightOf, [[1, 3, 2], [4, 5, 6], [7, 8, 9]]),
    ]) func swap(origin: XYGrid<Int>.Coordinate, with direction: Direction, expectedRows: [[Int]]) {
        var grid = Self.startingPoint
        switch direction {
            case .above: grid.swapWithCell(above: origin)
            case .below: grid.swapWithCell(below: origin)
            case .leftOf: grid.swapWithCell(leftOf: origin)
            case .rightOf: grid.swapWithCell(rightOf: origin)
        }
        #expect(grid.rows == expectedRows, "origin: \(origin), direction: \(direction)")
    }
    
    @Test func sequence() {
        let grid = Self.startingPoint
        var elements = [Int]()
        for element in grid {
            elements.append(element)
        }
        #expect(elements == [1, 2, 3, 4, 5, 6, 7, 8, 9])
        var reversedElements = [Int]()
        for element in grid.reversed() {
            reversedElements.append(element)
        }
        #expect(reversedElements == [9, 8, 7, 6, 5, 4, 3, 2, 1])
    }
    
//    // MARK: Collection
    @Test func collection() {
        let grid = Self.startingPoint
        let indexAfter = grid.index(after: Coordinate(x: 0, y: 0))
        #expect(indexAfter == Coordinate(x: 1, y: 0))
        
        #expect(grid[Coordinate(x: 1, y: 0)] == 2)
        
        #expect(grid.startIndex == Coordinate(x: 0, y: 0))
        #expect(grid.endIndex == Coordinate(x: 3, y: 2))
        
        let intToStringGrid: [String] = grid.map {
            String($0)
        }
        let expectedStringGrid = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
        #expect(intToStringGrid == expectedStringGrid)
        
        let invalidLookup = grid[Coordinate(x: -1, y: -1)]
        let firstValue = grid[0, 0]
        #expect(invalidLookup == firstValue)
    }
    
}


extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
