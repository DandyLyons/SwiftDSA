extension XYGrid {
    public struct Coordinate: Hashable, Sendable, Codable {
        public var x: Int
        public var y: Int
        
        public init(x: Int, y: Int) {
            self.x = x
            self.y = y
        }
    }
}

// MARK: Validation
extension XYGrid {
    public func isValid(_ coord: Coordinate) -> Bool {
        coord.x >= 0 && coord.x < columnsCount &&
        coord.y >= 0 && coord.y < rowsCount
    }
}


// MARK: Relative Coordinates
extension XYGrid {
    public func cell(above coord: Coordinate) -> Coordinate {
        let new_y = if (coord.y - 1) < 0 {
            lastRowIndex
        } else {
            coord.y - 1
        }
        return Coordinate(x: coord.x, y: new_y)
    }

    public func cell(below coord: Coordinate) -> Coordinate {
        let new_y = if (coord.y + 1) > lastRowIndex {
            0
        } else {
            coord.y + 1
        }
        return Coordinate(x: coord.x, y: new_y)
    }

    public func cell(leftOf coord: Coordinate) -> Coordinate {
        let new_x = if (coord.x - 1) < 0 {
            lastColumnIndex
        } else {
            coord.x - 1
        }
        return Coordinate(x: new_x, y: coord.y)
    }

    public func cell(rightOf coord: Coordinate) -> Coordinate {
        let new_x = if (coord.x + 1) > lastColumnIndex {
            0
        } else {
            coord.x + 1
        }
        return Coordinate(x: new_x, y: coord.y)
    }
}
