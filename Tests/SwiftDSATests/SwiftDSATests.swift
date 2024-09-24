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

    @Test(arguments: [
        ([1,2,3,1], true),
        ([1,1,1,3,3,4,3,2,4,2], true),
        ([1,2,3,4], false),
    ])
    func _217_containsDuplicate(nums: [Int], expected: Bool) async throws {
        #expect(Solutions.containsDuplicate(nums) == expected)
    }

}