public struct QuadLinkedGrid<Element> {
    public var root: Node<Element>
    public let rowsCount: Int
    public let columnsCount: Int
    
    /// the amount of elements in the grid
    public var count: Int {
        rowsCount * columnsCount
    }
    
    public init(rows: Int, columns: Int, defaultValue: Element) {
        precondition(rows > 0 && columns > 0, "Grid must have at least one row and one column")
        
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
    
    /// Get or set the value at the given x,y coordinate
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
    
    /// Returns the row at the given 0-based index as an array with values laid out top to bottom
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
    }
}

// Helper extension to safely access array elements
extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
