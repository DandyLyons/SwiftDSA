extension Solutions {
    
///    Leetcode: https://leetcode.com/problems/two-sum-ii-input-array-is-sorted/description/
///
///    Given an array of integers numbers that is sorted in non-decreasing order.
///
///    Return the indices (1-indexed) of two numbers, [index1, index2], such that they add up to a given target number target and index1 < index2. Note that index1 and index2 cannot be equal, therefore you may not use the same element twice.
///
///    There will always be exactly one valid solution.
///
///    Your solution must use
///    O
///    (
///        1
///    )
///    O(1) additional space.
///
///    Example 1:
///
///    Input: numbers = [1,2,3,4], target = 3
///
///    Output: [1,2]
///Explanation:
///    The sum of 1 and 2 is 3. Since we are assuming a 1-indexed array, index1 = 1, index2 = 2. We return [1, 2].
///
///Constraints:
///
///    2 <= numbers.length <= 1000
///    -1000 <= numbers[i] <= 1000
///    -1000 <= target <= 1000
    static func _167_twoSum(_ numbers: [Int], _ target: Int) -> [Int] {
        var startIDX = numbers.startIndex
        var endIDX = numbers.endIndex - 1 // Swift endIndex is the "past the end" position
        
        while startIDX < endIDX {
            let sum = numbers[startIDX] + numbers[endIDX]
            if sum == target {
                return [startIDX + 1, endIDX + 1]
            } else if sum > target {
                endIDX -= 1
            } else if sum < target {
                startIDX += 1
            }
        }
// Leetcode: There is exactly one (not zero) solutions.
// Therefore it shouldn't be possible to get here.
        return [startIDX + 1, endIDX + 1]
    }
}
