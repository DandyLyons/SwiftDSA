extension Solutions {
    public static func _15_threeSum(_ nums: [Int]) -> [[Int]] {
        guard nums.count >= 3 else { return [[]]}
        let nums = nums.sorted()
        var result = Set<[Int]>()
        
        for (first_idx, first) in nums.enumerated() {
            if first_idx > 0, first == nums[first_idx - 1] {
                continue
            }
            
            var second_idx = nums.index(after: first_idx)
            var third_idx = nums.endIndex - 1
            
            while second_idx < third_idx {
                let left = nums[second_idx]
                let right = nums[third_idx]
                
                if first + left + right == 0 {
                    result.insert([first, left, right])
                    second_idx += 1
                } else if first + left + right > 0 {
                    third_idx -= 1
                } else if first + left + right < 0 {
                    second_idx += 1
                }
            }
        }
        
        return Array(result)
    }
}
