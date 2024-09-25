extension Solutions {
    /// Given n pairs of parentheses,  generates all combinations of well-formed parentheses.
    ///
    /// https://leetcode.com/problems/generate-parentheses/
    /// https://neetcode.io/problems/generate-parentheses
    static func _22_generateParenthesis(_ n: Int) -> [String] {
        // only add open parens if if open < n
        // only add closing parens if closed < open
        // valid if open == closed == n
        var stack = Stack<Character>()
        var result = [String]()
        
        func backtrack(openN: Int, closedN: Int) {
            if openN == closedN,
               closedN == n {
                result.append(String(stack))
            }
            
            if openN < n {
                stack.push("(")
                backtrack(openN: openN + 1, closedN: closedN)
                stack.pop()
            }
            
            if closedN < openN {
                stack.push(")")
                backtrack(openN: openN, closedN: closedN + 1)
                stack.pop()
            }
        }
        backtrack(openN: 0, closedN: 0)
        return result
    }
}
