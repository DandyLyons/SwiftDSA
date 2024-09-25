extension Solutions {
    /// Leetcode: https://leetcode.com/problems/valid-palindrome/
    /// Neetcode: https://neetcode.io/problems/is-palindrome
    static func _125_isPalindrome(_ s: String) -> Bool {
        let s = s
            .filter { char in char.isNumber || char.isLetter } // O(n)
            .lowercased() // O(n)
        
        let sReversed = s.reversed() // O(1)
        
        return s == String.init(sReversed) // I believe this is O(1), possibly O(n)
    }
}
