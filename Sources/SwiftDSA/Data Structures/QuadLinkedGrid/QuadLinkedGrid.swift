public struct QuadLinkedGrid<Element> {
    public var root: Node<Element>
    public let rowsCount: Int
    public let columnsCount: Int
    
    /// the amount of elements in the grid
    public var count: Int {
        rowsCount * columnsCount
    }
    
    /// Creates a grid at the given size with the given default value in every space
    ///
    /// Precondition: Both `rows` and `columns` should be > 1
    public init(rows: Int, columns: Int, defaultValue: Element) {
        precondition(rows > 1 && columns > 1, "Grid must have more than 1 row and more than 1 column.")
        
        self.rowsCount = rows
        self.columnsCount = columns
        
        // Create the root node (top-left)
        self.root = Node(value: defaultValue)
        
        var previousRows: [Node<Element>] = []
        var firstInCurrentRow: Node<Element>? = self.root
        
        for rowIndex in 0..<rows {
            var currentRow: [Node<Element>] = []
            
            for columnIndex in 0..<columns {
                let newNode: Node<Element>
                
                if rowIndex == 0 && columnIndex == 0 {
                    // This is the root node
                    newNode = self.root
                } else {
                    newNode = Node(value: defaultValue)
                }
                
                // Link to the node on the left
                if let leftNode = currentRow.last {
                    newNode.left = leftNode
                    leftNode.right = newNode
                }
                
                // Link to the node above
                if let aboveNode = previousRows[safe: columnIndex] {
                    newNode.up = aboveNode
                    aboveNode.down = newNode
                }
                
                currentRow.append(newNode)
            }
            
            // Set first node in next row
            firstInCurrentRow?.down = currentRow.first
            firstInCurrentRow = currentRow.first
            
            previousRows = currentRow
        }
    }
    
    /// Creates a grid with the given elements and columns
    /// - Parameters:
    ///   - elements: the elements to be added to the grid
    ///   - columns: the amount of columns that the grid should have
    ///
    /// >Precondition: elements array must contain no less than 4 elements
    ///
    /// >Precondition: columns must be 2 or more
    ///
    /// >Precondition: count of `elements` must be evenly divisible by `columns`
    public init(elements: [Element], columns: Int) {
        self.rowsCount = elements.count % columns
        self.columnsCount = columns
        precondition(elements.count >= 4, "Not enough elements: \(elements.count)")
        precondition(columns > 2, "Not enough columns: \(columns)")
        precondition(elements.count & columns == 0, "count of `elements` must be evenly divisible by `columns`")
        self.root = Node(value: elements.first!)
        var currentElementsIndex = 1 // the second element
        var previousRows = [Node<Element>]()
        var firstInCurrentRow: Node<Element>? = self.root
        for rowIndex in 0..<rowsCount {
            var currentRow: [Node<Element>] = []
            
            for columnIndex in 0..<columnsCount {
                let newNode: Node<Element>
                
                if rowIndex == 0 && columnIndex == 0 {
                    // This is the root node
                    newNode = self.root
                } else {
                    newNode = Node(value: elements[currentElementsIndex])
                    currentElementsIndex += 1
                }
                
                // Link to the node on the left
                if let leftNode = currentRow.last {
                    newNode.left = leftNode
                    leftNode.right = newNode
                }
                
                // Link to the node above
                if let aboveNode = previousRows[safe: columnIndex] {
                    newNode.up = aboveNode
                    aboveNode.down = newNode
                }
                
                currentRow.append(newNode)
            }
            
            // Set first node in next row
            firstInCurrentRow?.down = currentRow.first
            firstInCurrentRow = currentRow.first
            
            previousRows = currentRow
        }
        
    }
    
    /// Get or set the value at the given x,y coordinate (0-based)
    public subscript(x x: Int, y y: Int) -> Element? {
        get {
            guard x >= 0 && x < columnsCount && y >= 0 && y < rowsCount else { return nil }
            
            var currentNode = root
            
            // Move down
            for _ in 0..<y {
                guard let nextNode = currentNode.down else { return nil }
                currentNode = nextNode
            }
            
            // Move right
            for _ in 0..<x {
                guard let nextNode = currentNode.right else { return nil }
                currentNode = nextNode
            }
            
            return currentNode.value
        }
        set {
            guard x >= 0 && x < columnsCount && y >= 0 && y < rowsCount, let newValue = newValue else { return }
            
            var currentNode = root
            
            // Move down
            for _ in 0..<y {
                guard let nextNode = currentNode.down else { return }
                currentNode = nextNode
            }
            
            // Move right
            for _ in 0..<x {
                guard let nextNode = currentNode.right else { return }
                currentNode = nextNode
            }
            
            currentNode.value = newValue
        }
    }
    
    /// Returns the row at the given 0-based index as an array with values laid out left to right
    public func row(at rowIndex: Int) -> [Element] {
        var currentNode: Node? = self.root
        for _ in 0..<rowIndex {
            currentNode = currentNode?.down
        }
        var row = [Element]()
        while let currentValue = currentNode?.value {
            row.append(currentValue)
            currentNode = currentNode?.right
        }
        return row
    }
    
    /// Returns row at the given 0-based index as an array of nodes laid out left to right
    func rowNodes(at rowIndex: Int) -> [Node<Element>] {
        var currentNode: Node? = self.root
        for _ in 0..<rowIndex {
            currentNode = currentNode?.down
        }
        var row = [Node<Element>]()
        while let nodeToAppend = currentNode {
            row.append(nodeToAppend)
            currentNode = currentNode?.right
        }
        return row
    }
    
    /// Returns the column at the given 0-based index as an array with values laid out top to bottom
    public func column(at columnIndex: Int) -> [Element] {
        var currentNode: Node? = self.root
        for _ in 0..<columnIndex {
            currentNode = currentNode?.down
        }
        var row = [Element]()
        while let currentValue = currentNode?.value {
            row.append(currentValue)
            currentNode = currentNode?.down
        }
        return row
    }
    
    /// Returns the column at the given 0-based index as an array with values laid out top to bottom
    func columnNodes(at columnIndex: Int) -> [Node<Element>] {
        var currentNode: Node? = self.root
        for _ in 0..<columnIndex {
            currentNode = currentNode?.down
        }
        var row = [Node<Element>]()
        while let nodeToAppend = currentNode {
            row.append(nodeToAppend)
            currentNode = currentNode?.down
        }
        return row
    }
    
    /// Returns an array of rows of elements from top to bottom
    ///
    /// Rows are arranged from top to bottom. Columns are arranged from left to right.
    ///
    /// >Time Complexity: O(n^2).
    /// >Not intended for large data sets. Very poor performance. Should optimize later.
    public var rows: [[Element]] {
        var rows = [[Element]]()
        
        for rowIndex in 0..<rowsCount {
            var currentRow = [Element]()
            for columnIndex in 0..<columnsCount {
                guard let node = self[x: columnIndex, y: rowIndex] else {
                    fatalError("🔴A node was not found where one was expected.")
                }
                currentRow.append(node)
            }
            rows.append(currentRow)
        }
        return rows
    }
    
    /// Returns an array of columns of elements from left to right
    ///
    /// Rows are arranged from top to bottom. Columns are arranged from left to right.
    ///
    /// >Time Complexity: O(n^2).
    /// >Not intended for large data sets. Very poor performance. Should optimize later.
    public var columns: [[Element]] {
        var columns = [[Element]]()
        for columnIndex in 0..<columnsCount {
            var currentColumn = [Element]()
            for rowIndex in 0..<rowsCount {
                guard let node = self[x: columnIndex, y: rowIndex] else {
                    fatalError("🔴 A node was not found where one was expected.")
                }
                currentColumn.append(node)
            }
            columns.append(currentColumn)
        }
        return columns
    }
    
    /// Returns a flat array of all the elements, in order, from top-left to bottom-right
    public var allElements: [Element] {
        rows.reduce([Element]()) { allElements, nextRow in  allElements + nextRow }
    }
    
    public enum ShiftType { case row, column }
    public enum ShiftDirection { case up, down, left, right }
    
    /// shifts row or column in the given direction, by the given amount of spaces
    /// - Parameters:
    ///   - shiftType: row or column
    ///   - index: the 0-based index of the row or column you would like to shift
    ///   - direction: the direction to shift
    ///   - shiftAmount: the amount of spaces to shift it
    /// - Returns: a tuple consisting of `shifted`, a bool indicating if the shift was successful and
    /// `result`, the row or column that was shifted, after the operation
    ///
    /// A node that moves off an edge will be "teleported" to the opposite end. For example, if the row is
    /// `[0, 1, 2]` and we shift it left, then the row will become `[1, 2, 0]`. If we shift it right then it will become
    /// `[2, 0, 1]`.
    ///
    /// Note: If given an invalid row or column index, this function will do nothing and return immediately.
    ///
    /// ## Invalid Shift Types
    /// Currently a row, can only shift left or right, not up or down. Also, a column can only shift up or down, not left or right.
    /// (This functionality may or may not be added later). Invalid shift combinations will do nothing and return immediately.
    ///
    /// # Example Usage
    /// ```swift
    /// grid.shift(.row, at: 3, .right, by: 2)
    /// // shifts the row at index 3 in the right direction by 2 spaces
    /// ```
    @discardableResult
    public mutating func shift(
        _ shiftType: ShiftType,
        at index: Int,
        _ direction: ShiftDirection,
        by shiftAmount: Int = 1
    ) -> (shifted: Bool, result: [Element]) {
        // Immediately do othing and return if given an invalid index.
        guard index > 0 else { return (shifted: false, result: [] )}
        switch shiftType {
            case .row:
                guard rowsCount > index else { return (shifted: false, result: [] ) }
            case .column:
                guard columnsCount > index else { return (shifted: false, result: [] ) }
        }
        switch (shiftType, direction) {
            case (.row, .up), (.row, .down), (.column, .left), (.column, .right):
                print("This type of shift is not currently supported. \(shiftAmount), \(direction)")
                return (shifted: false, result: [])
            default: break // this is a valid shift
        }
        
        var currentShiftIteration = 0
        while currentShiftIteration < shiftAmount {
            switch (shiftType, direction) {
                case (.row, .left):
                    let row = rowNodes(at: index)
                    shiftRowLeft(row: row)
                case (.row, .right):
                    let row = rowNodes(at: index)
                    shiftRowRight(row: row)
                case (.column, .left):
                    let column = columnNodes(at: index)
                    shiftColumnLeft(column: column)
                case (.column, .right):
                    let column = columnNodes(at: index)
                    shiftColumnRight(column: column)
                default: return (shifted: false, result: []) // it should not be possible to get here
            }
            
            currentShiftIteration += 1
        }
        return (shifted: false, result: [])
    }
    
    /// Shift the row left by one space
    private func shiftRowLeft(row: [Node<Element>]) {
        assert(row.count > 1, "All rows should have more than 1 element.")
        guard let lastNodeInRow = row.last else {
            return
        }
        for node in row {
            if node.isFarLeft {
                node.left = row.last
            }
            if node.isFarRight {
                node.right = row.first
            }
            node.up = node.up?.left
            node.down = node.down?.left
        }
    }
    
    private func shiftRowRight(row: [Node<Element>]) {
        
    }
    
    private func shiftColumnLeft(column: [Node<Element>]) {
        
    }
    
    private func shiftColumnRight(column: [Node<Element>]) {
        
    }
    
    private func lastNodeInRow(for node: Node<Element>) -> Node<Element> {
        var prevNode: Node? = node
        var node: Node? = node.right
        while let currentNode = node {
            prevNode = node
            node = currentNode.right
        }
        return prevNode!
    }
    
    private func lastNodeInColumn(for node: Node<Element>) -> Node<Element> {
        var prevNode: Node? = node
        var node: Node? = node.right
        while let currentNode = node {
            prevNode = node
            node = currentNode.down
        }
        return prevNode!
    }
}

extension QuadLinkedGrid {
    public class Node<Value> {
        public var value: Value
        public var up: Node<Value>?
        public var down: Node<Value>?
        public var left: Node<Value>?
        public var right: Node<Value>?
        
        public init(value: Value) {
            self.value = value
        }
        
        var isOnTop: Bool {
            self.up == nil
        }
        var isOnBottom: Bool {
            self.down == nil
        }
        var isFarLeft: Bool {
            self.left == nil
        }
        var isFarRight: Bool {
            self.right == nil
        }
    }
    
}

// Helper extension to safely access array elements
extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
