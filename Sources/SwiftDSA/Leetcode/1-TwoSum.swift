extension Solutions {
    /// Slow solution: O(n^2)
    static func twoSum_bruteForce(_ nums: [Int], _ target: Int) -> [Int] {
        var result = (0,1)
        
        for _ in nums {
            for _ in nums[result.1..<nums.count] {
                if (nums[result.0] + nums[result.1]) == target {
                    return [result.0, result.1]
                }
                
                result.1 += 1
                
                if result.1 == nums.count {
                    result.0 += 1
                    result.1 = result.0 + 1
                }
                
                if result.1 == nums.count {
                    return []
                }
                
            }
            
        }
        return []
    }
}