
extension Solutions {
    
    /// Given an array of integers nums which is sorted in ascending order, and an integer target, write a function to search target in nums. If target exists, then return its index. Otherwise, return -1.
    ///
    /// >Time Complexity: O(log n)
    static func _704_binarySearch(_ nums: [Int], _ target: Int) -> Int {
        var left = 0
        var right = nums.endIndex - 1
        
        while left <= right {
            let middle = (left + right) / 2
            let current = nums[middle]
            if current == target {
                return middle
            } else if current > target {
                right = middle - 1
            } else if current < target {
                left = middle + 1
            }
        }
        return -1
    }
}
