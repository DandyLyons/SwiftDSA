extension Solutions {
    /// Design a stack that supports push, pop, top, and retrieving the minimum element in constant time.
    ///
    /// Time Complexity: O(1)
    ///
    /// Leetcode: https://leetcode.com/problems/min-stack/description/
    class MinStack {
        private var array: [(value: Int, min: Int)]
        
        init() {
            self.array = []
        }
        
        /// push
        ///
        /// >Time Complexity: O(1)
        func push(_ val: Int) {
            let smallest: Int
            if let lastMin = array.last?.min {
                smallest = min(lastMin, val)
            } else {
                smallest = val
            }
            
            array.append((value: val, min: smallest))
        }
        
        func pop() {
            _ = self.array.popLast()
        }
        
        func top() -> Int {
            self.array.last?.value ?? 0
        }
        
        func getMin() -> Int {
            self.array.last?.min ?? 0
        }
    }
    
    /**
     * Your MinStack object will be instantiated and called as such:
     * let obj = MinStack()
     * obj.push(val)
     * obj.pop()
     * let ret_3: Int = obj.top()
     * let ret_4: Int = obj.getMin()
     */
}
