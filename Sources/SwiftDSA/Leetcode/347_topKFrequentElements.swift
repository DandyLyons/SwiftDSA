extension Solutions {
    /// Given an integer array nums and an integer k, return the k most frequent elements. You may return the answer in any order.
    /// 
    /// https://leetcode.com/problems/top-k-frequent-elements/
    /// 
    /// Time Complexity: O(N log N)
    static func topKFrequent(_ nums: [Int], _ k: Int) -> [Int] {
        var count = [Int: Int]()
        for num in nums {
            count[num, default: 1] += 1
        }
        let sortedValues = count.sorted { 
            $0.value > $1.value
        }.map { $0.key }

        return Array(sortedValues.prefix(k))
    }
}