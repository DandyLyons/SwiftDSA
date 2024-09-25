extension Solutions {
    /// 49. Group Anagrams
    /// 
    /// Given an array of strings `strs`, group the anagrams together. You can return the answer in any order.
    /// An Anagram is a word or phrase formed by rearranging the letters of a different word or phrase, 
    /// typically using all the original letters exactly once.
    /// 
    /// Note: Every input string will only be lowercase letters. 
    ///
    /// **Example 1:**
    ///
    /// Input: strs = ["eat","tea","tan","ate","nat","bat"]
    /// Output: [["bat"],["nat","tan"],["ate","eat","tea"]]
    ///
    /// **Example 2:**
    ///
    /// Input: strs = [""]
    /// Output: [[""]]
    ///
    /// **Example 3:**
    ///
    /// Input: strs = ["a"]
    /// Output: [["a"]]
    /// - Time complexity: O(n * k), where n is the number of strings and k is the average length of the strings.
    static func groupAnagrams(_ strings: [String]) -> [[String]] {
        typealias Key = [Int]
        typealias AnagramCount = [Key: [String]]

        var anagramCounts: AnagramCount = [:]
        for string in strings {
            var key: Key = Array(repeating: 0, count: 26)
            for char in string {
                let letterValue = char.letterValue!
                key[letterValue] += 1
            }
            anagramCounts[key, default: []].append(string)
        }
        return Array(anagramCounts.values)
    }
}

extension Character {
    var letterValue: Int? {
        guard let value = self.asciiValue else { return nil }
        return Int(value) - Int(Character("a").asciiValue!)
    }
}

extension Dictionary where Value == Int {
    mutating func increment(forKey key: Key) {
        self[key, default: 0] += 1
    }
}