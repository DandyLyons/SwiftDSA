import IssueReporting

extension XYGrid: Collection {
    public func index(after i: Coordinate) -> Coordinate {
        guard isValid(i) else {
            reportIssue("Encountered an invalid coordinate: \(i) in index(after:)")
            return Coordinate(x: lastColumnIndex, y: lastRowIndex)
        }
        
        var result = i
        // increment x unless it's out of bounds
        // then increment y
        
        if result.x == lastColumnIndex && result.y == lastRowIndex {
            // this is the last cell
            result.x += 1
        } else if result.x >= lastColumnIndex {
            // this is the last
            result.x = 0
            result.y += 1
        } else {
            result.x += 1
        }
        
        return result
    }
    
    public subscript(position: Coordinate) -> Element {
        get {
            self[xy: position] ?? self[xy: Coordinate(x: 0, y: 0)]!
        }
    }
    
    public var startIndex: Coordinate {
        Coordinate(x: 0, y: 0)
    }
    
    // the "past the end" position
    public var endIndex: Coordinate {
        Coordinate(x: lastColumnIndex + 1, y: lastRowIndex)
    }
    
    
    public typealias Index = Coordinate
    
}
