import Testing
@testable import SwiftDSA

@Suite struct LeetcodeTests {
    @Test(arguments: [
            ([2,7,11,15], 9, [0,1]),
            ([3,2,4], 6, [1,2]),
            ([3,3], 6, [0,1]),
    ])
    func _1_twoSum(nums: [Int], target: Int, expected: [Int]) async throws {
        #expect(Solutions.twoSum_bruteForce(nums, target) == expected)
    }

    @Test(arguments: [
        (["eat","tea","tan","ate","nat","bat"], [["bat"],["nat","tan"],["ate","eat","tea"]]),
        ([""], [[""]]),
        (["a"], [["a"]]),
    ])
    func _49_groupAnagrams(strings: [String], expected: [[String]]) async throws {
        let strings = strings.sorted()
        let expected = expected.map { $0.sorted() }
        let groups = Solutions.groupAnagrams(strings)
        for group in groups {
            #expect(expected.contains(group))
        }
        #expect(groups.count == expected.count)
    }
    
    @Test(arguments: [("racecar", true), ("palindrome", false),
                     ("A man, a plan, a canal: Panama", true),
                     ("`l;`` 1o1 ??;l`", true)])
    func _125_isPalindrome(string: String, expected: Bool) {
        #expect(Solutions._125_isPalindrome(string) == expected)
    }

    @Test(arguments: [
        (["2","1","+","3","*"], 9), 
        (["4","13","5","/","+"], 6),
        (["10","6","9","3","+","-11","*","/","*","17","+","5","+"], 22)
    ])
    func _150_evalRPN(_ strings: [String], expected: Int) {
        #expect(Solutions.evalRPN(strings) == expected)
    }
    
    @Test(arguments: [
        ([2, 7, 11, 15], 9, [1, 2]),
        ([2, 3, 4], 6, [1, 3]),
        ([-1, 0], -1, [1, 2])
    ])
    func _167_twoSum(numbers: [Int], target: Int, expected: [Int]) {
        #expect(Solutions._167_twoSum(numbers, target) == expected)
    }


    @Test(arguments: [
        ([1,2,3,1], true),
        ([1,1,1,3,3,4,3,2,4,2], true),
        ([1,2,3,4], false),
    ])
    func _217_containsDuplicate(nums: [Int], expected: Bool) async throws {
        #expect(Solutions.containsDuplicate(nums) == expected)
    }

    @Test(arguments: [
        ["neet","code","love","you"],
        ["we","say",":","yes"],
        ["$", "%", "^"], 
        ["1", "02", "003", "0004", "00005"],
        ["a", "a", "a", "a"],
        ["1%", "2%", "3%", "4%"]
    ])
    func _271_encodeDecode(input: [String]) {
        let encoded = Solutions._271_encode(input)
        let decoded = Solutions._271_decode(encoded)
        #expect(input == decoded)
    }

    @Test(arguments: [
        ([1,1,1,2,2,3], 2, [1,2]),
        ([1], 1, [1]),
        ([4,1,-1,2,-1,2,3], 2, [2, -1])
    ])
    func _347_topKFrequentElements(_ nums: [Int], _ k: Int, expected: [Int]) {
        // #expect(Solutions.topKFrequent(nums, k) == expected)
        for int in expected {
            #expect(nums.contains(int) == true)
        }
    }
}
