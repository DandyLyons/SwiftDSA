extension Solutions {
    /// Check if these are valid parentheses
    ///
    /// Leetcode: https://leetcode.com/problems/valid-parentheses/submissions/1402302875/
    /// Neetcode: https://neetcode.io/problems/validate-parentheses
    public static func _20_validParentheses(_ s: String) -> Bool {
        var stack: Stack<Character> = Stack([])
        let pairsDict: Dictionary<Character, Character> = [")": "(", "]": "[", "}": "{", ">": "<"]
        for char in s {
            if pairsDict.values.contains(char) {
                stack.push(char)
            } else {
                guard let last = stack.peek(),
                      last == pairsDict[char] else {
                    return false
                }
                stack.pop()
            }
        }
        return stack.isEmpty
    }
}
